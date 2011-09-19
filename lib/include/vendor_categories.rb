require "hash_enumeration"

class VendorCategories< HashEnumeration
  type_bit = 1
  File.open(File.join(Rails.root.to_s, 'app/seeds/vendor_types.txt')).each_line { |t|
    self.members[type_bit] = t.strip
    type_bit *= 2
  }
end