require 'spec_helper'

describe "Home" do
  describe "home page" do
    it "welcome" do
      get root_path
      response.status.should be(200)
    end
  end
end
