# Basic tagging system for mongoid documents.
#
# class User
#   include Mongoid::Document
#   include Taggable
#  end
#
#  @user = User.new(:name => "Bobby")
#  @user.tag_list = "awesome, slick, hefty"
#  @user.tags     # => ["awesome","slick","hefty"]
#  @user.save
#
#  User.tagged_with("awesome") # => @user
#  User.tagged_with(["slick", "hefty"]) # => @user
#
#  @user2 = User.new(:name => "Bubba")
#  @user2.tag_list = "slick"
#  @user2.save
#
#  User.tagged_with("slick") # => [@user, @user2]

module Taggable
  def self.included(base)
    base.class_eval do |base1|
      base1.field :tags, :type => Array
      base1.index :tags

      attr_accessible :tags_string
      validates_length_of :tags, :maximum => GlobalConstants::MAX_TAGS, :message => I18n.translate("validations.tags.max_limit_msg", :max => GlobalConstants::MAX_TAGS)

      include InstanceMethods
      extend ClassMethods
    end
  end

  module InstanceMethods
    def tags_string=(tags)
      self.tags = tags.split(",").collect{ |t| t.strip }.delete_if{ |t| t.blank? }[0..(GlobalConstants::MAX_TAGS - 1)]
    end

    def tags_string
      self.tags.join(", ") if tags
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
      criteria.in(:tags => _tags)
    end
  end

end
