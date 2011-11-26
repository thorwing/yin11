module Taggable
  def self.included(base)
    base.class_eval do
      field :tags, :type => Array, :default => []
      index :tags

      attr_accessible :tags_string
      validates_length_of :tags, :maximum => MAX_TAGS, :message => I18n.translate("validations.tags.max_limit_msg", :max => MAX_TAGS)
      after_save :sync_tags

      include InstanceMethods
      extend ClassMethods
    end
  end

  module InstanceMethods
    def tags_string=(tags)
      self.tags = tags.split(",").collect{ |t| t.strip }.delete_if{ |t| t.blank? }[0..(MAX_TAGS - 1)]
    end

    def tags_string
      self.tags.join(", ") if tags
    end

    def sync_tags
      item_str = "#{self.class.name} #{self.id.to_s}"

      #record the item in the existed tags
      existed_tags = Tag.any_in(name: tags)
      new_tags = tags - existed_tags.map(&:name)
      existed_tags.each do |tag|
        unless tag.items.include?(item_str)
          tag.items << item_str
          tag.save
        end
      end

      #remove the item from the removed tag
      old_tags = tags_was.present? ? tags_was : []
      removed_tags = Tag.any_in(name: old_tags - tags)
      removed_tags.each do |tag|
        if tag.items.include?(item_str)
          tag.items.remove(item_str)
          tag.save
        end
      end

      #create new tag
      new_tags.each do |t|
        Tag.create(:name => t) do |tag|
          tag.items = [item_str]
        end
      end
    end
  end

  module ClassMethods
    # let's return only :tags
    def tags
      all.only(:tags).collect{ |ms| ms.tags }.flatten.uniq.compact
    end

    def tags_with_weight
      _tags = all.only(:tags).collect{ |ms| ms.tags }.flatten.compact
      hash = Hash.new(0)
      _tags.each {|v| hash[v] += 1}
      hash.sort{|a,b| a[1]<=>b[1]}.reverse.map{|k,v| [k, v]}
    end

    def tagged_like(_perm)
      _tags = tags
      _tags.delete_if { |t| !t.include?(_perm) }
    end

    def tagged_like_regex(_regex)
      _tags = tags
      _tags.grep _regex
    end

    def tagged_with(_tags)
      _tags = [_tags] unless _tags.is_a? Array
      #any_in will perform an intersaction when chained
      criteria.any_in(:tags => _tags)
    end
  end

end
