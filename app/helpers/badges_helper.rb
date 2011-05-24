module BadgesHelper
  def get_comparators()
    Badge::COMPARATOR_HASH.collect{ |k,v| [k, v]}
  end
end
