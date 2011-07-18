#encoding utf-8

namespace :yin11 do
  desc "dump some data"
  task :dump_data => :environment do
    File.open(File.join(RAILS_ROOT, 'app/assets/cities.txt'), 'w') do |file|
      City.all.each do |city|
        geocoded = city.coordinates && city.coordinates.size > 0
        lat = (geocoded ? city.latitude : 0 )
        log = (geocoded ? city.longitude : 0)
        eng_name = (city.eng_name.present? ? city.eng_name : "NULL")
          file.write([city.code, city.province.code, city.name, eng_name, city.postcode, lat, log].join(" "))
          file.write("\n")
      end
    end
  end
end