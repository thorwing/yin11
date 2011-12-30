class Cooler
  def self.crazy_register?(ip)
    user = User.first(conditions: {remote_ip: ip}, sort: [[ :created_at, :desc ]])
    user && user.created_at > REGISTRATION_COOLDOWM.hours.ago
  end

  def self.rapid_commenter?(user, item)
    comment = item.comments.first(conditions: {user_id: user.id}, sort: [[ :created_at, :desc ]])
    comment && comment.created_at > COMMENTS_COOLDOWM.seconds.ago
  end
end