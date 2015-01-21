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
