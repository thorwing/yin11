# encoding: utf-8
#require the files for YMAL deserializing
require "article"
require "source"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  Factory(:normal_user)
  Factory(:tester)
  Factory(:editor)
  Factory(:admin)

#  FoodsGenerator::generate_foods

  File.open(File.join(RAILS_ROOT, 'app/assets/provinces.txt')).each_line { |p|
    code, name, short_name, main_city_id, type = p.split(" ")
    Province.create( :code => code, :name => name, :short_name => short_name, :main_city_id => main_city_id, :type => type)
  }

  File.open(File.join(RAILS_ROOT, 'app/assets/cities.txt')).each_line { |c|
    code, province_code, name, eng_name, postcode, lat, log = c.split(" ").map {|e| e.strip}
    province = Province.first(:conditions => {:code => province_code } )
    city = province.cities.build(:code => code, :name => name, :eng_name => eng_name, :postcode => postcode, :latitude => lat, :longitude => log)
    city.save
  }

  roots = YAML.load(File.open("#{Rails.root.to_s}/app/assets/districts.yml"))
  roots.each do |city_name, districts|
    city = City.first(conditions: {name: city_name})
    districts.each {|d| city.districts.create(:name => d)} if city
  end

  #badges
  badges = YAML::load(File.open("app/assets/badges.yml"))
  badges.each {|b| Badge.create!(b)}


  articles = YAML::load(File.open("app/assets/articles.yml"))
  articles.each do |article|
    Article.create! do |a|
        a.title = article.title
        a.enabled = false #article.enabled
        a.recommended = article.recommended
        a.reported_on = article.reported_on
        a.type = article.type
        a.region_ids = article.region_ids
        a.city = article.city
        a.tags = article.tags
        a.content = article.content
        a.coordinates = article.coordinates
        if article.source
          a.build_source
          a.source.name = article.source.name
          a.source.site = article.source.site
          a.source.url = article.source.url
        end
    end
  end
