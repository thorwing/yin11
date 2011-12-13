# encoding: utf-8

#require the files for YMAL deserializing
require "article"
require "source"
require "topic"
require "recipe"
require "step"
require "ingredient"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  Factory(:normal_user)
  Factory(:tester)
  Factory(:editor)
  Factory(:master)
  @admin = Factory(:administrator)

#  FoodsGenerator::generate_foods

  #File.open(File.join(Rails.root, 'app/seeds/provinces.txt')).each_line { |p|
  #  code, name, short_name, main_city_id, type = p.split(" ")
  #  Province.create( :code => code, :name => name, :short_name => short_name, :main_city_id => main_city_id, :type => type)
  #}
  #
  #File.open(File.join(Rails.root, 'app/seeds/cities.txt')).each_line { |c|
  #  code, province_code, name, eng_name, postcode, lat, log = c.split(" ").map {|e| e.strip}
  #  province = Province.first(:conditions => {:code => province_code } )
  #  city = province.cities.build(:code => code, :name => name, :eng_name => eng_name, :postcode => postcode, :latitude => lat, :longitude => log)
  #  city.save
  #}

  #roots = YAML.load(File.open("#{Rails.root.to_s}/app/seeds/districts.yml"))
  #roots.each do |city_name, districts|
  #  city = City.first(conditions: {name: city_name})
  #  districts.each {|d| city.districts.create(:name => d)} if city
  #end

  #badges
  #badges = YAML::load(File.open("app/seeds/badges.yml"))
  #badges.each {|b| Badge.create!(b)}

  #tips
  #tips = YAML::load(File.open("app/seeds/tips.yml"))
  #tips.each {|t| Tip.create!(t)}

  #articles
  #Dir["app/seeds/articles/*.yml"].each do |file|
  #  articles = YAML::load(File.open(file))
  #  articles.each do |article|
  #    begin
  #      Article.create! do |a|
  #          a.title = article.title
  #          a.enabled = false # article.enabled
  #          a.recommended = article.recommended
  #          a.reported_on = article.reported_on
  #          #a.type = article.type
  #          a.type = I18n.t("article_types.news")
  #          a.region_ids = article.region_ids
  #          a.city = article.city
  #          a.tags = article.tags
  #          a.content = article.content
  #          #a.location = article.location
  #          if article.source
  #            a.build_source
  #            a.source.name = article.source.name
  #            a.source.site = article.source.site
  #            a.source.url = article.source.url
  #          end
  #      end
  #    rescue Exception => exc
  #      p article.title
  #      p exc.backtrace
  #    end
  #  end
  #end

  #vendors
  #vendors = YAML::load(File.open("app/seeds/vendors.yml"))
  #vendors.each do |v|
  #  begin
  #    vendor = Vendor.new do |vendor|
  #      vendor.name = v.name
  #      vendor.city = v.city
  #      vendor.street = v.street
  #      vendor.latitude = v.latitude
  #      vendor.longitude = v.longitude
  #    end
  #    p [v.name, v.city, v.street, v.latitude.to_s, v.longitude.to_s].join(" ")
  #    vendor.save!
  #
  #  rescue Exception => exc
  #    p v.name
  #    p exc.backtrace
  #  end
  #end

  conf = YAML::load(ERB.new(IO.read("#{Rails.root}/config/silver_hornet/products.yml")).result)
  conf.each do |site_name, values|
    begin
      vendor = Vendor.create!(:name => site_name)
      p vendor.name
    rescue Exception => exc
      p exc.backtrace
    end
  end

  #groups
  p "generating groups"
  groups = YAML::load(File.open("app/seeds/groups.yml"))
  groups.each do |seed|
    Group.create! do |g|
      g.name = seed["name"]
      g.creator_id = @admin.id
      g.tags = seed["tags"]
    end
  end

  def generate_catalog(parent, node)
    if parent
      catalog = Catalog.create!(name: node["name"], show: node["show"]) do |c|
        c.parent = parent
      end
    else
      catalog = Catalog.create!(name: node["name"], show: node["show"])
    end

    if node["sub"]
      node["sub"].each {|child| generate_catalog(catalog, child)}
    end
  end

  #categories
  p "generating catalogs"
  catalogs = YAML::load(File.open("config/silver_hornet/catalogs.yml"))
  catalogs.each do |c|
    generate_catalog(nil, c)
  end

  p "generating topics"
  topics = YAML::load(File.open("app/seeds/topics.yml"))
  topics.each do |t|
    Topic.create! do |topic|
      topic.id = t.id
      topic.title = t.title
      topic.tags = t.tags
      topic.description = t.description
      topic.content = t.content
      topic.priority = t.priority
    end
    #t.each do |field_name, v|
    #  topic.send("#{field_name}=", v) if topic.respond_to?("#{field_name}=")
    #end
    #topic.save!
  end

  p "generating recipes"
  recipes = YAML::load(File.open("app/seeds/recipes.yml"))
  recipes.each do |r|
    begin
      recipe = Recipe.new
          recipe.id = r[:_id]
          recipe.recipe_name = r[:recipe_name]
          recipe.tags = r[:tags]
          recipe.author_id = @admin.id

          #ingredients
          r[:ingredients].each do |ing|
              ingredient = recipe.ingredients.build
              ingredient.name = ing["name"]
              ingredient.amount = ing["amount"]
              ingredient.is_major_ingredient = ing["is_major_ingredient"]
              ingredient.id = ing["_id"]
              ingredient.save!
          end

          #steps
          r[:steps].each do |s|
            step = recipe.steps.build
            step.img_id = s["img_id"]
            step.content = s["content"]
            step.id = s["_id"]
            step.save!
          end
          recipe.save!

    rescue Exception => exc
      p r.recipe_name
      p exc.message
      p exc.backtrace
    end
  end

  #images
  imgs = YAML::load(File.open("app/seeds/recipes_imgs.yml"))
  #p "total "+ imgs.length.to_s+ " imgs"
  imgs.each do |i|
     begin
        image = Image.create! do |image|
          image.id = i[:id]
          image.picture = AppSpecificStringIO.new(i[:file_name], i[:binary_data])
          image.step_id = i[:step_id]
        end
       #p "image_name" + i[:file_name] + " succ"
     rescue Exception => exc
        p i[:file_name]
        p exc.message
        p exc.backtrace
     end

  end

  p "generating images"
  images = YAML::load(File.open("app/seeds/images.yml"))
  if images.present? && images.size > 0
    images.each do |i|
      begin
        image = Image.create! do |image|
          image.id = i[:id]
          image.picture = AppSpecificStringIO.new(i[:file_name], i[:binary_data])
          #Only allow topics'' images here
          #image.product_id = i[:product_id]
          #image.article_id = i[:article_id]
          #image.topic_id = i[:topic_id]
        end
      rescue Exception => exc
        p i[:file_name]
        p exc.message
        p exc.backtrace
      end
    end
  end