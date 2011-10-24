module ImagesHelper
  def get_image_of_item(item, options)
    options[:border] = 0
    if item && item.images.size > 0
      image = item.images.first
      Logger.new(STDOUT).info image.image.url.to_s
      if image.image?
        image_tag(image.image.url, options)
       end
    else
      #TODO
      #image_tag("http://flickholdr.com/#{width}/#{height}/salat", :width => width, :height => height, :border => 0)
      image_tag("default_article.jpg", options)
    end
  end

  def self.process_uploaded_images(item, image_params)
    if image_params.present?
      image_params[0..4].each do |image_id|
        image = Image.find(image_id)
        image.info_item_id = item.id
        image.save
        #@review.image_ids << image_id
      end
    end
  end

  #TODO
  #def self.get_severity_image(item, width = 24, height = 32)
  #  image_tag("severity_3_small.png", :width => width, :height => height)
  #end

  def get_thumbnail(image, group = false)
    logger = Logger.new(STDOUT)
    logger.info image.image.url.to_s
    if image.image?
      link_to(image_tag(image.image_url(:thumb), :border => 0, :width => IMAGE_THUMB_WIDTH, :height => IMAGE_THUMB_HEIGHT, :alt => "image_thumbnail"),
        image.image_url, :title => image.caption, :rel => group ? "lightbox-group" : "lightbox" , :class => "thumbnail" )
    end
  end

end