module Admin::UsersHelper
  def get_roles_for_select
    [["Inactive User", INACTIVE_USER_ROLE],
    ["Normal User", NORMAL_USER_ROLE],
    ["Editor", EDITOR_ROLE]]
  end
end
