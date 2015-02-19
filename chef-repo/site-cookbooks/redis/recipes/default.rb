#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w[redis php-redis].each do |pkg|
  package pkg do
    action :install
  end
  if pkg == 'php-redis'
    notifies :restart, 'service[httpd]'
  end
end

service 'redis' do
  action [ :enable, :start ]
end
