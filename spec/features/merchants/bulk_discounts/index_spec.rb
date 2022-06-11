require 'rails_helper'

RSpec.describe 'bulk discount index' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
  end

  it 'lists all of a merchants bulk discounts percentages (formatted)' do
    visit "/merchants/#{@billman.id}/bulk_discounts"

    expect(page).to have_content(@ten.percentage * 100)
    expect(page).to have_content(@twenty.percentage * 100)
    expect(page).to have_content(@fifty.percentage * 100)

    expect(page).to_not have_content(@five.percentage * 100)
  end

  it 'lists all of a merchants bulk discounts thresholds' do
    visit "/merchants/#{@billman.id}/bulk_discounts"

    expect(page).to have_content(@ten.threshold)
    expect(page).to have_content(@twenty.threshold)
    expect(page).to have_content(@fifty.threshold)

    expect(page).to_not have_content(@five.threshold)
  end
end
