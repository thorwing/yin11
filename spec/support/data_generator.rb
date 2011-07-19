module DataGenerator
  def generate_testing_data
    Factory(:normal_user)
    Factory(:tester)
    Factory(:editor)
    Factory(:admin)
    Factory(:shanghai)
  end
end