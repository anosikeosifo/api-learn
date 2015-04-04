class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end
end
