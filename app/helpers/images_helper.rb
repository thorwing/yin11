module ImagesHelper
  def self.process_uploaded_images(item, image_params)
    #item.images.reject{|i| image_params.present? && image_params.include?(i.id.to_s)}.each do |image|
    #  image.delete
    #end

    if image_params.present?
      image_params[0..(IMAGES_LIMIT - 1)].each do |image_id|
        image = Image.find(image_id)
        image.send("#{item.class.name.downcase}_id=", item.id)
        image.save
      end
    end
  end

  #TODO
  #def self.get_severity_image(item, width = 24, height = 32)
  #  image_tag("severity_3_small.png", :width => width, :height => height)
  #end

  def get_thumbnail(image, group = false)
    if image.picture?
      link_to(image_tag(image.picture_url, :border => 0, :width => IMAGE_THUMB_WIDTH, :height => IMAGE_THUMB_HEIGHT, :alt => "image_thumbnail"),
        image.picture_url, :title => image.caption, :rel => "facebox" , :class => "thumbnail" )
    end
  end

end