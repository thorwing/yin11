#encoding utf-8


namespace :yin11 do
  desc "dump all"
  task :dump_all => :environment do
    #Rake::Task['yin11:dump_articles'].invoke
    Rake::Task['yin11:dump_recipes'].invoke
    Rake::Task['yin11:dump_images'].invoke
    #Rake::Task['yin11:dump_vendors'].invoke
  end

  desc "dump articles"
  task :dump_articles => :environment do
    articles_group = Article.without(:_id, :updated_at, :created_at, :positive, :_type, :votes, :fan_ids, :hater_ids, "source._id").to_a.group_by{ |a| a.reported_on.strftime("%y_%m")}
      articles_group.each do |month, articles|
        File.open(File.join(Rails.root, "app/seeds/articles/articles_#{month}.yml"), 'w') do |file|
        YAML::dump(articles, file)
      end
    end
  end

  desc "dump recipes"
  task :dump_recipes => :environment do
    recipes = Article.recipes.without(:updated_at, :created_at, :_type, :votes, :fan_ids, :hater_ids, "source._id").to_a
    File.open(File.join(Rails.root, "app/seeds/recipes.yml"), 'w') do |file|
      YAML::dump(recipes, file)
    end
  end

  desc "dump images"
  task :dump_images => :environment do
    array = []
    images = Image.without(:_id).to_a
    File.open(File.join(Rails.root, "app/seeds/images.yml"), 'w') do |file|
      images.each do |image|
        hash = {}
        hash[:file_name] = image.image.to_s
        hash[:binary_data] = image.image.read
        hash[:product_id] = image.product_id
        hash[:article_id] = image.article_id
        array << hash
      end
      YAML::dump(array, file)
    end
  end

  desc "dump vendors"
  task :dump_vendors => :environment do
    File.open(File.join(Rails.root, 'app/seeds/vendors.yml'), 'w') do |file|
      YAML::dump(Vendor.only(:name, :city, :street, :latitude, :longitude, :category, :sub_category).to_a, file)
    end
  end
end