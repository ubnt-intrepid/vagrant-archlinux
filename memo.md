## 仮想マシンの起動

```
$ ./createvm.sh  # 仮想マシンを作成し，detach modeで起動
```

## インストールの実行

インストール用のスクリプトをダウンロードし実行する
```
root@archiso ~ # curl https://hogehoge.com/path/to/setup.sh > setup.sh
root@archiso ~ # curl https://hogehoge.com/path/to/setup-chroot.sh > setup-chroot.sh
root@archiso ~ # sh setup.sh
root@archiso ~ # poweroff
```

メディアを削除したら終わり
