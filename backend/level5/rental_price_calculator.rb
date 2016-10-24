require './car'  
require './rental'  
require './commission'  
require './rental_price_information'

# This class is responsible for calculate all rental prices and commissions
class RentalPriceCalculator
	
	attr_accessor	:cars
	attr_accessor	:rentals
	
	def initialize(json_cars, json_rentals)
		create_cars_entites(json_cars)
		create_rentals_entites(json_rentals)
	end
	
	# Create and populate the car array
	def create_cars_entites (json_cars)
		@cars = Array.new
		json_cars.each do |current_car|
			@cars.push(Car.new(current_car))
		end
	end
	
	# Create and populate the rental array
	def create_rentals_entites (json_rentals)
		@rentals = Array.new
		json_rentals.each do |current_rental|
			@rentals.push(Rental.new(current_rental))
		end
	end
	
	#Iterate over the rentals and car hash seeking for the rental
	def calculate_rental_price
		rentals_prices_array = Array.new
		@rentals.each do |rental|
			@cars.each do |car|
				if car.id == rental.car_id #got the rental and respective car
				
					#calculating number of days
					start_date = Date.strptime(rental.start_date, '%Y-%m-%d') 
					final_date = Date.strptime(rental.end_date, '%Y-%m-%d')
					number_of_days = (start_date .. final_date).count

					#calculating prices per day and distance
					price_for_days = calculate_price_with_discount(car.price_per_day, number_of_days)
					price_for_distance = car.price_per_km * rental.distance
					total_rental_prince = price_for_days + price_for_distance

					#creating structure	for the results
					commissions = calculate_commissions(total_rental_prince, number_of_days)
					options = calculate_options(number_of_days, rental.deductible_reduction)
					actions = calculate_actions(total_rental_prince, commissions, options)
					rentalInformation = RentalPriceInformation.new(rental.id, total_rental_prince, commissions, options, actions)
					rentals_prices_array.push(rentalInformation)
				end
			end
		end

		return rentals_prices_array
	end
	
	# Calculate the price using the discount rule
	def calculate_price_with_discount(price_per_day, number_of_days)
		total_price = 0
		for daysCount in 1..number_of_days
			if daysCount < 2
				total_price += price_per_day
			elsif daysCount <= 4 # after the second day 10% of discount
				total_price += (price_per_day - (price_per_day*10/100))
			elsif daysCount <= 10 # after the fourth day 10% of discount
				total_price += (price_per_day - (price_per_day*30/100))
			else  # after the tenth day 10% of discount
				total_price += (price_per_day - (price_per_day*50/100))
			end
		end
		return total_price
	end
	
	# Calculate the commissions from a rental
	def calculate_commissions(total_rental_prince, number_of_days)
		commission_price = calculate_commission_price(total_rental_prince)
		insurance_fee = calculate_insurance_fee(commission_price)
		assistance_fee = calculate_assistance_fee(number_of_days)
		drivy_fee = calculate_drivy_fee(commission_price, insurance_fee, assistance_fee)
		return Commission.new(insurance_fee, assistance_fee, drivy_fee)
	end
	
	# Calculate the value reserved for the commissions. It corresponds to 30% from the full price
	def calculate_commission_price(total_rental_prince)
		return total_rental_prince*30/100
	end
	
	# Calculate the insurance fee value. It corresponds to half of the commission reserved value
	def calculate_insurance_fee(commission_price)
		return commission_price/2
	end
	
	# Calculate the assistance feevalue. It corresponds to 1 Euro per day
	def calculate_assistance_fee(number_of_days)
		return number_of_days*100
	end
	
	# Calculate the drivy commission. It corresponds to the commission value deducing the insurance and assistance fee.
	def calculate_drivy_fee(commission_price, insurance_fee, assistance_fee)
		drivy_fee = commission_price - insurance_fee - assistance_fee
		return drivy_fee
	end
	
	# Calculate the options from the rental information
	def calculate_options(number_of_days, has_deductible_reduction)
		options = Hash.new
		options["deductible_reduction"] = has_deductible_reduction ? calculate_deductible_reduction(number_of_days) : 0
		
		return options
	end
	
	# Calculate the deductible_reduction option from the rental information. The driver is charged an additional 4€/day 
	# when she chooses the "deductible reduction" option. Money is represented using cents.
	def calculate_deductible_reduction(number_of_days)
		return number_of_days*4*100
	end
	
	# Calculate the actions for each stake holder
	def calculate_actions(total_rental_prince, commissions, options)
		actions = Array.new
		actions.push(calculate_action_for_driver(total_rental_prince, options))
		actions.push(calculate_action_for_owner(total_rental_prince, commissions))
		actions.push(calculate_action_for_insurance(commissions))
		actions.push(calculate_action_for_assistance(commissions))
		actions.push(calculate_action_for_drivy(commissions, options))
		
		return actions
	end
	
	# The driver must pay the rental price and the (optional) deductible reduction
	def calculate_action_for_driver(total_rental_prince, options)
		action = Hash.new
		action["who"] = "driver"
		action["type"] = "debit"
		action["amount"] = total_rental_prince + options["deductible_reduction"]
		
		return action
	end
	
	# The owner receives the rental price minus the commission
	def calculate_action_for_owner(total_rental_prince, commissions)
		action = Hash.new
		action["who"] = "owner"
		action["type"] = "credit"
		action["amount"] = total_rental_prince - commissions.insurance_fee - commissions.assistance_fee - commissions.drivy_fee
		
		return action
	end
	
	# The insurance receives its part of the commission
	def calculate_action_for_insurance(commissions)
		action = Hash.new
		action["who"] = "insurance"
		action["type"] = "credit"
		action["amount"] = commissions.insurance_fee
		
		return action
	end
	
	# The assistance receives its part of the commission
	def calculate_action_for_assistance(commissions)
		action = Hash.new
		action["who"] = "assistance"
		action["type"] = "credit"
		action["amount"] = commissions.assistance_fee
		
		return action
	end
	
	# Drivy receives its part of the commission, plus the deductible reduction
	def calculate_action_for_drivy(commissions, options)
		action = Hash.new
		action["who"] = "drivy"
		action["type"] = "credit"
		action["amount"] =  commissions.drivy_fee + options["deductible_reduction"]
		
		return action
	end
end