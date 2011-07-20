require "hash_enumeration"

class ArticleTypes < HashEnumeration
  ["news", "exposure", "tip"].each_with_index do |type, i|
    self.members[i] = type
  end
end