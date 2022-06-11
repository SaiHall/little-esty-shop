require 'rails_helper'

RSpec.describe 'New bulk discount page' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
  end

  it 'has a form for creating a new discount' do
    visit "/merchants/#{@billman.id}/bulk_discounts/new"
    expect(page).to have_field(:percentage)
    expect(page).to have_field(:threshold)
    expect(page).to have_button("Create New Discount")
  end

  it 'will redirect to the discount index when submitted' do
    visit "/merchants/#{@billman.id}/bulk_discounts/new"

    fill_in :percentage, with: '0.60'
    fill_in :threshold, with: '100.0'
    click_button("Create New Discount")
  end
end
