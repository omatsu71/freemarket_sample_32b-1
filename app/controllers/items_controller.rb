class ItemsController < ApplicationController

  def index
    @itemsPickCategory = Item.order("id DESC").limit(3)
    @itemsPickBrand = Item.order("id DESC").limit(3)
  end

  def new
    @item = Item.new
    @item.images.new
    @brand = Brand.new
    @category1 = Category.new
    @category1s = Category.order("id").limit(13)
    # @category2s = Category2.all.order("id")
    # @category3s = Category3.all.order("id")
    @brands = Brand.all.order("id")
  end

  def edit
    @item = Item.find(params[:id])
    @item.images.new
    @brand = @item.brand
    @category1 = @item.category
    @category1s = Category.order("id").limit(13)
    # @category2s = Category2.all.order("id")
    # @category3s = Category3.all.order("id")
    @brands = Brand.all.order("id")
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      @item = Item.new(item_params)
    elsif @brand.name.present?
      b_id = Brand.find_by(name: @brand.name).id
      @item = Item.new(item_params)
      @item["brand_id"] = b_id
    else
      @item = Item.new(item_params)
    end
    @item.save
    Trading.create(item_id: @item.id, user_id: current_user.id)
    redirect_to new_item_path, notice: "出品しました"
  end

  def search
    @items = Item.all.order("id DESC")
  end

  def show
  end

  private
  def brand_params
    params.require(:brand).permit(:name)
  end
  def item_params
    params.require(:item).permit(:name, :category_id, :explanation,:price, :condition, :sent_charge, :shipping_area, :days_to_ship, images_attributes: [:image]).merge(user_id: current_user.id, brand_id: @brand.id)
  end
end