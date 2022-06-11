class BulkDiscountsController < ApplicationController

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

  private
  def bd_params
    params.permit(:threshold, :percentage)
  end
end
