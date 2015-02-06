#
# Cookbook Name:: php
# Recipe:: zend_env
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# ZendFramework1.12をインストールする

# compserをインストール
# あると便利かなーと思うのでどっちにも入れておく
bash 'install_composer' do
  user   'root'
  cwd    '/tmp'
  not_if 'which composer'
  code <<-EOS
    curl -sS https://getcomposer.org/installer | php
    sudo -s mv composer.phar /usr/local/bin/composer
  EOS
end

case node[:platform]
when 'centos'
  # remiリポジトリから1.12をインストール
  package 'php-ZendFramework' do
    action :install
  end

when 'ubuntu'
  # ubuntuのapt-getでは1.11なのでComposerを使ってインストールする
  # composerでZendframeworkをインストールする
  template 'composer.json' do
    owner 'vagrant'
    group 'vagrant'
    mode  0644
    path  '/home/vagrant/composer.json'
  end

  bash 'compser_install' do
    user  'vagrant'
    group 'vagrant'
    cwd   '/home/vagrant'
    code <<-EOS
    composer self-update
    composer install
    EOS
  end

  # include path にZendを加える
  link '/usr/share/php/Zend' do
    to        '/home/vagrant/vendor/zendframework/zendframework1/library/Zend'
    link_type :symbolic
    action    :create
    not_if    'test -L /usr/share/php/Zend'
  end
end


