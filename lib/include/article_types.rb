require "hash_enumeration"

class ArticleTypes < HashEnumeration
  index = 0
  File.open(File.join(RAILS_ROOT, 'app/assets/article_types.txt')).each_line { |t|
    self.members[index] = t.strip
    index += 1
  }

end