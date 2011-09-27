class IncomingRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :remote_ip
  field :operation_type

  attr_accessible :remote_ip, :operation_type

  def self.is_rapid_creation?(ip)
    !IncomingRequest.where(:remote_ip => ip, :operation_type => "create_user").all.empty?
  end

  def self.record_creation(ip)
    IncomingRequest.create(:remote_ip => ip, :operation_type => "create_user")
  end
end