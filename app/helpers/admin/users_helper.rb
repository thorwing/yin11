module Admin::UsersHelper
  def get_roles_for_select
    [["Normal User", NORMAL_USER_ROLE],
    ["Authorized User", AUTHORIZED_USER_ROLE],
    ["Editor", EDITOR_ROLE]]
  end
end
