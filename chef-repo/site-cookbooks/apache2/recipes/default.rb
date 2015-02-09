#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when 'centos'
  package 'httpd' do
    action :install
  end

  service 'httpd' do
    action [ :enable, :start ]
  end

when 'ubuntu'
  package 'apache2' do
    action :install
  end

  service 'apache2' do
    action [ :enable, :start ]
  end

  # VirtualHost の設定ファイルを作成し有効化してリロード
  template 'dev.hybrid.local.conf' do
    path     '/etc/apache2/sites-available/dev.hybrid.local.conf'
    owner    'root'
    notifies :run, 'execute[a2ensite_dev.hybrid.local]'
  end

  execute 'a2ensite_dev.hybrid.local' do
    action   :nothing
    user     'root'
    command  'a2ensite dev.hybrid.local'
    notifies :restart, 'service[apache2]'
  end

  # apache module の適用
  execute 'a2enmod' do
    user     'root'
    command  'a2enmod rewrite'
    notifies :restart, 'service[apache2]'
  end
end
