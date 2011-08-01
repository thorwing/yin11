require "securerandom"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Available

  #TODO for Rails 3.1
  #has_secure_password

  #Fields
  field :email
  key :email

  field :login_name
  field :password_hash
  field :password_salt
  field :role, :type => Integer, :default => INACTIVE_USER_ROLE
  field :auth_token
  field :password_reset_token
  field :password_reset_sent_at, :type => DateTime
  field :activation_token
  field :blocked_user_ids, :type => Array
  mount_uploader :avatar, AvatarUploader

  index :email
  index :auth_token

  attr_accessor :password
  attr_accessible :email, :login_name, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at, :activation_token, :avatar

  # strange error when trying to using scope, so using class method instead
  scope :active_users, any_in(:role => [NORMAL_USER_ROLE, EDITOR_ROLE, ADMIN_ROLE])
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
  has_many :info_items, :inverse_of => "author"
  has_and_belongs_to_many :wrote_tips, :class_name => Tip.name
  has_and_belongs_to_many :groups, :inverse_of => "members"
  has_and_belongs_to_many :badges

  #Validators
  validates :email,
              :presence => true,
              :uniqueness => true,
              :email_format => true
  validates_presence_of :login_name
  validates_length_of :login_name, :maximum => 20
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :on => :create
  validates_associated :profile, :contribution

  #Others
  after_initialize { self.profile ||= Profile.new; self.contribution ||= Contribution.new }
  before_save :encrypt_password
  before_create { generate_token(:auth_token)
                  generate_token(:activation_token)}

  def authenticate(password)
    if password.present? && self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
      true
    else
      false
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_activation
    UserMailer.activation(self).deliver
  end

  def send_updates
    items = get_updates
    UserMailer.updates(self, items).deliver
  end

  def activate!
    self.role = NORMAL_USER_ROLE
    self.activation_token = nil
    self.save!
  end

  def self.is_email_available?(email)
    User.first(:conditions => { :email => email}).nil?
  end

  def vote_weight
    if has_permission?(:admin)
      ADMIN_VOTE_WEIGHT
    elsif has_permission?(:editor)
      EDITOR_VOTE_WEIGHT
    else
      NORMAL_USER_VOTE_WEIGHT
    end
  end

  def has_permission?(permission)
    case permission
      when :inactive_user
        self.role >= INACTIVE_USER_ROLE
      when :normal_user
        self.role >= NORMAL_USER_ROLE
      when :editor
        self.role >= EDITOR_ROLE
      when :admin
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
      result[k] = EvaluationManager.evaluate_items(v)
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

  def generate_token(column)
     begin
       self[column] = SecureRandom.urlsafe_base64
     end while User.exists?(:conditions => {column => self[column]})
  end

  def get_raw_updates(days)
    data = {}
    self.profile.watched_tags.map{|t| data[t] = []}
    InfoItem.enabled.in_days_of(days).tagged_with(self.profile.watched_tags).all.each do |item|
      (self.profile.watched_tags & item.tags).each do |tag|
        data[tag] << item
      end
    end

    self.profile.watched_locations.each do |location|
      data[location.address] = Review.near(location.to_coordinates, self.profile.watched_distance).enabled.in_days_of(days).all
    end

    self.groups.each do |group|
      data[group] = Review.enabled.in_days_of(days).any_in(:author_id => group.member_ids).all
    end

    data
  end

end
