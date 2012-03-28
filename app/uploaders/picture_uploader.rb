# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  #include CarrierWave::ImageScience
  #include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :s3
  #storage :grid_fs
  storage :upyun


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #  def store_dir
  #    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_limit => [MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT]

  #def scale(width, height)
  #   # do something
  #end

  # Create different versions of your uploaded files:
  version :thumb do
     process :resize_to_fill => [IMAGE_THUMB_WIDTH, IMAGE_THUMB_HEIGHT]
  end

  version :waterfall do
     process :resize_to_limit => [IMAGE_WATERFALL_WIDTH, IMAGE_WATERFALL_HEIGHT]
     process :get_geometry

     def geometry
       @geometry
     end
  end

  def get_geometry
    if (@file)
      img = ::Magick::Image::read(@file.file).first
      @geometry = [ img.columns, img.rows ]
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    # '' for remote image
    ['jpg', 'jpeg', 'gif', 'png', '']
     #%w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  def filename
    [ model.id.to_s, original_filename ].join("_") if original_filename
  end

end
