#encoding utf-8

Factory.define :user do |f|
end

Factory.define :inactive_user, :class => User do |f|
  f.email "lazy@yin11.com"
  f.password "Iam1lazy"
  f.login_name "Sloth"
  f.role INACTIVE_USER_ROLE
end

Factory.define :normal_user, :class => User do |f|
  f.email "user@yin11.com"
  f.password "Iam1user"
  f.login_name "David"
  f.role NORMAL_USER_ROLE
end

Factory.define :master, :class => User do |f|
  f.email "master@yin11.com"
  f.password "Iam1master"
  f.login_name "Blade"
  f.is_master true
  f.role NORMAL_USER_ROLE
end

Factory.define :tester, :class => User do |f|
  f.email "tester@yin11.com"
  f.password "Iam1tester"
  f.login_name "Kate"
  f.role NORMAL_USER_ROLE
end

Factory.define :editor, :class => User do |f|
  f.email "editor@yin11.com"
  f.password "Iam1editor"
  f.login_name "Castle"
  f.role EDITOR_ROLE
end

Factory.define :administrator, :class => User do |f|
  f.email "admin@yin11.com"
  f.password "You1Superuser!"
  f.login_name "Ray"
  f.role ADMIN_ROLE
end
