class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    #build placements for the order
    order.build_placements_with_product_ids_and_quantity(params[:order][:product_ids_with_qty])

    if order.save
      OrderMailer.send_confirmation(order).deliver #sends a mail to the user
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: {errors: order.errors},  status: 422
    end
  end
end
