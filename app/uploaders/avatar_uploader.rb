# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :s3

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

  #TODO
  # Process files as they are uploaded:
  #process :resize_to_limit => [IMAGE_WIDTH, IMAGE_HEIGHT]
  #
  # def scale(width, height)
  #   # do something
  # end

  #Create different versions of your uploaded files:
  #version :thumb do
  #   process :resize_to_limit => [IMAGE_THUMB_WIDTH, IMAGE_THUMB_HEIGHT]
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  def filename
     [ model.updated_at.to_i.to_s, original_filename ].join("_") if original_filename
  end

end
