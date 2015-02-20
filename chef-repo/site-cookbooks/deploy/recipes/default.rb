#
# Cookbook Name:: deploy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# permittionを変更
directory '/home/vagrant' do
  mode 0755
  action :create
end

# リンクを作成
# for apache document root
link 'htdocs' do
  target_file '/home/vagrant/zf1'
  to          '/home/vagrant/repository/program/keywords/htdocs'
  link_type   :symbolic
  action      :create
  not_if      'test -L /home/vagrant/zf1'
end

link 'hybrid' do
  target_file '/home/vagrant/hybrid'
  to          '/home/vagrant/repository/program/keywords'
  link_type   :symbolic
  action      :create
  not_if      'test -L /home/vagrant/hybrid'
end

# iniファイルの作成
file 'config.ini' do
  dir = '/home/vagrant/hybrid/app/config'
  path    "#{dir}/config.ini"
  content IO.read("#{dir}/config.ini.sample")
  not_if  "test -f #{dir}/config.ini"
end

file 'redis.ini' do
dir = '/home/vagrant/hybrid/htdocs/application/configs'
  path    "#{dir}/redis.ini"
  content IO.read("#{dir}/redis.ini.sample")
  not_if  "test -f #{dir}/redis.ini"
end

# Redisデータのビルド
bash 'build_word_category.php' do
  cwd  '/home/vagrant/hybrid/app/script'
  code 'php build_word_category.php'
end

bash 'build_word_sets.php' do
  cwd  '/home/vagrant/hybrid/app/script'
  code 'php build_word_sets.php'
end
