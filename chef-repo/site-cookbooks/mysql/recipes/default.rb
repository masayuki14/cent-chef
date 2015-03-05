#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#%w[mysql-libs postfix].each do |pkg|
#  package pkg do
#    action :install
#  end
#end

#bash 'remi_digest' do
#  user   'root'
#  code   'rpm -Va --nofiles --nodigest'
#end

# mysqlとの依存関係でupgradeが必要
# 通常の処理ではうまくいかないので個別に指定
yum_package 'postfix' do
  action  :upgrade
end

%w[mysql mysql-server php-mysql].each do |pkg|
  package pkg do
    action :install
    if pkg == 'php-mysql'
      notifies :restart, 'service[httpd]'
    end
  end
end

service 'mysqld' do
  action [ :enable, :start ]
end

# mysql root password 設定
bash 'setup_mysqlserver_root' do
  not_if "mysql -uroot -p#{node['mysql']['server_root_password']} -e 'show databases;'"
  code "mysqladmin -u root password '#{node['mysql']['server_root_password']}'"
end

template 'my.cnf' do
  path     '/etc/my.cnf'
  owner    'root'
  group    'root'
  mode     0644
  notifies :restart, 'service[mysqld]'
end


template 'mysql-build.sql' do
  path  '/tmp/mysql-build.sql'
end

bash 'mysql-build.sql' do
  code "mysql -uroot -p#{node['mysql']['server_root_password']} < /tmp/mysql-build.sql"
end

file 'mysql-build.sql' do
  path  '/tmp/mysql-build.sql'
  action :delete
end
