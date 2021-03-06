class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @itemsPickCategory = Item.order("id DESC").limit(3)
    @imagePickCategory = {}
    @itemsPickCategory.each do |item|
      @imagePickCategory[:"#{item.id}"] = item.images.first
    end

    @itemsPickBrand = Item.order("id DESC").limit(3)
    @imagePickBrand = {}
    @itemsPickBrand.each do |item|
      @imagePickBrand[:"#{item.id}"] = item.images.first
    end
  end

  def new
    @item = Item.new
    @item.images.new
    @brand = Brand.new
    @categories_root = Category.order("id").limit(13)
    gon.image_count = @item.images.count
  end

  def edit
    @category = Category.find(@item.category_id)
    @category_parent = @category.parent
    @category_root = @category.root
    if @item.brand.present?
      @brand = @item.brand
    else
      @brand = Brand.new
    end
    @categories_root = @category.root.siblings
    @categories_parent = @category.parent.siblings
    @categories = @category.siblings
    if @item.size_id.present?
      @sizes = Size.find(@item.size_id).siblings
    end
    gon.image_count = @item.images.count
  end

  def create
    @brand = Brand.new(brand_params)
    unless @brand.save
      if @brand.name.present?
        @brand = Brand.find_by(name: @brand.name)
      end
    end
    @item = Item.new(item_params)
    if @item.save
      Trading.create(item_id: @item.id, user_id: current_user.id)
      redirect_to root_path, notice: "出品しました"
    else
      render :new, notice: "出品に失敗しました"
    end
  end

  def update
    @brand = Brand.new(brand_params)
    unless @brand.save
      if @brand.name.present?
        @brand = Brand.find_by(name: @brand.name)
      end
    end
    if @item.update(item_params)
      redirect_to root_path, notice: "編集しました"
    else
      render :edit, notice: "編集に失敗しました"
    end
  end
  
  #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
  def get_category_parent
    @categories_parent = Category.find(params[:category_root_id]).children
  end

  # 子カテゴリーが選択された後に動くアクション
  #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
  def get_category
    @categories = Category.find(params[:category_parent_id]).children
  end

  # 孫カテゴリーが選択された後に動くアクション
  def get_size
    @category_parent = Category.find(params[:category_id]).parent
    @sizes = @category_parent.sizes[0].children
  end

  def search
    # 空のItemモデルを作成
    @items = Item.none
    # 検索キーワードをスペースで分割してインスタンス化
    @keywords = params[:key].split(/[[:blank:]]+/).select(&:present?)
    # 検索キーワードが空の場合はリダイレクト
    redirect_to root_path, alert: "検索キーワードが空白です" if @keywords.blank?
    # 分割したキーワード毎にItemDBを検索してインスタンスにセット
    @keywords.each do |keyword|
      @items = @items.or(Item.where("name LIKE ?", "%#{keyword}%"))
    end
    @items = @items.order("id DESC")
    @itemImage = {}
    @items.each do |item|
      @itemImage[:"#{item.id}"] = item.images.first
    end
    @q = @items.ransack(params[:q])
    @condition = @items.group(:condition)
    @sent_charge = @items.group(:sent_charge)
    @category = Category.all
    @categories_root = Category.order("id").limit(13)
    @itemsDetail = @q.result.includes(:category, :brand, :size)
  end

  def detail
    @q = Item.ransack(params[:q])
    @keywords = params.require(:q).permit(:name_cont)
    @keyword = @keywords[:name_cont]
    @items = @q.result.includes(:category, :brand, :size)
    @condition = @items.group(:condition)
    @sent_charge = @items.group(:sent_charge)
    @category = Category.all
    @categories_root = Category.order("id").limit(13)
    @itemImage = {}
    @items.each do |item|
      @itemImage[:"#{item.id}"] = item.images.first
    end
  end

  def show
    @item = Item.find(params[:id])
    @comments = @item.comments
    @category = @item.category
    @category = Category.find(@item.category_id)
    @category_parent = @category.parent
    @category_root = @category.root
  end
  
  def destroy
    if @item.destroy
      redirect_to root_path
    else
      render :new, notice: "削除に失敗しました"
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
  def item_params
    params.require(:item).permit(:name, :category_id, :explanation, :price, :size_id, :condition, :sent_charge, :shipping_area, :days_to_ship, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id, brand_id: @brand.id)
  end

end