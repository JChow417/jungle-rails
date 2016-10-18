class Order < ActiveRecord::Base
  after_create :change_product_quantity

  belongs_to :user
  has_many :line_items

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true


  def change_product_quantity
    @line_items = self.line_items
    @line_items.each do |line_item|
      line_item.product.quantity -= line_item.quantity
      line_item.product.save
    end
  end

end
