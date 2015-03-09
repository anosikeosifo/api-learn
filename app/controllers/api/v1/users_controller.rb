class Api::V1::UsersController < ApplicationController
	before_action :authenticate_with_token!, only: [:update, :destroy]
	respond_to :json

	def index
		respond_with User.all
	end

	def show
		user  = User.includes(:products).find(params[:id])
		respond_with user
	end

	def create
		user  = User.new(user_params)

		if user.save
			render json: user, status: 201, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422 #error code for unprocessable entity
		end
	end


	def update
		user = current_user#User.find(params[:auth_token])
		user.update(user_params)

		if user.save
			render json: user, status: 200, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422 #unprocessable entity
		end
	end

	def destroy
		current_user.destroy
		head 204
	end

	private 

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
