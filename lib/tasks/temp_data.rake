#encoding utf-8

namespace :yin11 do
  desc "make all articles available"
  task :show_all_articles => :environment do
    Article.all.each do |article|
      article.enabled = true
      article.save
    end
  end

  desc "import some data"
  task :import_temp_data => :environment do
    p "importing data..."
    success = 0
    total = 0

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open File.join(Rails.root, 'app/seeds/temp_data.xls')
    sheet = book.worksheet 0
    sheet.each 1 do |row|
      total += 1
      begin
      region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, dummy, title, source_url = *row
      date = row.datetime 7

      if region_name.present?
        region = City.first(conditions: {name: region_name})
        region = Province.first(conditions: {name: region_name}) unless region
      end

      tags = ""
      tags += food_name if food_name.present?
      tags += "," if food_name.present? && toxin_names.present?
      tags += toxin_names if toxin_names.present?

      article = Article.find_or_initialize_by(title: title) do |a|
        a.reported_on = date
        #TODO
        a.type = "news"
        a.enabled = false
        a.region_ids = [region.id] if region

        #for geocoding
        a.city = region.name if region
        a.tags_string = tags
        a.build_source
        a.source.name = source_name || source_site || "Unknown Media"
        a.source.site = source_site || "Unknown Site"
        a.source.url = source_url
        a.content = I18n.translate("articles.source") + a.source.name + "(" + a.source.site + ")"
      end
      if article.valid?
        article.save!
        success += 1
      else
        #p [region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
        p [title, article.errors.to_s].join(" ")
      end
      rescue Exception => exc
        p exc.message
        p row
        p [region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
      end
    end

    p "Total: " + total.to_s
    p "Successful: " + success.to_s
  end
end