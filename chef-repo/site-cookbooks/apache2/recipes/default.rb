#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

web_server = nil
case node[:platform]
when 'ubuntu'
  # Debian系はこっち
  # とりあえず ubuntu サーバへのApacheインストールレシピ
  web_server = 'apache2'

when 'centos'
  # Redhat系はこっち
  web_server  = 'httpd'
end
return if web_server .nil?

package web_server do
  action :install
end

service web_server do
  action [ :enable, :start ]
end

case node[:platform]
when 'ubuntu'
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

when 'centos'

end
