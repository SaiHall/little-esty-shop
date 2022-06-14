require 'rails_helper'

RSpec.describe 'New bulk discount page' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
    visit new_merchant_bulk_discount_path(@billman)
  end

  it 'has a form for creating a new discount' do
    expect(page).to have_field(:percentage)
    expect(page).to have_field(:threshold)
    expect(page).to have_button("Create New Discount")
  end

  it 'will redirect to the discount index when submitted, and show new entry', :vcr do
    fill_in :percentage, with: '0.60'
    fill_in :threshold, with: '100.0'
    click_button("Create New Discount")

    expect(page).to have_current_path("/merchants/#{@billman.id}/bulk_discounts/")
    expect(page).to have_content("60.0% off")
    expect(page).to have_content("at 100 items")
    expect(page).to_not have_content("5.0% off")
    expect(page).to_not have_content("at 45 items")
  end
end
