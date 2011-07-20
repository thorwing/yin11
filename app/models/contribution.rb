class Contribution
  include Mongoid::Document

  field :posted_recommendation, :type => Integer, :default => 0
  field :posted_reviews, :type => Integer, :default => 0
  field :posted_articles, :type => Integer, :default => 0
  field :posted_tips, :type => Integer, :default => 0
  field :edited_tips, :type => Integer, :default => 0
  field :created_groups, :type => Integer, :default => 0
  field :total_up_votes, :type => Integer, :default => 0
  field :total_down_votes, :type => Integer, :default => 0

  #relationships
  embedded_in :user

  validates_presence_of :user

end