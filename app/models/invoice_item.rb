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

  def discounted?
    indiv_discount != 0
  end

  def indiv_discount
    bulk_discounts.where('threshold <= ?', quantity)
      .order(percentage: :desc).first || 0
  end

  def self.discounted_difference
    joins(:bulk_discounts)
      .where('invoice_items.quantity >= threshold')
      .select("invoice_items.*, max(percentage) as perc")
      .group(:id)
      .sum{|obj| ((obj.unit_price * obj.quantity) * (obj.perc.to_f)) * 0.01}
  end
end
