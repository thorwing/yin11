require "global_constants"

Factory.define :user do |f|
end

Factory.define :normal_user, :class => User do |f|
  f.email "user@yin11.comm"
  f.password "Iam1user"
  f.login_name "David"
  f.role GlobalConstants::NORMAL_USER_ROLE
end

Factory.define :tester, :class => User do |f|
  f.email "tester@yin11.comm"
  f.password "Iam1tester"
  f.login_name "Kate"
  f.role GlobalConstants::AUTHORIZED_USER_ROLE
end

Factory.define :editor, :class => User do |f|
  f.email "editor@yin11.com"
  f.password "Iam1editor"
  f.login_name "Castle"
  f.role GlobalConstants::EDITOR_ROLE
end

Factory.define :admin, :class => User do |f|
  f.email "admin@yin11.com"
  f.password "You1Superuser!"
  f.login_name "Ray"
  f.role GlobalConstants::ADMIN_ROLE
end