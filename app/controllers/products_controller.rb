class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new,:create, :edit, :update]

  def index
    @products = Product.includes(:images).order('created_at DESC')
  end

  def new
    @product = Product.new
    @product.images.new

    def get_category_children
      @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
    end

    def get_category_grandchildren
      @category_grandchildren = Category.find("#{params[:child_id]}").children
    end
  end

  def create
    @product = Product.new(product_params)
    @product.saler_id = 1
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @productCategory = @product.category
    @childCategory = @productCategory.parent
    @rootCategory = @productCategory.root
    @category_children = [@childCategory] 

    @rootCategory.children.each do |child|
      if child.name === @childCategory.name
        child.name = "---"
        child.id = "-"
      end
      @category_children << child
    end
    @category_parent_array = [@rootCategory.name]
    Category.where(ancestry: nil).each do |parent|
      if parent.name === @rootCategory.name
        parent.name = "---"
      end
      @category_parent_array << parent.name
    end
    @category_grandchildren_array = [@product.category.name]
    @childCategory.children.each do |grandchild|
      if grandchild.name === @product.category.name
        grandchild.name = "---"
      end
      @category_grandchildren_array << grandchild.name
    end

    def get_category_children

      #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
      @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
    end

    def get_category_grandchildren
      #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
      @category_grandchildren = Category.find("#{params[:child_id]}").children
    end
    @images = @product.images
    if @images.empty?
      @product.images.new
    end
  end

  def update
    @category = Category.find_by(name: params[:category_id])
    @product.category_id = @category.id
    if @product.update(product_params)
      redirect_to root_path
    else
      redirect_to edit_product_path(@product.id)
    end
  end

  def destroy
    if @product.destroy
      redirect_to root_path
    else
      render :show
  end

  private

  
  def product_params
    params.require(:product).permit(:name, :price, :description, :status_id, :delivery_date_id, :shopping_charge_id,:categories_id, :prefecture_id, images_attributes: [:src, :_destroy, :id])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_categories
    @category_parent_array = ["---"]
    #データベースから、親カテゴリーのみ抽出し、配列化
    Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
    end
  end
end
