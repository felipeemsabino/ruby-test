# This class represents a Rental entity and contains information such as rental id, car id, start date, end date and distance
class Rental
	
	attr_reader  :id					# the rental id
	attr_reader  :car_id				# the rental car id
	attr_reader  :start_date			# the rental starting date
	attr_reader  :end_date				# the rental ending date
	attr_reader  :distance				# the rental distance
	attr_reader  :deductible_reduction	# the rental deductible reduction option
	
	def initialize(rental_params)
		@id = rental_params["id"]
		@car_id = rental_params["car_id"]
		@start_date = rental_params["start_date"]
		@end_date = rental_params["end_date"]
		@distance = rental_params["distance"]
		@deductible_reduction = rental_params["deductible_reduction"]
	end
end