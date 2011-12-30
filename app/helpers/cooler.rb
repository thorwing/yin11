class Cooler
  def self.crazy_register?(ip)
    users = User.where(:remote_ip => ip, :created_at.gt => REGISTRATION_COOLDOWM_INTERVAL.hours.ago).to_a
    users.size > REGISTRATION_COOLDOWM_LIMIT
  end

  def self.rapid_commenter?(user, item)
    comments = item.comments.where(:user_id => user.id, :created_at.gt => COMMENTS_COOLDOWM_INTERVAL.seconds.ago).to_a
    comments.size > COMMENTS_COOLDOWM_LIMIT
  end
end