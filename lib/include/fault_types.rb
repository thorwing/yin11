require "hash_enumeration"

class FaultTypes < HashEnumeration
  fault_bit = 1
  File.open(File.join(RAILS_ROOT, 'app/assets/fault_types.txt')).each_line { |t|
    self.members[fault_bit] = t.strip
    fault_bit *= 2
  }
end