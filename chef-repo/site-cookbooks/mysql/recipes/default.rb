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
