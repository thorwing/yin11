#encoding utf-8

namespace :yin11 do
  desc "import some data"
  task :import_temp_data => :environment do
    p "importing data..."
    count = 0

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open File.join(RAILS_ROOT, 'app/assets/temp_data.xls')
    sheet = book.worksheet 0
    sheet.each 1 do |row|
      city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, dummy, title, source_url = *row
      date = row.datetime 7
      begin
        city = City.first(conditions: {name: city_name}) if city_name.present?
        food = Food.find_or_create_by(name: food_name) if food_name.present?
        toxins = []
        if toxin_names.present?
          toxin_names.split(",").each do |toxin_name|
            toxin = Toxin.find_or_create_by(name: toxin_name)
            toxins << toxin
          end
        end

        article = Article.find_or_initialize_by(title: title) do |a|
          a.content = "Please click the link to view the source of this article."
          a.reported_on = date
          a.disabled = true
          a.city_ids = [city.id] if city && city.id.present?
          a.food_ids = [food.id] if food && food.id.present?
          a.toxins = toxins if toxins.size > 0
          a.build_source
          a.source.name = source_name
          a.source.site = source_site
          a.source.url = source_url
        end
        if article.valid?
          count += 1
        end
      rescue
        p [city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
      end
    end

    p "Successful: " + count.to_s
  end
end