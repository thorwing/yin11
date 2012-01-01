# encoding: utf-8

#require the files for YMAL deserializing
require "topic"
require "recipe"
require "step"
require "ingredient"
require "tag"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  #Factory(:normal_user)
  #Factory(:tester)
  #Factory(:editor)
  #Factory(:master)
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

  p "generating malls and vendors"
  conf = YAML::load(ERB.new(IO.read("#{Rails.root}/config/silver_hornet/products.yml")).result)
  conf.each do |site_name, values|
    begin
      mall = Mall.create!(:name => site_name, :entry_url => values["entries"].first)
      vendor = mall.vendors.create!(:name => site_name) unless site_name == I18n.t("third_party.taobao")
    rescue Exception => exc
      p exc.backtrace
    end
  end

  def restore_images(path, field)
    images = YAML::load(File.open(path))
      if images.present? && images.size > 0
        images.each do |i|
          begin
            image = Image.create! do |image|
              image.id = i[:id]
              image.picture = AppSpecificStringIO.new(i[:file_name], i[:binary_data])
              image.send("#{field.to_s}=", i[field]) if field.present?
            end
          rescue Exception => exc
            p i[:file_name]
            p exc.message
            p exc.backtrace
          end
        end
      end
  end

  ##groups
  #p "generating groups"
  #groups = YAML::load(File.open("app/seeds/groups.yml"))
  #groups.each do |seed|
  #  Group.create! do |g|
  #    g.name = seed["name"]
  #    g.creator_id = @admin.id
  #    g.tags = seed["tags"]
  #  end
  #end

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

  p "generating pages"
  pages = YAML::load(File.open("app/seeds/pages.yml"))
  pages.each do |p|
    Page.create! do |page|
      page.id = p.id
      page.title = p.title
      page.content = p.content
    end
  end

  p "generating lonely images"
  restore_images("app/seeds/images.yml", nil)

  p "generating recipes"
  recipes = YAML::load(File.open("app/seeds/recipes.yml"))
  recipes.each do |r|
    begin
      recipe = Recipe.new
          recipe.id = r[:_id]
          recipe.name = r[:name]
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
      p r.name
      p exc.message
      p exc.backtrace
    end
  end

  p "generating recipes images"
  restore_images("app/seeds/recipes_imgs.yml", :step_id)

  p "generating tags"
  records = YAML::load(File.open("app/seeds/tags.yml"))
  records.each do |record|
      record["detail"].split(' ').each do |tag|
        Tag.create(:name => tag )
      end
  end


