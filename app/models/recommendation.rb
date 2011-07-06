class Recommendation < InfoItem
  #relationships
  belongs_to :vendor
  tokenize_one :vendor
end
