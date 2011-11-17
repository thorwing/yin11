# encoding: utf-8

#require the files for YMAL deserializing
require "article"
require "source"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  Factory(:normal_user)
  Factory(:tester)
  Factory(:editor)
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
      g.city_id = "021"
      seed["tags"].each do |tag|
        g.tags << Tag.new(:name => tag)
      end
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
    topic = Topic.new
    t.each do |field_name, v|
      topic.send("#{field_name}=", v) if topic.respond_to?("#{field_name}=")
    end
    topic.save!
  end

  p "generating recipes"
  recipes = YAML::load(File.open("app/seeds/recipes.yml"))
  recipes.each do |r|
    begin
      Article.create! do |recipe|
        recipe.id = r.id
        recipe.title = r.title
        recipe.type = r.type
        recipe.tags = r.tags
        recipe.reported_on = r.reported_on
        recipe.introduction = r.introduction
        recipe.content = r.content
        recipe.recommended = r.recommended
        recipe.enabled = r.enabled
      end
    rescue Exception => exc
      p r.title
      p exc.message
      p exc.backtrace
    end
  end

  p "generating images"
  images = YAML::load(File.open("app/seeds/images.yml"))
  images.each do |i|
    begin
      image = Image.create! do |image|
        image.image = AppSpecificStringIO.new(i[:file_name], i[:binary_data])
        image.product_id = i[:product_id]
        image.article_id = i[:article_id]
      end

    rescue Exception => exc
      p i[:file_name]
      p exc.message
      p exc.backtrace
    end
  end