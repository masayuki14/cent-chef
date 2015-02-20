#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when 'centos'
  %w{php php-phpunit-PHPUnit}.each do |pkg|
    package pkg do
      action :install
    end
  end

  # php.iniの設定
  template 'php.ini' do
    path     '/etc/php.ini'
    owner    'root'
    notifies :restart, 'service[httpd]'
  end

  # error_log の設置
  directory File.dirname(node['php']['error_log']) do
    user     'root'
    group    'root'
    mode      0755
    recursive true
    action    :create
  end

  file node['php']['error_log'] do
    owner  'root'
    group  'root'
    mode    0666
    action  :create
  end

when 'ubuntu'

  %w{php5 phpunit}.each do |pkg|
    package pkg do
      action :install
    end
  end

  # php5.4のbuildに必要なパッケージ
  %w{libxml2 libxml2-dev openssl pkg-config libcurl4-openssl-dev libbz2-dev libmcrypt-dev libreadline-dev libxslt1-dev}.each do |pkg|
    package pkg do
      action :install
    end
  end

  # phpbrewを使って5.4をインストールする
  bash 'install_phpbrew' do
    not_if 'which phpbrew'
    cwd    '/tmp'
    user   'root'
    code <<-EOS
      curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
      chmod +x phpbrew
      mv phpbrew /usr/local/bin/phpbrew
    EOS
  end

  bash 'init_phpbrew' do
    not_if 'grep "phpbrew/bashrc" ~/.bashrc'
    user 'vagrant'
    code <<-EOS
      phpbrew init
      echo 'source ~/.phpbrew/bashrc' >> ~/.bashrc
    EOS
  end

  bash 'install_php54' do
    not_if 'phpbrew list | grep "php-5.4.36"'
    user   'vagrant'
    group  'vagrant'
    code   'phpbrew install 5.4.36'
  end
end
