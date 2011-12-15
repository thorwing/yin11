require 'spec_helper'

describe Step do
    it {should validate_presence_of :content}
    it {should ensure_length_of(:content ).
      is_at_most(100) }
end
