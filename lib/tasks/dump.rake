#encoding utf-8


namespace :yin11 do
  desc "dump sphinx"
  task :dump_sphinx => :environment do
    Article.sphinx_stream
  end

  desc "dump articles"
  task :dump_articles => :environment do
    articles_group = Article.without(:_id, :updated_at, :created_at, :positive, :_type, :votes, :fan_ids, :hater_ids, "source._id").to_a.group_by{ |a| a.reported_on.strftime("%y_%m")}
      articles_group.each do |month, articles|
        File.open(File.join(Rails.root, "app/seeds/articles/articles_#{month}.yml"), 'w') do |file|
        #YAML::dump(Article.only(:title, :reported_on, :enabled, :recommended, :type, :region_ids, :city, :tags, :content, :coordinates, "source.name", "source.site", "source.url").to_a, file)
        YAML::dump(articles, file)
      end
    end
  end

  desc "dump tips"
  task :dump_tips => :environment do
    File.open(File.join(Rails.root, 'app/seeds/tips.yml'), 'w') do |file|
      YAML::dump(Tip.only(:title, :tags, :content).to_a, file)
    end
  end

  desc "dump vendors"
  task :dump_vendors => :environment do
    File.open(File.join(Rails.root, 'app/seeds/vendors.yml'), 'w') do |file|
      YAML::dump(Vendor.only(:name, :city, :street, :latitude, :longitude, :category, :sub_category).to_a, file)
    end
  end
end