#encoding utf-8
namespace :yin11 do
  desc "disable reviews without images"
  #TODO
  #to schedule this task
  task :scan_reviews => :environment do
    reviews = Review.enabled.all
    reviews.each do |review|
      if (review.images.size == 0) and (review.created_at <= 24.hours.ago)
        review.disabled = true
        review.save
      end
    end
  end
end