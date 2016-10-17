require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'should have no errors when all product fields are filled' do
    @category = Category.create(name: "Example Category")
    @product = Product.create(name: 'Example Product', price: 1, quantity: 1, category: @category)
    expect(@product.errors.size).to be 0
    expect(@product.errors.full_messages).to be_empty

  end

  it 'should validate product name and give error when name is equal to nil' do
    @category = Category.create(name: "Example Category")
    @product = Product.create(price: 1, quantity: 1, category: @category)
    expect(@product.errors.size).to be 1
    expect(@product.errors.full_messages).to include('Name can\'t be blank')
  end

  it 'should validate product price and give error when name is equal to nil' do
    @category = Category.create(name: "Example Category")
    @product = Product.create(name: 'Example Product', quantity: 1, category: @category)
    expect(@product.errors.size).to be 3
    expect(@product.errors.full_messages).to include('Price can\'t be blank')
  end

  it 'should validate product quantity and give error when name is equal to nil' do
    @category = Category.create(name: "Example Category")
    @product = Product.create(name: 'Example Product', price: 1, category: @category)
    expect(@product.errors.size).to be 1
    expect(@product.errors.full_messages).to include('Quantity can\'t be blank')
  end

  it 'should validate product category and give error when name is equal to nil' do
    @product = Product.create(name: 'Example Product', price: 1, quantity: 1)
    expect(@product.errors.size).to be 1
    expect(@product.errors.full_messages).to include('Category can\'t be blank')
  end
end
