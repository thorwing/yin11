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
        tags = ""
        tags += food_name if food_name.present?
        tags += "," if food_name.present? && toxin_names.present?
        tags += toxin_names if toxin_names.present?

        article = Article.find_or_initialize_by(title: title) do |a|
          a.reported_on = date
          #a.disabled = true
          a.city_ids = [city.id] if city && city.id.present?
          a.tags_string = tags
          a.build_source
          a.source.name = source_name || source_site || "Unknown Media"
          a.source.site = source_site || "Unknown Site"
          a.source.url = source_url || "#"
          a.content = I18n.translate("articles.source") + "<a href=\"#{a.source.url}\">" + a.source.name + "(" + a.source.site + ")" + '</a>'
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
      rescue Exception => exc
        p exc.message
        p row
        p [city_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
      end
    end

    p "Total: " + total.to_s
    p "Successful: " + success.to_s
  end
end