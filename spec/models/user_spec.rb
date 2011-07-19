VALID_EMAIL = "test@test.de"
VALID_LOGIN_NAME = "tester"
VALID_PASSWORD = "123456"

INVALID_EMAIL = "test%de"
INVALID_PASSWORD = "123"
describe User do
  describe "bvt" do
    it "can simply create a user" do
      @user = Factory.create(:user, :email => VALID_EMAIL, :login_name => VALID_LOGIN_NAME, :password => VALID_PASSWORD)
      @user.should_not be_new_record
      @user.should_not be_nil
    end
  end

  describe "smoke" do
    it "can't create user without anything" do
      @user = Factory.build(:user)
      assert !@user.valid?
    end

    it "can't create user without email" do
      @user = Factory.build(:user, :login_name => VALID_LOGIN_NAME, :password => VALID_PASSWORD)
      assert !@user.valid?
    end

    it "can create user without login name" do
      @user = Factory.build(:user, :email => VALID_EMAIL, :password => VALID_PASSWORD)
      assert @user.valid?
    end

    it "can't create user without password" do
      @user = Factory.build(:user, :email => VALID_EMAIL, :login_name => VALID_LOGIN_NAME )
      assert !@user.valid?
    end

    it "can't create user with invalid email" do
      @user = Factory.build(:user, :email => INVALID_EMAIL, :login_name => VALID_LOGIN_NAME, :password => VALID_PASSWORD)
      assert !@user.valid?
    end

    it "can't create user with invalid password" do
      @user = Factory.build(:user, :email => VALID_EMAIL, :login_name => VALID_LOGIN_NAME, :password => INVALID_PASSWORD)
      assert !@user.valid?
    end
  end

  describe "#send_password_reset" do
    let(:user) { Factory(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end
end