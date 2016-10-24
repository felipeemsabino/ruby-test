# This class represent the car entity with informations such as car id, price per day and price per km.
class Car
	
	attr_reader  :id				# the car id
	attr_reader  :price_per_day		# the car price per day
	attr_reader  :price_per_km		# the car price per km

	def initialize(car_params)
		@id = car_params["id"]
		@price_per_day = car_params["price_per_day"]
		@price_per_km = car_params["price_per_km"]
	end
end