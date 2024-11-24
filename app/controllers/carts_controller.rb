class CartsController < ApplicationController
  before_action :set_product, only: [:create, :destroy]
  before_action :set_cart_item, only: [:update_quantity, :destroy]

  def create
    cart_item = @current_cart.cart_items.find_by(product_id: @product.id)

    if cart_item
      # If the item is already in the cart, increase the quantity
      cart_item.quantity += 1
      cart_item.save
    else
      # Otherwise, add a new item to the cart
      @current_cart.cart_items.create(product_id: @product.id, quantity: 1)
    end

    redirect_to cart_path(@current_cart), notice: 'Item added to cart.'
  end

  def show
    # Displays the current cart with its items
  end

  def checkout
    # Checkout logic remains unchanged
  end

  def update_quantity
    # Update the quantity of a specific item
    if @cart_item.update(quantity: params[:quantity].to_i)
      redirect_to cart_path(@current_cart), notice: 'Quantity updated.'
    else
      redirect_to cart_path(@current_cart), alert: 'Failed to update quantity.'
    end
  end

  def update_cart_item
    @cart_item = @current_cart.cart_items.find(params[:id])
  
    # Ensure quantity is updated and saved to the database
    if @cart_item.update(quantity: params[:cart_item][:quantity].to_i)
      redirect_to cart_path(@current_cart), notice: "Quantity updated successfully."
    else
      redirect_to cart_path(@current_cart), alert: "Failed to update quantity."
    end
  end  

  def destroy
    # Remove a specific item from the cart
    @cart_item.destroy
    redirect_to cart_path(@current_cart), notice: 'Item removed from cart.'
  end

  STRIPE_SUPPORTED_COUNTRIES = ["US", "CA", "GB", "AU", "BY", "EC", "GE", "ID", "MX", "OM", "RU", "RS", "VN", "TZ"]

  def stripe_session
    session = Stripe::Checkout::Session.create({
      ui_mode: 'embedded',
      line_items: @current_cart.cart_items.includes(:product).map do |cart_item| {
        # Provide the exact Price ID (e.g., pr_1234) of the product you want to sell
        price_data: {
          currency: "usd",
          unit_amount: (@current_cart.products.sum(&:price) * 100).to_i,
          product_data: {
            name: @current_cart.products.map(&:name).join(", ")
          },
        },
        quantity: cart_item.quantity,
      }
    end,
      shipping_address_collection: {
        allowed_countries: STRIPE_SUPPORTED_COUNTRIES
      },
      automatic_tax: { enabled: true },
      mode: 'payment',
      return_url: success_cart_url(@current_cart.secret_id),
    })

    render json: { clientSecret: session.client_secret }
  end

  def success
    # Find the purchased cart based on the secret ID
    @purchased_cart = Cart.find_by(secret_id: params[:id])
    
    # Redirect to the root path if the cart is not found
    redirect_to root_path, alert: "Cart not found." unless @purchased_cart
  
    # Fetch the purchased items from the cart
    @items = @purchased_cart.cart_items.includes(:product)
  
    # Calculate total amounts and tax
    @total_amount = @items.sum { |item| item.quantity * item.product.price }
    @tax = (@total_amount * 0.05).round(2) # Example tax rate: 5%
  end  

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  def set_cart
    @current_cart = current_cart
  end

  def set_cart_item
    @cart_item = @current_cart.cart_items.find(params[:id])
  end  
end
