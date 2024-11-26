class CartsController < ApplicationController
  before_action :set_product, only: [:create, :destroy]
  before_action :set_cart_item, only: [:update_cart_item, :destroy]

  def create
    cart_item = @current_cart.cart_items.find_by(product_id: @product.id)

    if cart_item
      cart_item.quantity += 1
      cart_item.save
    else
      @current_cart.cart_items.create(product_id: @product.id, quantity: 1)
    end

    redirect_to cart_path(@current_cart), notice: 'Item added to cart.'
  end

  def show
    # Display the current cart
  end

  def update_cart_item
    @current_cart_item = @current_cart.cart_items.find_by(id: params[:id])

    if @current_cart_item.nil?
      redirect_to cart_path(@current_cart), alert: "Cart item not found."
      return
    end

    new_quantity = params[:cart_item][:quantity].to_i
    if @current_cart_item.update(quantity: new_quantity)
      redirect_to cart_path(@current_cart), notice: "Quantity updated successfully."
    else
      redirect_to cart_path(@current_cart), alert: "Failed to update quantity."
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_path(@current_cart), notice: 'Item removed from cart.'
  end

  # Other methods...

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_cart_item
    @cart_item = @current_cart.cart_items.find_by(id: params[:id])
  end
end
