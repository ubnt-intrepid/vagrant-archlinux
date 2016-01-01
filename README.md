# ArchLinux Vagrant box 作成用スクリプト

## 仮想マシンの作成

```
host% git clone https://github.com/ys-nuem/vagrant-archlinux
host% cd vagrant-archlinux
host% ln -s /path/to/archlinux-2015.12.01-dual.iso $PWD
host% ./createvm.sh
```

## インストールの実行
```
root@archiso ~ # curl -L "https://raw.githubusercontent.com/ys-nuem/vagrant-archlinux/master/autorun.sh" | bash
root@archiso ~ # ...
root@archiso ~ # poweroff
```

## VagrantBoxの作成

```
host% vagrant package --base vagrant-archlinux --output arch64.box
host% vagrant box add arch64 arch64.box
host% rm arch64.box
```
