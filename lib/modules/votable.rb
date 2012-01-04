module Votable
  def self.included(base)
    base.class_eval do
      field :votes, :type => Integer, :default => 0
      field :fan_ids, :type => Array, :default => []
      field :hater_ids, :type => Array, :default => []
    end

    def can_like?
      return false
    end

    def can_hate?
      return false
    end
    base.extend(ClassMethods)
  end

  module ClassMethods
      def can_like
          class_eval %(
            def can_like?
              return true
            end
          )
      end

      def can_hate
          class_eval %(
            def can_hate?
              return true
            end
          )
      end
  end
end