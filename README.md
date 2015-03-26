Vagrant + Chef でサーバー構成管理をやってみるの巻  
Trying provisioning by Vagrant and Chef.

# Setup

## Preparing

[Vagrant](https://www.vagrantup.com/downloads.html)
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) を事前にインストールしてください。  

### for Windows

[Ruby](http://rubyinstaller.org/)をインストールします。
あわせて[DevelopmentKit](http://rubyinstaller.org/downloads/)もインストールしてください。  
[Git](http://msysgit.github.io/)をインストールします。
`OpenSSL`と`GitBASH`をインストールするオプションを選択してください。

### for Mac
MacにはRuby,Gitともに標準でインストールされています。
Rubyは[rvm](https://rvm.io/rvm/install)などを利用するのもよいでしょう。


## VirtualMachineを起動する


### Install vagrant plugin

vagrantのpluginをインストールしますが、必須というわけではありません。
あると便利です。[こちら](http://qiita.com/succi0303/items/e06bca7db5a0c3de96af)に解説があります。

```sh
% vagrant plugin install sahara
% vagrant plugin install vagrant-cachier
% vagrant plugin install vagrant-omnibus
```

### Clone Repository

開発環境のリポジトリをダウンロードします。gitで任意の場所にクローンして下さい。

```sh
% git clone https://github.com/masayuki14/vagrant-chef.git ~/Machines/vagrant-chef
```

### Vagrantfile作成
vagrantの設定ファイルである`Vagrantfile`を作成します。
`vagrant.d/`ディレクトリに用意してあるのでそれのリンクを作成します。

```sh
% cd ~/Machines/vagrant-chef
% ln -s vagrant.d/Vagrantfile.osx Vagrantfile
```

### VagrantでVMを起動

vagrantコマンドを使ってVMを起動します。

```sh
% vagrant up
```

### SSHの設定

`vgchef`という名前でSSHの設定を追加します。
設定後はホスト名としてコマンドなどで使用するためです。
例えば `% ssh vgchef` でSSH接続などです。

```sh
% vagrant ssh-config --host vgchef >> ~/.ssh/config
```

これで起動したVMへSSH接続ができます。

```sh
% ssh vgchef

# vagrantコマンドでもSSH接続可能です
% vagrant ssh
```


## Chefのセットアップ

Chefってなに？

* http://thinkit.co.jp/story/2013/11/18/4679
* http://www.atmarkit.co.jp/ait/articles/1502/10/news050.html

今回は `knife-solo` を使ってChefを実行します。


### knife-soloのインストール

`Bundler`を使ってインストールします。ない場合はgemでインストールします。  
`Bundler`でインストールする場合`knife`コマンドを使う際には`bundle exec knife`のように頭に`bundle exec`が常につきます。  
`Bundler`を使わない場合は直接`gem`で直接インストールします。
初期化ではすべてEnter。

```sh
# bundle コマンドがない場合は
% gem install bundler

% bundle install --path vendor/bundle

# gemで直接インストールする場合
# 必要に応じて sudo をつける
% gem install knife-solo --pre

# 続けてknifeの初期化
% bundle exec knife configure
```

### VM(ノード)にChefをインストール

VMにChefをインストールします。
事前にVMのホスト名を`vgchef`として設定しているのでそれを指定します。

```sh
% bundle exec knife solo prepare vgchef
```

# プロビジョニング

`chef-repo/`ディレクトリに移動し`kinfe solo`コマンドを用いてChefを実行します。
サーバー環境の構築がはじまります。

```sh
% cd chef-repo
% bundle exec knife solo cook vgchef
```

`bootstrap`を実行すると上記の`prepare` `cook` のどちらも実行してくれる。
```
% cd chef-repo
% bundle exec knife solo bootstrap vgchef
```


# Links

* https://www.vagrantup.com/downloads.html
* https://www.virtualbox.org/wiki/Downloads
* https://www.ruby-lang.org/ja/documentation/installation/
* http://msysgit.github.io/
* http://thinkit.co.jp/story/2013/11/18/4679
* http://www.atmarkit.co.jp/ait/articles/1502/10/news050.html
