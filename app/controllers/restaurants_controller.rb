class RestaurantsController < ApplicationController

	def index
		@restaurants =  Restaurant.all
	end

	def new
		@restaurant = Restaurant.new
	end

	def create
		@restaurant = Restaurant.create(params[:restaurant].permit(:name))
		redirect_to '/restaurants'
	end

	private

	# def ad_params
	# 	params[:restaurant].permit(:name)
	# end
end
