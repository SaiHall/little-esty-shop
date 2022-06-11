require 'rails_helper'

RSpec.describe 'bulk discount show' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
  end

  it 'has the details for one discount' do
    visit merchant_bulk_discount_path(@billman, @fifty)

    expect(page).to have_content(@fifty.percentage * 100)
    expect(page).to have_content(@fifty.threshold)
    expect(page).to_not have_content(@five.percentage * 100)
    expect(page).to_not have_content(@five.threshold)
  end

  it 'has a link to edit the discount' do
    visit merchant_bulk_discount_path(@billman, @fifty)

    expect(page).to have_link("Edit Discount")
  end

  it 'directs the user to the edit page when the edit link is clicked' do
    visit merchant_bulk_discount_path(@billman, @fifty)

    click_link("Edit Discount")

    expect(page).to have_current_path(edit_merchant_bulk_discount_path(@billman, @fifty))
  end
end
