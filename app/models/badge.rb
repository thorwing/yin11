class Badge
  include Mongoid::Document
  include Available

  field :name, :type => String
  field :description, :type => String
  field :repeatable, :type => Boolean, :default => false

  field :contribution_field
  field :comparator, :type => Integer, :default => 0
  field :compared_value

  #cached values
  field :count_of_awarded, :type => Integer, :default => 0

  #validators
  validates_uniqueness_of :name
  validates_presence_of :name

  attr_accessible :name, :description, :repeatable, :disabled, :contribution_field, :comparator, :compared_value

  COMPARATOR_HASH = {
  :COMPARISON_UNDEFINED => 0,
  :COMPARISON_IS => 1,
	:COMPARISON_IS_NOT => 2,
	:COMPARISON_EQUAL_TO => 3,
	:COMPARISON_NOT_EQUAL_TO => 4,
	:COMPARISON_LESS_THAN => 5,
	:COMPARISON_GREATER_THAN => 6,
	:COMPARISON_LESS_THAN_OR_EQUAL => 7,
	:COMPARISON_GREATER_THAN_OR_EQUAL => 8,
	:COMPARISON_MATCHES => 15,
	:COMPARISON_DOES_NOT_MATCH => 16,
	:COMPARISON_IS_TRUE => 17,
	:COMPARISON_IS_FALSE => 18,
	:COMPARISON_IS_NULL => 19,
	:COMPARISON_IS_NOT_NULL => 20,
	:COMPARISON_CONTAINS => 26,
	:COMPARISON_DOES_NOT_CONTAIN => 27,
	:COMPARISON_EXISTS => 40,
	:COMPARISON_DOES_NOT_EXIST => 41,
	:COMPARISON_HAS_CHANGED => 45,
	:COMPARISON_HAS_NOT_CHANGED => 46,
	:COMPARISON_IS_MEMBER_OF => 65,
	:COMPARISON_IS_NOT_MEMBER_OF => 66,
  :COMPARISON_MATCHES_FULLTEXT_SEARCH => 67,
  :COMPARISON_DOES_NOT_MATCH_FULLTEXT_SEARCH => 68,
	:COMPARISON_CONTAINS_CURRENT_USER => 69,
	:COMPARISON_DOES_NOT_CONTAIN_CURRENT_USER => 70 }

  def is_available_to?(user)
    if self.disabled
      false
    elsif user.badge_ids && user.badge_ids.include?(self.id) && (not self.repeatable)
      false
  else
      true
    end
  end

  def can_be_awarded_to?(user)
    return false unless is_available_to?(user)
    case self.comparator
      when COMPARATOR_HASH[:COMPARISON_IS]
        temp_comparator = "=="
      when COMPARATOR_HASH[:COMPARISON_IS_NOT]
        temp_comparator = "!="
      when COMPARATOR_HASH[:COMPARISON_EQUAL_TO]
        temp_comparator = "=="
      when COMPARATOR_HASH[:COMPARISON_LESS_THAN_OR_EQUAL]
        temp_comparator = "<="
      when COMPARATOR_HASH[:COMPARISON_GREATER_THAN_OR_EQUAL]
        temp_comparator = ">="
      else
        raise "unsupported comparator: " + self.comparator.to_s
    end

    result = eval "user.contribution.try(:#{self.contribution_field})#{temp_comparator}#{self.compared_value}"
    result
  end

  def give_to_user!(user)
    self.count_of_awarded += 1
    self.save

    user.badge_ids ||= []
    user.badge_ids << self.id
    user.save
  end

end
