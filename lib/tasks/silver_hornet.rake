#encoding utf-8

namespace :silver_hornet do
  desc "fetch news from internet"
  task :fetch_articles => :environment do
    begin
      config = SilverHornet::Configuration.instance
      config.parse_articles_config
      config.article_sites.each {|site| site.fetch_articles}
    rescue Exception => exc
      site.log exc.message
      p exc.backtrace
    end
  end
end