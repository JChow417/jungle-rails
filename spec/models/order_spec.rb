require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do
      # Setup at least two products with different quantities, names, etc
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @category1 = Category.create!(name: "Example Category 1")
      @category2 = Category.create!(name: "Example Category 2")
      @product1 = Product.create!(name: 'Example Product 1', price: 10, quantity: 1, category: @category1)
      @product2 = Product.create!(name: 'Example Product 2', price: 100, quantity: 10, category: @category2)
      # Setup at least one product that will NOT be in the order
      @product3 = Product.create!(name: 'Example Product 3', price: 50, quantity: 50, category: @category2)

    end
    # pending test 1
    it 'deducts quantity from products based on their line item quantities' do
      # TODO: Implement based on hints below
      # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
      @quantity1 = 1
      @quantity2 = 5
      @subtotal1 = @quantity1 * @product1.price
      @subtotal2 = @quantity2 * @product2.price
      @cart_total = @subtotal1 + @subtotal2

      @order = Order.new(
        email: @user.email,
        stripe_charge_id: 1234
      )
      # 2. build line items on @order
      @order.line_items.new(
        product: @product1,
        quantity: @quantity1,
        item_price_cents: @product1.price,
        total_price_cents: @subtotal1
      )
      @order.line_items.new(
        product: @product2,
        quantity: @quantity2,
        item_price_cents: @product2.price,
        total_price_cents: @subtotal2
      )
      @order.total_cents = @cart_total
      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!
      # 4. reload products to have their updated quantities
      @product1.reload
      @product2.reload
      # 5. use RSpec expect syntax to assert their new quantity values
      expect(@product1.quantity).to eq 0
      expect(@product2.quantity).to eq 5
    end
    # pending test 2
    it 'does not deduct quantity from products that are not in the order' do
      # TODO: Implement based on hints in previous test
      @quantity1 = 1
      @quantity2 = 5
      @subtotal1 = @quantity1 * @product1.price
      @subtotal2 = @quantity2 * @product2.price
      @cart_total = @subtotal1 + @subtotal2
      @order = Order.new(
        email: @user.email,
        stripe_charge_id: 1234
      )
      @order.line_items.new(
        product: @product1,
        quantity: @quantity1,
        item_price_cents: @product1.price,
        total_price_cents: @subtotal1
      )
      @order.line_items.new(
        product: @product2,
        quantity: @quantity2,
        item_price_cents: @product2.price,
        total_price_cents: @subtotal2
      )
      @order.total_cents = @cart_total
      @order.save!
      @product1.reload
      @product2.reload
      @product3.reload

      expect(@product3.quantity).to eq 50
    end
  end
end
