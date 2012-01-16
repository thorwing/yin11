module ImagesHelper
  def self.process_uploaded_images(item, image_params)
    if image_params.present?
      item.images.reject{|i| image_params.include?(i.id.to_s)}.each do |image|
        image.delete
      end
    end

    if image_params.present?
      image_params[0..(IMAGES_LIMIT - 1)].each do |image_id|
        image = Image.find(image_id)
        image.send("#{item.class.name.downcase}_id=", item.id)
        image.save
      end
    end
  end
end