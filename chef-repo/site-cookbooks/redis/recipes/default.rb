#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w[redis php-redis].each do
  package 'redis' do
    action :install
  end
end

service 'redis' do
  action [ :enable, :start ]
end
