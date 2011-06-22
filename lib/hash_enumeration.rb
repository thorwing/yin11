class HashEnumeration
  include Enumerable

  def self.inherited(subclass)
    subclass.class_eval %(
      class << self; attr_accessor :members; end
      @members = {}
    )
  end

  def self.each &block
    @members.each{ |key, value| block ? yield(block.call(key), value) : yield(key, value)}
  end

  def self.add_item(key, value)
    @members[key] = value
  end

  def self.const_missing(key)
    @members[key]
  end

  def self.get_values
    @members.map{ |k,v| v }
  end
end