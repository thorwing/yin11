#encoding utf-8

namespace :yin11 do
  desc "import some data"
  task :import_temp_data => :environment do
    p "importing data..."
    success = 0
    total = 0


    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open File.join(RAILS_ROOT, 'app/assets/temp_data.xls')
    sheet = book.worksheet 0
    sheet.each 1 do |row|
      total += 1
      begin
      city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, dummy, title, source_url = *row
      date = row.datetime 7
        city = City.first(conditions: {name: city_name}) if city_name.present?
        food = Food.find_or_create_by(name: food_name) if food_name.present?
        toxin_ids = []
        if toxin_names.present?
          toxin_names.split(",").each do |toxin_name|
            toxin = Toxin.find_or_create_by(name: toxin_name)
            toxin_ids << toxin.id
          end
        end

        article = Article.find_or_initialize_by(title: title) do |a|
          a.content = "Please click the link to view the source of this article."
          a.reported_on = date
          a.disabled = true
          a.city_ids = [city.id] if city && city.id.present?
          a.food_ids = [food.id] if food && food.id.present?
          a.toxin_ids = toxin_ids if toxin_ids.size > 0
          a.build_source
          a.source.name = source_name || source_site || "Unknown"
          a.source.site = source_site
          a.source.url = source_url
        end
        if article.valid?
          article.save
          success += 1
        else
          if title.size > 30
            p "title is to long: " + title
          else
            p "invalid"
            p row
            p [city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
          end
        end
      rescue
        p "error"
        p row
        p [city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
      end
    end

    p "Total: " + total.to_s
    p "Successful: " + success.to_s
  end
end