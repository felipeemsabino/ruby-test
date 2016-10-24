# This class represents the rental information, containing information like rental id, rental price and commission values. This class
# will be the result for the output file.
class RentalPriceInformation

	attr_reader		:id				# rental id
	attr_reader		:price			# rental full price
	attr_reader		:commission		# rental commissions information
	attr_reader 	:options		# rental options (deductible_reduction)
	
	def initialize(id, price, commission, options)
		@id = id
		@price = price
		@commission = commission
		@options = options
	end
	
	# Put the class object attrs in a json format
	def as_json(options={})
		{
			id: @id,
			price: @price,
			options: @options,
			commission: @commission
		}
	end
  
	# Parse the class object in json
	def to_json(*options)
		as_json(*options).to_json(*options)
	end
end