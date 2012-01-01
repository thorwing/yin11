#encoding utf-8

namespace :yin11 do
  def store_images(images, path)
    array = []
    File.open(File.join(Rails.root, path), 'w') do |file|
      images.each do |image|
        hash = {}
        hash[:id] = image.id
        hash[:file_name] = image.picture.path.split('/').last.gsub(image.id.to_s + "_", '')
        hash[:binary_data] = image.picture.read
        #TODO  use reflect here
        hash[:product_id] = image.product_id
        hash[:topic_id] = image.topic_id
        hash[:step_id] = image.step_id
        hash[:ingredient_id] = image.ingredient_id
        array << hash
      end
      YAML::dump(array, file)
    end
  end

  desc "dump all"
  task :dump_all => :environment do
    #Rake::Task['yin11:dump_articles'].invoke
    Rake::Task['yin11:dump_topics'].invoke
    Rake::Task['yin11:dump_pages'].invoke
    Rake::Task['yin11:dump_images'].invoke
    #Rake::Task['yin11:dump_vendors'].invoke
  end

  desc "dump topics"
  task :dump_topics => :environment do
    topics = Topic.all.to_a
    File.open(File.join(Rails.root, "app/seeds/topics.yml"), 'w') do |file|
      YAML::dump(topics, file)
    end
  end

  desc "dump pages"
  task :dump_pages => :environment do
    pages = Page.all.to_a
    File.open(File.join(Rails.root, "app/seeds/pages.yml"), 'w') do |file|
      YAML::dump(pages, file)
    end
  end

  desc "dump recipes"
  task :dump_recipes => :environment do
    #recipes
    recipes = Recipe.all.to_a
    File.open(File.join(Rails.root, "app/seeds/recipes.yml"), 'w') do |file|
      YAML::dump(recipes, file)
    end

    #images
    array = []
    recipes = Recipe.all.to_a
    File.open(File.join(Rails.root, "app/seeds/recipes_imgs.yml"), 'w') do |file|
       recipes.each do |recipe|
            steps = recipe.steps
            steps.each do |step|
                image = Image.find(step.img_id)
                hash = {}
                hash[:id] = image.id
                hash[:step_id] = image.step_id
                hash[:file_name] = image.picture.path.split('/').last.gsub(image.id.to_s + "_", '')
                hash[:binary_data] = image.picture.read
                array << hash
                #p "hash[:file_name] "+ hash[:file_name]
                end
       end
       YAML::dump(array, file)
       #p "array " + array.size.to_s
    end
  end

  desc "dump images"
  task :dump_images => :environment do
    store_images(Image.lonely.to_a, "app/seeds/images.yml")
  end

  desc "dump vendors"
  task :dump_vendors => :environment do
    File.open(File.join(Rails.root, 'app/seeds/vendors.yml'), 'w') do |file|
      YAML::dump(Vendor.only(:name, :city, :street, :latitude, :longitude, :category, :sub_category).to_a, file)
    end
  end

  #desc "dump tags"
  #task :dump_tags => :environment do
  #  #recipes
  #  tags = Tag.all.to_a
  #  File.open(File.join(Rails.root, "app/seeds/hot_tags.yml"), 'w') do |file|
  #    YAML::dump(tags, file)
  #  end
  #end

end