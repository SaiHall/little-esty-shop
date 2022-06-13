require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before :each do
    @billman = Merchant.create!(name: "Billman")
    @bracelet = @billman.items.create!(name: "Bracelet", description: "shiny", unit_price: 1001)
    @mood = @billman.items.create!(name: "Mood Ring", description: "Moody", unit_price: 2002)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: "Ondricka")
    @invoice_1 = @customer_1.invoices.create!(status: "cancelled")
    @invoice_items_1 = @bracelet.invoice_items.create!(quantity: 1, unit_price: 1001, status: "Pending", invoice_id: @invoice_1.id)
    @parker = Merchant.create!(name: "Parker's Perfection Pagoda")

    @brenda = Customer.create!(first_name: "Brenda", last_name: "Bhoddavista")
    @invoice1 = @brenda.invoices.create!(status: "In Progress")
    @order1 = @bracelet.invoice_items.create!(quantity: 1, unit_price: 1001, status: "Pending", invoice_id: @invoice1.id)
    @order2 = @mood.invoice_items.create!(quantity: 5, unit_price: 2002, status: "Packaged", invoice_id: @invoice1.id)
    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 5)

  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
    it {should have_many :transactions}
    it {should have_many :bulk_discounts}
  end

  describe 'validations' do
    it {should validate_presence_of(:quantity)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:status)}

  end

  describe "instance methods" do
    it "converts unit price into dollar format" do
      expect(@invoice_items_1.price_convert).to eq(10.01)
    end

    it 'belongs to merchant returns true if an invoice item belongs to the given merchant' do

      expect(@invoice_items_1.belongs_to_merchant(@billman)).to eq(true)
    end

    it 'belongs to merchant returns false if an invoice item does not belong to the given merchant' do

      expect(@invoice_items_1.belongs_to_merchant(@parker)).to eq(false)
    end

    it 'can show the amount discounted from an invoice_item' do

      expect(@invoice1.invoice_items.discounted_difference).to eq(10.01)
    end

    it 'can return the best discount' do
      order3 = @bracelet.invoice_items.create!(quantity: 10, unit_price: 1001, status: "Packaged", invoice_id: @invoice1.id) #25.025 off at 25%/ 10.01 off at 10%
      @billman.bulk_discounts.create!(percentage: 0.25, threshold: 10)
      expect(order3.indiv_discount.percentage).to eq(0.25)
    end
    it 'can select the correct discount if multiple may apply' do
      order3 = @bracelet.invoice_items.create!(quantity: 10, unit_price: 1001, status: "Packaged", invoice_id: @invoice1.id) #25.025 off at 25%/ 10.01 off at 10%
      @billman.bulk_discounts.create!(percentage: 0.25, threshold: 10)
      expect(@invoice1.invoice_items.discounted_difference.round(2)).to eq(35.04)
    end
  end
end
