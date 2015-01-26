#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
  cwd '/tmp'
  user 'root'
  code <<-EOS
    curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
    chmod +x phpbrew
    mv phpbrew /usr/local/bin/phpbrew
  EOS
end

bash 'init_phpbrew' do
  user 'vagrant'
  not_if 'grep "phpbrew/bashrc" ~/.bashrc'
  code <<-EOS
    phpbrew init
    echo 'source ~/.phpbrew/bashrc' >> ~/.bashrc
  EOS
end

bash 'install_php54' do
  user 'vagrant'
  not_if 'phpbrew list | grep "php-5.4.36"'
  code <<-EOS
    phpbrew install 5.4.36
  EOS
end

bash 'use_php54' do
  user 'vagrant'
  code 'phpbrew use php-5.4.36'
end

# compserをインストール
bash 'install_composer' do
  user 'root'
  cwd '/tmp'
  not_if 'which composer'
  code <<-EOS
    curl -sS https://getcomposer.org/installer | php
    sudo -s mv composer.phar /usr/local/bin/composer
  EOS
end

# composerでZendframeworkをインストールする
template 'composer.json' do
  path '/home/vagrant/composer.json'
  owner 'vagrant'
  group 'vagrant'
  mode 0644
end

bash 'compser_install' do
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  code <<-EOS
    composer self-update
    composer install
  EOS
end
