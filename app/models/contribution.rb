class Contribution
  include Mongoid::Document

  field :created_reviews, :type => Integer, :default => 0
  field :created_articles, :type => Integer, :default => 0
  field :created_tips, :type => Integer, :default => 0

  #relationships
  embedded_in :user

end