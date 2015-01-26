#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

=begin
case node['platform']
when 'ubuntu'
  # Debian系はこっち
  # とりあえず ubuntu サーバへのApacheインストールレシピ
  webServer = 'apache2'

when 'centos', 'redhat'
  # Redhat系はこっち
  webServer = 'httpd'

end
return if webServer.nil?
=end

webServer = 'apache2'

package webServer do
  action :install
end

service webServer do
  action [ :enable, :start ]
end

# VirtualHost の設定ファイルを作成し有効化してリロード
template 'dev.hybrid.adinte.jp.conf' do
  path  '/etc/apache2/sites-available/dev.hybrid.adinte.jp.conf'
  owner 'root'
  notifies :run, 'execute[a2ensite_dev.hybrid.adinte.jp]'

end

execute 'a2ensite_dev.hybrid.adinte.jp' do
  action :nothing
  user 'root'
  command 'a2ensite dev.hybrid.adinte.jp'
  notifies :restart, 'service[apache2]'
end

# apache module の適用
execute 'a2enmod' do
  user 'root'
  command 'a2enmod rewrite'
  notifies :restart, 'service[apache2]'
end

