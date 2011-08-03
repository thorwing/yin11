#encoding utf-8


namespace :yin11 do
  desc "dump some data"
  task :dump_data => :environment do
    #File.open(File.join(RAILS_ROOT, 'app/assets/cities.txt'), 'w') do |file|
    #  City.all.each do |city|
    #    geocoded = city.coordinates && city.coordinates.size > 0
    #    lat = (geocoded ? city.latitude : 0 )
    #    log = (geocoded ? city.longitude : 0)
    #    eng_name = (city.eng_name.present? ? city.eng_name : "NULL")
    #      file.write([city.code, city.province.code, city.name, eng_name, city.postcode, lat, log].join(" "))
    #      file.write("\n")
    #  end
    #end

    #File.open(File.join(RAILS_ROOT, 'app/assets/cities.yml'), 'w') do |file|
    #  YAML::dump(City.desc(:code).to_a, file)
    #end

    File.open(File.join(RAILS_ROOT, 'app/assets/articles.yml'), 'w') do |file|
      #YAML::dump(Article.only(:title, :reported_on, :enabled, :recommended, :type, :region_ids, :city, :tags, :content, :coordinates, "source.name", "source.site", "source.url").to_a, file)
      YAML::dump(Article.without(:_id, :updated_at, :created_at, :positive, :_type, :votes, :fan_ids, :hater_ids, "source._id").to_a, file)
    end

    #File.open(File.join(RAILS_ROOT, 'app/assets/articles.yml'), 'w') do |file|
    #  articles = Article.desc(:created_at)
    #  # pass the file handle as the second parameter to dump
    #  YAML::dump(articles, file)
    #end


  end
end