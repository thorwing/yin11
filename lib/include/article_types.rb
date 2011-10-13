#encoding utf-8

require "hash_enumeration"

class ArticleTypes < HashEnumeration
  [I18n.t("article_types.topic"), I18n.t("article_types.news"), I18n.t("article_types.tip")].each_with_index do |type, i|
    self.members[i] = type
  end
end