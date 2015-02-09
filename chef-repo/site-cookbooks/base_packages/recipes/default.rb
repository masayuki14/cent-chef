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

# リポジトリ関連
case node[:platform]
when 'centos'
  # epel, remi リポジトリを追加
  yum_repository 'epel' do
    description node['yum']['epel']['description']
    mirrorlist  node['yum']['epel']['mirrorlist']
    gpgkey      node['yum']['epel']['gpgkey']
    enabled  true
    gpgcheck true
  end

  yum_repository 'remi' do
    description node['yum']['remi']['description']
    mirrorlist  node['yum']['remi']['mirrorlist']
    gpgkey      node['yum']['remi']['gpgkey']
    enabled  true
    gpgcheck true
  end

when 'ubuntu'
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

%w[gcc make git subversion git-svn].each do |pkg|
  install pkg
end

