# packing-trip (ポートフォリオ)

## サイト概要
※このアプリケーションにおいて「パッキング」＝　「旅に持っていく道具のリスト、旅の荷造り」と定義しています。
旅のブログをメインコンテンツとしたSNSです。<br>
その旅のパッキング内容、アイテムをブログ記事に関連づけることができ、見た人がパッキングや道具の参考にできるようにしました。<br>
マイアイテム、マイパッキング機能も用意し、自身のパッキングリストの作成など旅に出る前の準備にも活用できます。<br>
タグや検索機能を充実させ、新しいアイテムやパッキングとの出会いのきっかけを大事にしました。<br>

## サイトテーマ
パッキングして旅する人をつなげる「旅」と「パッキング」にフィーチャーしたSNS

## ターゲットユーザ
旅するハイカー、バイカー、サイクリストなど、パッキングと旅を楽しんでいる人

## 主な利用シーン
- 旅の記録としてブログを投稿。
- パッキングの参考に、他ユーザーの旅ブログやパッキングリストを参照する
![demo1](https://user-images.githubusercontent.com/73775819/112965765-86e81780-9184-11eb-8b51-bcc1d48cd080.gif)
- パッキングリストを作成して忘れ物チェック
- いい道具がないかの検索（重量を条件に検索できる）

## 主な機能紹介
### 登録済みのアイテムからパッキングの作成
忘れ物リスト的な利用も想定しています。<br>
![demo3](https://user-images.githubusercontent.com/73775819/112970646-5eaee780-9189-11eb-881b-2196d42e5463.gif)


### gem 'summernote'を使用したリッチテキストエディタでのブログ投稿
ブログ詳細ページでは登録された目的地の地図をGoogleMapAPIで表示しています。<br>
![demo4](https://user-images.githubusercontent.com/73775819/112972034-c9145780-918a-11eb-9df5-a988f6da3579.gif)


### コメント機能
コメントへの返信機能も実装しています。<br>
![demo8](https://user-images.githubusercontent.com/73775819/112979928-2cef4e00-9194-11eb-8454-164122ad6c51.gif)


### タグ付け機能
タグの入力のフォームにはjqueryプラグイン'Tag-it'を使用しています。<br>
ブログ、パッキング、アイテムへタグ付け可能で、検索にも利用できます。<br>
![demo2](https://user-images.githubusercontent.com/73775819/112969453-370b4f80-9188-11eb-9e7e-6a849e940051.gif)


### 検索機能
複数条件での絞り込みにも対応し、目的のコンテンツを探しやすくしました。<br>
![demo5](https://user-images.githubusercontent.com/73775819/112973345-2eb51380-918c-11eb-87b1-754428f93de4.gif)


### 通知機能
誰かにフォローされた時、フォロー中のユーザーがブログを投稿した時などに通知が届きます。<br>
![demo6](https://user-images.githubusercontent.com/73775819/112974011-eb0ed980-918c-11eb-99f7-aeb7b62e0562.gif)


### ゲストログイン機能
ゲストユーザーは過去の投稿を削除できないなどの制限をつけています。ゲストユーザーでの新規投稿は毎日18時にバッチ処理で削除されます。<br>


## 設計書(一部実際の完成物と齟齬があります)
- [機能一覧(Googleスプレッドシート)](https://docs.google.com/spreadsheets/d/1IIK4spgb3w0cVXS6PsZMzgDguZubS90E3qQx6NWRPU8/edit?usp=sharing)
- [ER図](https://drive.google.com/file/d/1L19Md93zfzRwxPJd_s500LSxSADMmuAw/view?usp=sharing)
- [ワイヤーフレーム(AdobeXD Hand-drawn UI Kitで作成)](https://drive.google.com/file/d/1ys3QuRiSsUQQZTXUCBxegVz-rJt_5llU/view?usp=sharing)
- [テーブル定義書(Googleスプレッドシート)](https://drive.google.com/file/d/1srOg9YIWEgS71aPm1OSiRAb0jqZnQZSZ/view?usp=sharing)
- [アプリケーション詳細設計(Googleスプレッドシート)](https://drive.google.com/file/d/12wHQoi0iIzxY7oGDvix1olaH_2BU-7JA/view?usp=sharing)
- AWS構成図 <br>
![AWS構成図](https://user-images.githubusercontent.com/73775819/112968301-20b0c400-9187-11eb-9736-29ecd4154edd.jpg)

## 開発環境
- OS：Linux(Amazon Linux 2)
- 言語：HTML,SCSS,Ruby (JavaScript,SQL)
- フレームワーク：Ruby on Rails
- CSSフレームワーク：Bootstrap
- JSライブラリ：jQuery
- IDE：Cloud9

## 使用素材
- [Unsplash(フリー画像)](https://unsplash.com/)
- [DesignEvo(ロゴジェネレーター、サイトロゴはこちらで作成しました。)](https://www.designevo.com/jp/)
- [Streamline Lab (トップページのイラスト)](https://lab.streamlinehq.com/)
- 各種アイコン[Font Awesome](https://fontawesome.com/)