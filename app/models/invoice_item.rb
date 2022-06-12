class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :item

  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  def price_convert
    unit_price * 0.01.to_f
  end

  def belongs_to_merchant(merchant)
    item.merchant == merchant
  end

  def self.discounted_difference
    joins(:bulk_discounts)
      .where('invoice_items.quantity >= threshold')
      .select('invoice_items.*, percentage')
      .sum('((invoice_items.unit_price * quantity) * percentage)') * 0.01.to_f
  end
end
