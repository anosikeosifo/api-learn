class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, meta: meta: pagination(orders, params[:per_page]
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    #build placements for the order
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantity(params[:order][:product_ids_with_qty])

    if order.save
      order.reload
      OrderMailer.delay.send_confirmation(order)#.deliver #sends a mail to the user
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: {errors: order.errors},  status: 422
    end
  end
end
