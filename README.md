Vagrant + Chef でサーバー構成管理をやってみるの巻  
Trying provisioning by Vagrant and Chef.

# Setup

## Preparing

[Vagrant](https://www.vagrantup.com/downloads.html)
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) を事前にインストールしておいてください。  

### for Windows

[Ruby](http://rubyinstaller.org/)をインストールします。
あわせて[DevelopmentKit](http://rubyinstaller.org/downloads/)もインストールしてください。  
[Git](http://msysgit.github.io/)をインストールします。`OpenSSL`と`GitBASH`をインストールするようにします。

### for Mac
Macには標準でインストールされていますが[rvm](https://rvm.io/rvm/install)などを利用するのよいでしょう。


## Install vagrant plugin

vagrantのpluginをインストールしますが、必須というわけでは有ります。あると便利です。[こちら](http://qiita.com/succi0303/items/e06bca7db5a0c3de96af)に解説があります。

```
% vagrant plugin install sahara
% vagrant plugin install vagrant-cachier
% vagrant plugin install vagrant-omnibus
```


## Clone Repository

開発環境のリポジトリをダウンロードします。gitで任意の場所にクローンして下さい。

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


# Install Links

* https://www.vagrantup.com/downloads.html
* https://www.virtualbox.org/wiki/Downloads
* https://www.ruby-lang.org/ja/documentation/installation/
* http://msysgit.github.io/
