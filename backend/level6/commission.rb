# This class represents the insurance, assistance and drivy commissions for each rental
class Commission
	
	attr_reader		:insurance_fee	# half goes to the insurance
	attr_reader		:assistance_fee	# 1€/day goes to the roadside assistance
	attr_reader		:drivy_fee		# rest of money goes to drivy
	
	def initialize(insurance_fee, assistance_fee, drivy_fee)
		@insurance_fee = insurance_fee
		@assistance_fee = assistance_fee
		@drivy_fee = drivy_fee
	end
	
	# Put the class object attrs in a json format
	def as_json(options={})
		{
			insurance_fee: @insurance_fee,
			assistance_fee: @assistance_fee,
			drivy_fee: @drivy_fee
		}
	end

  	# Parse the class object in json
	def to_json(*options)
		as_json(*options).to_json(*options)
	end
end