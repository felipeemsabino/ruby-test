# This class represents the rental information, containing information like rental id, rental price and commission values. This class
# will be the result for the output file.
class RentalPriceInformation

	attr_accessor	:id				# the modification rental id
	attr_reader		:rental_id		# rental id
	attr_reader		:price			# rental full price
	attr_reader		:commission		# rental commissions information
	attr_reader 	:options		# rental options (deductible_reduction)
	attr_reader 	:actions		# the list containing information about each stake holder debit or credit
	
	def initialize(id, rental_id, price, commission, options,	actions)
		@id = id
		@rental_id = rental_id
		@price = price
		@commission = commission
		@options = options
		@actions = actions
	end
	
	# Put the class object attrs in a json format
	def as_json(options={})
		{
			id: @id,
			rental_id: @rental_id,
			actions: @actions
		}
	end
  
	# Parse the class object in json
	def to_json(*options)
		as_json(*options).to_json(*options)
	end
end