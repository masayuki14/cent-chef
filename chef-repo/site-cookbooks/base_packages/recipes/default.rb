#
# Cookbook Name:: base_packages
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

def install(pkg)
  package pkg do
    action :install
  end
end

if node[:platform] == 'ubuntu'
  bash 'apt-get_update' do
    user 'root'
    code 'apt-get update'
  end
end

# basicなパッケージをインストールする
case node[:platform]
when  'centos'
  %w[vim-enhanced screen].each do |pkg|
    install pkg
  end
end

%w{gcc make git subversion git-svn}.each do |pkg|
  install pkg
end

