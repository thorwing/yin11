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
  #cached fields
  field :reviews_count, :type => Integer

  mount_uploader :avatar, AvatarUploader

  search_index(:fields => [:login_name],
              :attributes => [:created_at])

  index :provider
  index :uid
  index :auth_token

  attr_accessor :password
  attr_accessible :email, :login_name, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at, :email_verification_token, :avatar, :group_ids

  # strange error when trying to using scope, so using class method instead
  scope :masters, where(:is_master => true)
  scope :rookies, where(:is_master => false)
  scope :valid_email_users, where(:email_verified => true)
  scope :mail_receiver, where("profile.receive_mails" => true)
  class << self
    def of_auth_token(token)
      first(:conditions => {:auth_token => token})
    end

    def of_email(email)
      first(:conditions => {:email => email})
    end
  end

  #Relationships
  embeds_one :profile
  embeds_one :contribution
  has_many :articles, :inverse_of => "author"
  has_many :reviews, :inverse_of => "author"
  has_many :recipes, :inverse_of => "author"
  has_and_belongs_to_many :groups, :inverse_of => "members"
  has_and_belongs_to_many :badges
  has_many :vendors
  embeds_many :relationships
  embeds_many :feeds

  #Validators
  validates :email,
              :presence => true,
              :uniqueness => true,
              :email_format => true,
              :if => :non_third_party_login
  #validates_presence_of :login_name
  validates_length_of :login_name, :maximum => 30 #or 15 chinese charactors, a validation should be implemented
  validates_presence_of :password, :on => :create, :if => :non_third_party_login
  validates_confirmation_of :password, :if => :non_third_party_login
  validates_length_of :password, :minimum => 6, :on => :create, :if => :non_third_party_login
  validates_associated :profile, :contribution

  #Others
  after_initialize { self.profile ||= Profile.new; self.contribution ||= Contribution.new }
  before_save :encrypt_password, :handle_identity, :sync_cached_fields
  before_create { generate_token(:auth_token)
                  generate_token(:email_verification_token)}

  def screen_name
    login_name.present? ? login_name : email
  end

  def tags
    groups.collect{|g| g.tags}.flatten.compact.uniq
  end

  def authenticate(password)
    if password.present? && self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
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

  def get_avatar(thumb = false, origin = true)
    if self.avatar?
      thumb ? self.avatar_url(:thumb) : self.avatar_url
    else
      #origin url is used for image_tag, the other one is used for waterfall displaying
      origin ? "default_user.png" : "/assets/default_user.png"
    end
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

  def members_from_same_group
    groups.inject([]) {|memo, group| memo | group.member_ids }
  end

  def get_evaluation(days = self.profile.concern_days)
    data = get_raw_updates(days)
    result = {}
    data.each do |k,v|
      result[k] = v.size #EvaluationManager.evaluate_items(v)
    end
    result
  end

  def get_updates(days = self.profile.concern_days)
    data = get_raw_updates(days)
    data.inject([]){|memo, (k,v)| memo | v}.compact.uniq
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

  def sync_cached_fields
    self.reviews_count = self.reviews.size
  end

  def generate_token(column)
     begin
       self[column] = SecureRandom.urlsafe_base64
     end while User.exists?(:conditions => {column => self[column]})
  end

  #def get_raw_updates(days)
  #  data = {}
  #  self.tags.map{|t| data[t] = []}
  #  InfoItem.enabled.in_days_of(days).tagged_with(self.tags).all.each do |item|
  #    (self.tags & item.tags).each do |tag|
  #      data[tag] << item
  #    end
  #  end
  #
  #  self.profile.watched_locations.each do |location|
  #    data[location.address] = Review.near(location.to_coordinates, self.profile.watched_distance).enabled.in_days_of(days).all
  #  end
  #
  #  self.groups.each do |group|
  #    data[group] = Review.enabled.in_days_of(days).any_in(:author_id => group.member_ids).all
  #  end
  #
  #  data
  #end
  #
  #def self.send_updates_to_users
  #  self.enabled.valid_email_users.mail_receiver.each do |user|
  #    user.send_updates
  #  end
  #end

  def non_third_party_login
    provider.blank?
  end

end
