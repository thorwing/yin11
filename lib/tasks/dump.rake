#encoding utf-8


namespace :yin11 do
  desc "dump articles"
  task :dump_articles => :environment do
    File.open(File.join(RAILS_ROOT, 'app/assets/articles.yml'), 'w') do |file|
      #YAML::dump(Article.only(:title, :reported_on, :enabled, :recommended, :type, :region_ids, :city, :tags, :content, :coordinates, "source.name", "source.site", "source.url").to_a, file)
      YAML::dump(Article.without(:_id, :updated_at, :created_at, :positive, :_type, :votes, :fan_ids, :hater_ids, "source._id").to_a, file)
    end
  end

  desc "dump tips"
  task :dump_tips => :environment do
    File.open(File.join(RAILS_ROOT, 'app/assets/tips.yml'), 'w') do |file|
      YAML::dump(Tip.only(:title, :tags, :content).to_a, file)
    end
  end
end