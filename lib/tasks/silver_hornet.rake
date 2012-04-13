#encoding utf-8

namespace :silver_hornet do
  #desc "fetch news from internet"
  #task :fetch_articles => :environment do
  #  config = SilverHornet::Configuration.new(SilverHornet::ArticlesSite.name, "#{Rails.root}/config/silver_hornet/articles.yml")
  #  config.parse_config
  #  config.sites.each {|site| site.fetch}
  #end

  desc "fetch products from internet"
  task :fetch_products => :environment do
    config = SilverHornet::Configuration.new(SilverHornet::ProductsSite.name, "#{Rails.root}/config/silver_hornet/products.yml")
    config.parse_config
    config.sites.each {|site| site.fetch}
  end

  desc "fetch tuans"
  task :fetch_tuans => :environment do
    config = lambda do
        filename = "#{Rails.root}/config/silver_hornet/tuan.yml"
        file = File.open(filename)
        yaml = YAML.load(file)
        return yaml
    end.call

    config["websites"].each do |website, values|
      values["urls"].each do |city, url|
        SilverHornet::TuanHornet.new.fetch_all_tuans(website, city)
      end
    end

    p "expired: " + Tuan.where(:end_time.lt => DateTime.now).size.to_s
  end

  desc "fetch products from taobao mall"
  task :fetch_taobao => :environment do
    SilverHornet::TaobaoHornet.new.fetch
  end

end