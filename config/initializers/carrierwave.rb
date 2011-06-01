if ENV['MONGOHQ_URL']
  CarrierWave.configure do |config|
    config.storage = :grid_fs
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.grid_fs_database = File.basename(uri.path)
    config.grid_fs_host = uri.host unless uri.host.blank?
    config.grid_fs_port = uri.port unless uri.port.blank?
    config.grid_fs_username = uri.user unless uri.user.blank?
    config.grid_fs_password = uri.password unless uri.password.blank?
    config.grid_fs_access_url = '/images'
  end
else
  CarrierWave.configure do |config|
    config.grid_fs_database = Mongoid.database.name
    config.grid_fs_host = Mongoid.config.master.connection.host
    config.storage = :grid_fs
    config.grid_fs_access_url = "/images"
  end
end