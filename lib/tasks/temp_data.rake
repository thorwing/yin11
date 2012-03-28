##encoding utf-8
#

namespace :yin11 do
  def handle_record(record)
    if record.is_a?(Hash)
      hash = {}
      record.each do |k, v|
        hash[k] = handle_record(v)
      end
      hash
    elsif record.is_a?(String)
      record.split(' ')
    end
  end

  desc "create desires according to recipes"
  task :create_desires_for_recipes => :environment do
    p "create desires for recipes..."
    Recipe.all.each do |recipe|
      if recipe.valid?
        image_id = nil
        image = nil
        recipe.steps.each do |step|
          image_id = step.img_id if step.img_id.present?
        end
        image = Image.first(conditions: {id: image_id}) if image_id
        if image
          Desire.create do |d|
            d.author = recipe.author
            d.content = I18n.t("desires.new_recipe", user: recipe.author.login_name, name: recipe.name, locale: "zh-CN")
            cloned_image = image.clone
            d.images << cloned_image
            recipe.reviews.create do |r|
              r.author = recipe.author
              r.desire = d
              r.content = recipe.name
            end
          end
        end
      end
    end
  end

  desc "update products for refer url"
  task :update_products => :environment do
    top = SilverHornet::TopHornet.new
    Product.all.each do |product|
      if product.iid.present?
        top.convert_taobaoke(product.iid, product)
        p (product && product.valid? ) ? "update one" : "fail one"
      end
    end
  end

  desc "clean isolated images"
  task :clean_images => :environment do
    #topic_id: nil
    Image.where(product_id: nil, step_id: nil, ingredient_id: nil, album_id: nil, desire_id: nil, award_id: nil, recipe_id: nil).delete_all
  end

  desc "upload images to upyun"
  task :update_images => :environment do
    raw_images = Image.where(updated: nil).desc(:created_at).to_a
    p "#{raw_images.size} images to process"
    raw_images.each_with_index do |image, i|
      p "dealing #{i}"
      url = image.picture_url.sub("http://silver-space.b0.upaiyun.com", "http://chixinbugai.com/images")
      image.remote_picture_url = url
      if image.valid?
        image.updated = true
        image.save
        p "success"
      end
    end
  end

  desc "update recipe images"
  task :update_recipe_images => :environment do
    Recipe.all.each do |recipe|
      if recipe.image.nil?
        steps_with_image = (recipe.steps || []).select{|s| s.image.present?}
        image = steps_with_image.last.get_image unless steps_with_image.empty?
        if image
          recipe.create_image(picture: image.picture)
        end
      end
    end
  end

  desc "update cached fields"
  task :update_cached_fields => :environment do
    Album.all.each  do |album|
      album.desires_count = album.desires.count
      album.save!
    end
    User.all.each do |user|
      user.save
    end
  end

  desc "clean products for refer url"
  task :clean_products => :environment do
    Product.where(iid: nil).delete_all
  end

  desc "assign scores for all users"
  task :assign_score => :environment do
    User.all.each do |user|
      user.left_score = user.score
      user.save
    end
  end

  desc "clean solutions for refer url"
  task :clean_solutions => :environment do
    Solution.all.each do |solution|
      solution.delete if (solution.item.nil?)
    end
  end

  desc "generate solutions for existed desires"
  task :generate_solutions_for_desires => :environment do
    Desire.all.to_a.each do |desire|
      SolutionManager.generate_solutions(desire)
    end
  end

  desc "check solutions for all desires"
  task :check_solutions => :environment do
    Desire.all.to_a.each do |desire|
      desire.check_solutions
    end
  end

  desc "clean all notifications"
    task :clean_all_notifications => :environment do
      User.all.to_a.each do |user|
        user.notifications.delete_all
      end
    end

  desc "generate primary tags"
  task :generate_primary_tags => :environment do
    p "generate primary tags..."

    #to sync counts
    Tag.all.to_a.each do |t|
      t.primary = false
      t.save
    end


    records = YAML::load(File.open("app/seeds/tags.yml"))

    tags = {}
    records.each do |first_lv, value|
     tags[first_lv] = handle_record(value)
    end

    tags.each do |first_lv, tags|
      if tags.is_a?(Array)
        tags.each do |tag_name|
          tag = Tag.find_or_initialize_by(name: tag_name)
          tag.primary = true
          tag.save
        end
      elsif tags.is_a?(Hash)
        tags.each do |second_lv, v|
          v.each do |tag_name|
            tag = Tag.find_or_initialize_by(name: tag_name)
            tag.primary = true
            tag.save
          end
        end
      end
    end

  end
end


#namespace :yin11 do
#  desc "import some data"
#  task :import_temp_data => :environment do
#    p "importing data..."
#    success = 0
#    total = 0
#
#    Spreadsheet.client_encoding = 'UTF-8'
#    book = Spreadsheet.open File.join(Rails.root, 'app/seeds/temp_data.xls')
#    sheet = book.worksheet 0
#    sheet.each 1 do |row|
#      total += 1
#      begin
#      region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, dummy, title, source_url = *row
#      date = row.datetime 7
#
#      if region_name.present?
#        region = City.first(conditions: {name: region_name})
#        region = Province.first(conditions: {name: region_name}) unless region
#      end
#
#      tags = ""
#      tags += food_name if food_name.present?
#      tags += "," if food_name.present? && toxin_names.present?
#      tags += toxin_names if toxin_names.present?
#
#      article = Article.find_or_initialize_by(title: title) do |a|
#        a.reported_on = date
#        #TODO
#        a.type = "news"
#        a.enabled = false
#        a.region_ids = [region.id] if region
#
#        #for geocoding
#        a.city = region.name if region
#        a.tags_string = tags
#        a.build_source
#        a.source.name = source_name || source_site || "Unknown Media"
#        a.source.site = source_site || "Unknown Site"
#        a.source.url = source_url
#        a.content = I18n.translate("articles.source") + a.source.name + "(" + a.source.site + ")"
#      end
#      if article.valid?
#        article.save!
#        success += 1
#      else
#        #p [region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
#        p [title, article.errors.to_s].join(" ")
#      end
#      rescue Exception => exc
#        p exc.message
#        p row
#        p [region_name, food_name, toxin_names, fault, more_faults, source_name, source_site, date.strftime('%m/%d/%Y'), title, source_url].join(" ")
#      end
#    end
#
#    p "Total: " + total.to_s
#    p "Successful: " + success.to_s
#  end
#
#  #imports some vendors information
#  desc "import vendors"
#  task :import_vendors => :environment do
#    p "importing vendors..."
#    success = 0
#    total = 0
#
#    Spreadsheet.client_encoding = 'UTF-8'
#    book = Spreadsheet.open File.join(Rails.root, 'app/seeds/shanghai_vendors.xls')
#    sheet = book.worksheet 0
#    sheet.each 1 do |row|
#      total += 1
#      begin
#      name, vendor_alias, street, extra_address, near_address, area, traffic, sub_category, specialty, phone, cost, notice = *row
#
#      vendor = Vendor.find_or_initialize_by(:name => name, :street => street) do |v|
#        v.name = name.to_s
#        #v.alias = vendor_alias
#        v.city = I18n.t("location.default_city")
#        v.street = street.to_s
#        #v.extra_address = extra_address
#        #v.near_address = near_address
#        #v.area = area
#        #v.traffic = traffic
#        #v.category = VendorCategories.get_values.first
#        v.sub_category = sub_category.to_s
#        #v.specialty = specialty
#        #v.phone = phone
#        #v.cost = cost
#      end
#
#      if vendor.valid? && vendor.new_record?
#        vendor.save!
#        success += 1
#        p  ["create:", name, street].join(" ")
#      elsif vendor.valid?
#        #p ["already have:", name, vendor.address].join(" ")
#      else
#        p ["invalid:", name, vendor.address].join(" ")
#      end
#
#      rescue Exception => exc
#        p exc.backtrace
#      end
#    end
#
#    p "Total: " + total.to_s
#    p "Successful: " + success.to_s
#  end
#
#end