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
link 'htdocs' do
  target_file '/home/vagrant/zf1'
  to          '/home/vagrant/repository/program/keywords/htdocs'
  link_type   :symbolic
  action      :create
  not_if      'test -L /home/vagrant/zf1'
end
