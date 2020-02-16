## User
|Type|Colume|Options|
|------|----|-------|
|t.string|nickname|null: false, unique: true, index: true|
|t.string|email|null: false, unique: true, default: ""|
|t.string |:encrypted_password|, null: false, default: ""
|t.integer |:sales|| #売上金
|t.integer |:points|| #ポイント
|t.string   |:reset_password_token||
|t.datetime |:reset_password_sent_at||
|t.datetime |:remember_created_at||
### Association
- belongs_to :address
- has_many :items
- has_many :credit_cards
- has_many :items, through: :During_trading_exihition

## Identity(本人確認情報)
|Type|Colume|Options|
|------|----|-------|
|t.string| :name|,null: false|
|t.string| :name_kana|,null: false|
|t.integer| :birthday|,null: false|
|t.string| :prefecture||      #都道府県
|t.string| :house_number||      #番地
|t.string| :building_name||      #建物名
|t.string| :identity_image||   #本人確認
|t.references| :user|, foreign_key: true|
### Association
- belongs_to :user

## Sent_address(発送元・お届け先住所変更)
|Type|Colume|Options|
|------|----|-------|
|t.string :familyname,null: false
|t.string :firstname,null: false
|t.string :familyname_kana,null: false
|t.string :firstname_kana,null: false
|t.integer :postal_code,null: false  #郵便番号
|t.string :prefecture,null: false  #都道府県
|t.string :municipality,null: false  #市区町村
|t.string :house_number,null: false  #番地
|t.string :building_name      #建物名
|t.integer :phone_number      #電話
|t.references :user, foreign_key: true
### Association
- belongs_to :user

## Credit_card
t.string :card_name,                      null: false
t.integer :card_number,                   null: false
t.integer :expiration_rate_year,          null: false   #有効期限・年
t.integer :expiration_rate_month,         null: false   #有効期限・月
t.references :user, foreign_key: true
### Association
belongs_to :user

## todo
t.text :todo,null: false
### Association
belongs_to :user


## Information
t.text :information,null: false
### Association
belongs_to :user



## Favorite (いいね！)
t.references :user, foreign_key: true
t.references :item, foreign_key: true
t.timestamps
### Association
belongs_to :user
belongs_to :item


## Trading(出品した商品:取引中-売却済み)
t.boolean :status, default: false, null: false #売約済みでtrue、取引中でfalse
t.references :user, foreign_key: true
t.references :item, foreign_key: true
t.timestamps
### Association
belongs_to :user
belongs_to :item

## Purchased
t.boolean :status, default: false, null: false #購入済みでtrue、取引中でfalse
t.string :assessment                           #評価（良い、悪い、普通、nil)
t.references :user, foreign_key: true
t.references :item, foreign_key: true
t.timestamps
### Association
belongs_to :user
belongs_to :item


## Item(商品)
t.string :item_name,null: false, index: true          #商品名
t.text :explanation,null: false    #説明
t.integer :price,null: false        #価格
t.string :size                      #サイズ
t.string :condition,null: false     #状態（選択式）
t.string :sent_charge,null: false  #配送料の負担
t.string :shipping_area,null: false  #発送元の地域（選択式）
t.string :days_to_ship,null: false  #発送までの日数（選択式）
t.references :user, foreign_key: true #出品者
t.references :brand, foreign_key: true #ブランド
t.references :category1, foreign_key: true
t.references :category2, foreign_key: true
t.references :category3, foreign_key: true
t.timestamps
### Association
belongs_to :user
belongs_to :brand
belongs_to :category1
belongs_to :category2
belongs_to :category3
has_many :images
has_many :favorites
has_many :tradings
has_many :purchaseds


## Image
t.string :image,null: false, index: true
t.references :item, foreign_key: true
t.timestamps
### Association
belongs_to :item


## Comment(itemへのコメント)
t.text :comment
t.references :item, foreign_key: true
t.timestamps
### Association
belongs_to :item


## Category1
t.string :category1_name,null: false, index: true      #カテゴリー1の名称
### Association
has_many :items
has_many :category2s
has_many :category3s, through: category2s


## Category2
t.string :category2_name,null: false, index: true      #カテゴリー2の名称
t.references :category1, foreign_key: true
### Association
belongs_to :category1
has_many :items
has_many :category3s


## Category3
t.string :category3_name,null: false, index: true       #カテゴリー3の名称
t.references :category2, foreign_key: true
### Association
belongs_to :category2
has_many :items
has_one :category1, through: :category2


## Brand
t.string :brand_name,null: false, unique: true, index: true
### Association
has_many :items

[![Image from Gyazo](https://i.gyazo.com/f2f474aa8aac625560a6da79a9d73771.png)](https://gyazo.com/f2f474aa8aac625560a6da79a9d73771)