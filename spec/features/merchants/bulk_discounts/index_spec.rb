require 'rails_helper'
#save_and_open_page

RSpec.describe 'bulk discount index' do
  before(:each) do
    @billman = Merchant.create!(name: "Billman")
    @parker = Merchant.create!(name:"Parker")

    @ten = @billman.bulk_discounts.create!(percentage: 0.10, threshold: 10)
    @twenty = @billman.bulk_discounts.create!(percentage: 0.20, threshold: 15)
    @fifty = @billman.bulk_discounts.create!(percentage: 0.50, threshold: 30)

    @five = @parker.bulk_discounts.create!(percentage: 0.05, threshold: 45)
  end

  it 'lists all of a merchants bulk discounts percentages (formatted)', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    expect(page).to have_content(@ten.percentage * 100)
    expect(page).to have_content(@twenty.percentage * 100)
    expect(page).to have_content(@fifty.percentage * 100)

    expect(page).to_not have_content(@five.percentage * 100)
  end

  it 'lists all of a merchants bulk discounts thresholds', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    expect(page).to have_content(@ten.threshold)
    expect(page).to have_content(@twenty.threshold)
    expect(page).to have_content(@fifty.threshold)

    expect(page).to_not have_content(@five.threshold)
  end

  it 'has links next to each discount', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    expect(page.all('.discountDetails')[0]).to have_link("View This Discount")
    expect(page.all('.discountDetails')[1]).to have_link("View This Discount")
    expect(page.all('.discountDetails')[2]).to have_link("View This Discount")
    expect(page.all('.discountDetails')[3]).to eq(nil)
  end

  it 'has links that lead to indiv show pages next to discounts', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    within page.all('.discountDetails')[0] do
      click_link("View This Discount")
      expect(page).to have_current_path("/merchants/#{@billman.id}/bulk_discounts/#{@ten.id}")
    end

    visit merchant_bulk_discounts_path(@billman)

    within page.all('.discountDetails')[2] do
      click_link("View This Discount")
      expect(page).to have_current_path("/merchants/#{@billman.id}/bulk_discounts/#{@fifty.id}")
    end
  end

  it 'has a link to create a new discount', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    expect(page).to have_link("Create New Discount")
    click_link("Create New Discount")

    expect(page).to have_current_path("/merchants/#{@billman.id}/bulk_discounts/new")
  end

  it 'has a link to delete each discount', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    expect(page.all('.discountDetails')[0]).to have_link("Delete This Discount")
    expect(page.all('.discountDetails')[1]).to have_link("Delete This Discount")
    expect(page.all('.discountDetails')[2]).to have_link("Delete This Discount")
    expect(page.all('.discountDetails')[3]).to eq(nil)
  end

  it 'can delete a discount with the link', :vcr do
    visit merchant_bulk_discounts_path(@billman)

    within page.all('.discountDetails')[2] do
      click_link("Delete This Discount")
    end

    expect(page).to have_current_path(merchant_bulk_discounts_path(@billman))

    expect(page.all('.discountDetails')[2]).to eq(nil)
    expect(page).to_not have_content(@fifty.percentage * 100)
    expect(page).to_not have_content(@fifty.threshold)
  end

  it 'has the next three holidays listed on the page', :vcr do
    visit merchant_bulk_discounts_path(@billman)
    within "#upcomingHolidays" do
      expect(page).to have_content("Juneteenth")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("Labour Day")
      expect(page).to_not have_content("Memorial Day")
      expect(page).to_not have_content("Columbus Day")
    end
  end

  it 'has the next three holidays dates listed on the page', :vcr do
    visit merchant_bulk_discounts_path(@billman)
    within "#upcomingHolidays" do
      expect(page).to have_content("2022-06-20")
      expect(page).to have_content("2022-07-04")
      expect(page).to have_content("2022-09-05")
      expect(page).to_not have_content("2023-05-29")
    end
  end
end
