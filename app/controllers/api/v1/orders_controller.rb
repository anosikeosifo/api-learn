class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, meta: {
      pagination: {
        per_page: params[:per_page],
        total_pages: orders.total_pages,
        total_objects: orders.total_count
      }  
    }
  end

  def sho
    respond_with current_user.orders.find(params[:id])
  end

  def create
    #build placements for the order
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantity(params[:order][:product_ids_with_qty])

    if order.save
      OrderMailer.send_confirmation(order).deliver #sends a mail to the user
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: {errors: order.errors},  status: 422
    end
  end
end
