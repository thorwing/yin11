class EvaluationManager
  #class methods
  def self.evaluate_items(items)
    severity_score = (items.size > 0) ?  items.inject(0){ |sum, s| sum + 1 } / items.size : 0

    if severity_score < 1
      severity_level = 0
    elsif severity_score < 5
      severity_level = 1
    elsif severity_score < 10
      severity_level = 2
    else
      severity_level = 3
    end

     I18n.translate("general.severity_#{severity_level}")
  end

  #instance methods
  def initialize(user)
    @user = user
  end

  #check whether the item is created by a member of my groups
  def is_from_my_groups?(item)
    if @user && @user.members_from_same_group.include?(item.author_id)
      true
    else
      false
    end
  end

  def get_score_of_item(item)
    score = 0
    #TODO
    score += item.votes * 10 #popularity
    score += (CacheManager.hot_tags | item.tags).size * 50 if item.tags #topics

    if item.reported_on.present? && item.reported_on > 3.month.ago
      score += (item.reported_on.to_i - 1.month.ago.to_i) / 60 / 60 / 24 * 200
    end

    score += 100 if item.is_recent? #recent
    score += 300 if is_from_my_groups?(item) #groups
    score
  end

  def sort_items_by_score(items)
    scored_items = items.inject({}) {|memo, e| memo.merge({ e => get_score_of_item(e)}) }
    scored_items.sort {|a,b| a[1]<=>b[1]}.inject([]){|memo, (k, v)| memo << k}
  end
end