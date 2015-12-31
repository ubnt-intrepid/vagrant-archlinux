## 仮想マシンの起動
```
$ ./createvm.sh  # 仮想マシンを作成し，detach modeで起動
```

起動したらSSHに切り替える
```
root@archiso ~ # loadkeys jp106                         # キーマップの読み込み
root@archiso ~ # systemctl start sshd                   # SSHデーモンを起動
root@archiso ~ # echo -e "vagrant\nvagrant\n" | passwd  # 接続用のパスワードを設定
```
```
$ ssh -p 2222 root@localhost   # SSHで接続
```
接続できたことを確認したら仮想マシンのウィンドウを閉じる

## インストールの実行
root@archiso