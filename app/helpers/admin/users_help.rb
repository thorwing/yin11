module Admin::ArticlesHelper
  def get_roles_for_select
    [{:id => GlobalConstants::NORMAL_USER_ROLE, :name => "Normal User"},
    {:id => GlobalConstants::AUTHORIZED_USER_ROLE, :name => "Authorized User"},
    {:id => GlobalConstants::EDITOR_ROLE, :name => "Editor"}]
  end
end
