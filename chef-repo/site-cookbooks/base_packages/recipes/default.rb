#
# Cookbook Name:: base_packages
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

bash 'apt-get_update' do
  user 'root'
  code <<-EOS
    apt-get update
  EOS
end

# basicなパッケージをインストールする
%w{gcc make git subversion apache2}.each do |pkg|
  package pkg do
    action :install
  end
end

service 'apache2' do
  action [ :enable, :stop ]
end
