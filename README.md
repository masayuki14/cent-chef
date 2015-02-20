Vagrant + Chef でサーバー構成管理をやってみるの巻  
Trying provisioning by Vagrant and Chef.

# Setup

## Install vagrant plugin
```
% vagrant plugin install sahara
% vagrant plugin install vagrant-cachier
% vagrant plugin install vagrant-omnibus
```

## Clone Repository

```
% git clone https://github.com/masayuki14/vagrant-chef.git ~/Machines/vagrant-chef
% cd ~/Machines/cent-chef
```

### Vagrantfile作成
```
% cd ~/Machines/vagrant-chef
% ln -s vagrant.d/Vagrantfile.osx Vagrantfile
```

### VagrantでVMを起動

```
% vagrant up
```

### SSHの設定

`vgchef`という名前でSSHの設定を追加する。設定後はホスト名としてコマンドなどで使用する。`% ssh vgchef`でSSHなど。
```
% vagrant ssh-config --host vgchef >> ~/.ssh/config
```

## Chefのセットアップ

### knife-soloのインストール

`Bundler`を使ってインストールする。ない場合はRuby(2.0以上がいい)をインストールする。  
`Bundler`でインストールする場合`knife`コマンドを使う際には`bundle exec knife`のように頭に`bundle exec`が常につく。  
`Bundler`を使わない場合は直接`gem`でインストールする。
初期化ではすべてEnterでよい。

```
% bundle install --path vendor/bundle

# gemで直接インストールする場合
# 必要に応じて sudo をつける
% gem install knife-solo --pre

# 続けてknifeの初期化
% bundle exec knife configure
```

### VM(ノード)にChefSoloを入れる

```
% bundle exec knife solo prepare vgchef
```

### VMでサーバープロビジョニング

```
% cd chef-repo
% bundle exec knife solo cook vgchef
```

`bootstrap`を実行すると上記の`prepare` `cook` のどちらも実行してくれる。
```
% cd chef-repo
% bundle exec knife solo bootstrap vgchef
```
