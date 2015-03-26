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

#link 'hybrid' do
#  target_file '/home/vagrant/hybrid'
#  to          '/home/vagrant/repository/program/keywords'
#  link_type   :symbolic
#  action      :create
#  not_if      'test -L /home/vagrant/hybrid'
#end

# iniファイルの作成
dir = '/home/vagrant/repository/program/keywords/config'
file 'config.ini' do
  path    "#{dir}/database.ini"
  content IO.read("#{dir}/database.ini.sample")
  not_if  "test -f #{dir}/database.ini"
end

file 'redis.ini' do
  path    "#{dir}/redis.ini"
  content IO.read("#{dir}/redis.ini.sample")
  not_if  "test -f #{dir}/redis.ini"
end

# Redisデータのビルド
build_dir = '/home/vagrant/repository/program/keywords/build'
%w[build_category_for_db.php
   build_category_keyword_for_db.php
   build_word_score_for_redis.php
   build_word_sets_for_redis.php].each do |script|
  bash script do
    cwd  build_dir
    code "php #{script}"
  end
end
