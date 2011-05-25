class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #Fields
  field :email
  key :email
  field :login_name
  field :password_hash
  field :password_salt
  field :password_reset_token
  field :role, :type => Integer, :default => 1
  field :remember_token
  field :remember_token_expires_at, :type => Time

  #Relationships
  embeds_one :profile
  embeds_one :contribution
  has_many :reviews, :inverse_of => "author"
  has_and_belongs_to_many :participated_tips, :class_name => "Tip"
  has_and_belongs_to_many :badges

  attr_accessor :password
  attr_accessible :email, :login_name, :password, :password_confirmation

  #Validators
  validates :email,
              :presence => true,
              :uniqueness => true,
              :email_format => true
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6, :on => :create, :message => I18n.t("views.validation_message.password_is_too_short")
  validates_associated :profile, :contribution

  USER_ROLE = 1
  EDITOR_ROLE = 2
  ADMIN_ROLE = 9

  #Others
  after_initialize :build_records
  before_save :encrypt_password

  def build_records
    self.profile ||= Profile.new
    self.contribution ||= Contribution.new
  end

  def self.authenticate(email, password)
    user = User.first(:conditions => {:email => email } )
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def remember_token?
    (!remember_token.blank?) &&
        remember_token_expires_at && (Time.now.utc < remember_token_expires_at.utc)
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = self.class.make_token
    save
  end

  # refresh token (keeping same expires_at) if it exists
  def refresh_token
    if remember_token?
      self.remember_token = self.class.make_token
      save
    end
  end

  #
  # Deletes the server-side record of the authentication token. The
  # client-side (browser cookie) and server-side (this remember_token) must
  # always be deleted together.
  #
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save
  end

  #todo
  def has_notifications?
    unless self.notifications
      self.notifications = []
      self.save
    end

    self.notifications.size > 0
  end

  def clean_notifications
    self.notifications = []
    self.save
  end

  def is_editor?
    self.role == EDITOR_ROLE
  end

  def is_admin?
    self.role == ADMIN_ROLE
  end

  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end


  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

end
