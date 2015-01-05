#
# Cookbook Name:: base_packages
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

# basicなパッケージをインストールする
%w{gcc make git subversion}.each do |pkg|
  package pkg do
    action :install
  end
end
