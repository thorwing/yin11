require "securerandom"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Available
  include Followable
  include SilverSphinxModel

  #TODO for Rails 3.1
  #has_secure_password

  #Fields
  field :email
  field :login_name
  field :password_hash
  field :password_salt
  field :role, :type => Integer, :default => NORMAL_USER_ROLE
  field :auth_token
  field :password_reset_token
  field :password_reset_sent_at, :type => DateTime
  field :email_verified, :type => Boolean, :default => false
  field :email_verification_token
  field :provider
  field :uid
  field :access_token
  field :access_token_secret
  field :is_master, :type => Boolean, :default => false
  field :biography, type: String
  field :score, :type => Integer, :default => 0
  field :left_score, :type => Integer, :default => 0
  #cached fields
  field :remote_ip
  field :liked_recipe_ids, :type => Array, :default => []
  field :liked_product_ids, :type => Array, :default => []
  field :liked_album_ids, :type => Array, :default => []
  field :recipes_count, type: Integer, default: 0

  mount_uploader :avatar, AvatarUploader
  mount_uploader :thumb, ThumbUploader

  search_index(:fields => [:login_name],
              :attributes => [:created_at])

  index :provider
  index :uid
  index :auth_token

  attr_accessor :password, :crop_x, :crop_y, :crop_h, :crop_w
  attr_accessible :email, :login_name, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at, :email_verification_token, :avatar, :thumb, :group_ids, :biography, :is_master

  # strange error when trying to using scope, so using class method instead
  scope :masters, where(:is_master => true)
  scope :rookies, where(:is_master => false)
  scope :valid_email_users, where(:email_verified => true)
  class << self
    def of_auth_token(token)
      first(:conditions => {:auth_token => token})
    end

    def of_email(email)
      first(:conditions => {:email => email})
    end
  end

  #Relationships
  has_many :recipes, :inverse_of => "author"
  has_many :albums, :inverse_of => "author"
  has_many :desires, :inverse_of => "author"
  has_many :solutions, :inverse_of => "author"
  has_and_belongs_to_many :admired_desires, :class_name => "Desire", :inverse_of => "admirers", index: true
  has_and_belongs_to_many :awards, class_name: "Award", inverse_of: "winners", index: true
  embeds_many :relationships
  embeds_many :feeds
  embeds_many :notifications
  embeds_many :messages

  #Validators
  validate :login_name_is_unique
  validates :email,
              :presence => true,
              :uniqueness => true,
              :email_format => true,
              :if => :non_third_party_login
  validates_presence_of :login_name
  validates_length_of :login_name, :maximum => 15 #or 30 eng charactors, a validation should be implemented
  validates_presence_of :password, :on => :create, :if => :non_third_party_login
  validates_confirmation_of :password, :if => :non_third_party_login
  validates_length_of :password, :minimum => 6, :on => :create, :if => :non_third_party_login
  validates_length_of :biography, :maximum => 200

  #Others
  before_save :encrypt_password, :handle_identity
  before_create { generate_token(:auth_token)
                  generate_token(:email_verification_token)}
  after_update :reprocess_avatar, :if => :cropping?

  before_save do |doc|
    doc.recipes_count = doc.recipes.count
  end

  #for multilstep form
  attr_writer :current_step

  def steps
    #%w[custom_groups custom_basic_info]
    %w[custom_basic_info custom_avatar custom_password]
  end

  def current_step
	  @current_step || steps.first
  end

  def tags
    groups.collect{|g| g.tags}.flatten.compact.uniq
  end

  def authenticate(password)
    if password.present? && self.password_hash.present? && self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
      true
    else
      false
    end
  end

  def send_password_reset
    p self.email
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_email_verification
    UserMailer.email_verify(self).deliver
  end

  def send_updates
    items = get_updates
    UserMailer.updates(self, items).deliver
  end

  def verify_email!
    self.role = NORMAL_USER_ROLE
    self.email_verification_token = nil
    self.email_verified = true
    self.save!
  end

  def self.is_email_available?(email)
    User.first(:conditions => { :email => email}).nil?
  end

  def self.is_login_name_available?(login_name)
    User.first(:conditions => { :login_name => login_name, :provider => SELF_PROVIDER}).nil?
  end

  def get_avatar(version = nil, origin = true)
    if self.thumb? && version == :thumb
      return self.thumb_url
    end

    if self.avatar?
      return self.avatar_url(version)
    end

    #origin url is used for image_tag, the other one is used for waterfall displaying
    prefix = origin ? '' : '/assets/'
    prefix + "default_head_100.jpg"
  end

  def has_avatar?
    self.avatar_url.present?
  end


  #TODO max followed users
  def following_users(limit = 100)
    User.any_in(_id: self.relationships.where(target_type: "User").limit(limit).map(&:target_id))
  end

  def liked_recipes(limit = 7)
    Recipe.any_in(_id: self.liked_recipe_ids).limit(limit)
  end

  def liked_albums(limit = 7)
    Album.any_in(_id: self.liked_album_ids).limit(limit)
  end

  def liked_products(limit = 7)
    Product.any_in(_id: self.liked_product_ids).limit(limit)
  end

  def vote_weight
    if has_permission?(:administrator)
      ADMIN_VOTE_WEIGHT
    elsif has_permission?(:editor)
      EDITOR_VOTE_WEIGHT
    else
      NORMAL_USER_VOTE_WEIGHT
    end
  end

  def has_permission?(permission)
    return false unless self.enabled
    case permission
      when :inactive_user
        self.role >= INACTIVE_USER_ROLE
      when :normal_user
        self.role >= NORMAL_USER_ROLE
      when :editor
        self.role >= EDITOR_ROLE
      when :administrator
        self.role == ADMIN_ROLE
      else
        raise "invalid permission"
    end
  end

  def get_recent_feeds(limit)
    feeds = self.feeds.desc(:created_at)
    feeds.select{|f| [Recipe.name, Desire.name].include? f.target_type }.reject{|f| f.picture_url.blank? }.uniq{|f| f.identity}[0..(limit-1)]
  end

  def unread_notifications
    self.notifications.where(read: false).desc(:created_at)
  end

  def has_followed?(target)
    self.relationships.select{|r| r.target_type == target.class.name && r.target_id == target.id.to_s}.size > 0
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry
    #default size
    width = AVATAR_LARGE_WIDTH
    height = AVATAR_LARGE_HEIGHT

    if avatar?
      img = Magick::Image::from_blob(self.avatar.read).first
      width = img.columns
      height = img.rows
    end

    @geometry = {:width => width, :height => height }
  end

  def collected_albums(desire)
    collected = []
    self.albums.each do |album|
      if album.desire_ids.include?(desire.id)
        collected << album
      end
    end

    return collected
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def handle_identity
    self.provider ||= SELF_PROVIDER
    self.uid ||= self.email
  end

  def generate_token(column)
     begin
       self[column] = SecureRandom.urlsafe_base64
     end while User.exists?(:conditions => {column => self[column]})
  end

  def non_third_party_login
    provider.blank?
  end

  def reprocess_avatar
    self.avatar.recreate_versions!
  end

  def login_name_is_unique
    if self.new_record? && User.first(conditions: { provider: self.provider, login_name: self.login_name})
      errors.add(:base, I18n.t("validations.login_name_duplicate"))
    end
  end

end
