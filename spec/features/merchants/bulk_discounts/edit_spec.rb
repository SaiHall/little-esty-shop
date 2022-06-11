require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
  end

  it 'has a pre-filled form to edit the discount' do
    visit edit_merchant_bulk_discount_path(@billman, @fifty)

    expect(page).to have_field(:percentage, with: 0.50)
    expect(page).to have_field(:threshold, with: 30)
    expect(page).to have_button("Submit")
  end

  it 'can update the discount percentage when submitted' do
    visit edit_merchant_bulk_discount_path(@billman, @fifty)

    fill_in(:percentage, with: 0.40)
    click_button("Submit")

    expect(page).to have_current_path(merchant_bulk_discount_path(@billman, @fifty))
    expect(page).to have_content("40.0")
    expect(page).to have_content(@fifty.threshold)
  end

  it 'can update the discount threshold when submitted' do
    visit edit_merchant_bulk_discount_path(@billman, @fifty)

    fill_in(:threshold, with: 100)
    click_button("Submit")

    expect(page).to have_current_path(merchant_bulk_discount_path(@billman, @fifty))
    expect(page).to have_content(@fifty.percentage * 100)
    expect(page).to have_content("100")
  end

  it 'can update both threshold and percentage when submitted' do
    visit edit_merchant_bulk_discount_path(@billman, @fifty)

    fill_in(:percentage, with: 0.40)
    fill_in(:threshold, with: 100)
    click_button("Submit")

    expect(page).to have_current_path(merchant_bulk_discount_path(@billman, @fifty))
    expect(page).to have_content("40.0")
    expect(page).to have_content("100")
  end
end
