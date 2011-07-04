module Admin::UsersHelper
  def get_roles_for_select
    [["Normal User", GlobalConstants::NORMAL_USER_ROLE],
    ["Authorized User", GlobalConstants::AUTHORIZED_USER_ROLE],
    ["Editor", GlobalConstants::EDITOR_ROLE]]
  end
end
