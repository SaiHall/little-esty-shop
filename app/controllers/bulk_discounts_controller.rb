class BulkDiscountsController < ApplicationController
  before_action :holiday_info, only: [:index]

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(bd_params)
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/"
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update!(bd_params)
    redirect_to merchant_bulk_discount_path(params[:merchant_id], discount)
  end

  def holiday_info
    @holiday = HolidayFacade.rate_limit_error_backup
  end

  private
  def bd_params
    params.permit(:threshold, :percentage)
  end
end
