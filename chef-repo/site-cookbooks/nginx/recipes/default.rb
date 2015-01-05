#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

package 'nginx' do
  action :install
end

# nginx の起動
service 'nginx' do
  action [ :enable, :start ]
end

# 設定ファイルの設置
# site-cookbooks/nginx/templates/default/nginx.conf.erb が利用される
template 'nginx.conf' do
  path '/etc/nginx/nginx.conf'
  owner 'root'
  group 'root'
  mode 0644

  # ファイルが更新されたらサービスをリロード
  notifies :reload, 'service[nginx]'
end
