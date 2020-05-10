# dotfiles
#### プラグインマネージャー
  - dein.vim
#### Markdownプレビュー
```
:Markdown
# ファイルを開いて上記を実行
```
#### ファイル検索
```
:Files
# カレントディレクトリ以下のファイル検索
```
#### UML
[plantumlをvimでの設定](https://shiro-secret-base.com/?p=271)
```
# uml図生成のコードを書いたら、openコマンドでhtmlファイルを開くとchromeで確認できる
```

#### zshへ変更
```
# 現在のログインシェルを確認
$ echo $SHELL
# sudo vi /etc/shellsで以下を追記
/usr/local/bin/zsh
# ログインシェル変更
$ chsh -s /usr/local/bin/zsh
```

#### git commit_template適用
```
git config --global commit.template ~/.commit_template
```

#### brew file
```
# homebrew install
[homebrew](https://brew.sh/index_ja)

# Brewfileからbrew install(Brewfileがないとだめ)
brew bundle --global

# Brewfileに入っていないアプリを削除
brew bundle cleanup

# Brewfileにインストール済みアプリのリストを出力
brew bundle dump
```

```
# zshrc など必要なconfigファイルのシンボリックリンクを作成
ln -s dotfiles/.zshrc ~/.zshrc
```
- 設定に関しては下記の記事を参考にしています。
[参考記事](https://qiita.com/jiroshin/items/ee86ea426a51fa24b319)
