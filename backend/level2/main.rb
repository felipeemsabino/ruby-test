require "json"
require "date"

class RentalCalculator

	#Read the input file and parse the json content
	def read_input_file ()
		#reading the json information file
		begin  
			file = File.read('data.json')
			json_info = JSON.parse(file)
			
			#getting cars and rentals information
			return json_info["cars"], json_info["rentals"] 
		rescue Exception => e  
			puts "Error trying to read the input file!" 
			puts e.message
		end
	end
	
	#Iterate over the rentals and car hash seeking for the rental
	def check_rental_prices()
		#result structures
		rentals_prices_array = Array.new
		cars, rentals = read_input_file()
		rentals.each do |rental|
			cars.each do |car|
				if car["id"] == rental["car_id"] #got the rental and respective car
					# number of rental days
					number_of_days = get_range_days_number(rental["start_date"], rental["end_date"]) 
					
					#calculating prices per day and distance
					price_per_distance = car["price_per_km"] * rental["distance"]
					total_price_with_discount = calculate_price_with_discount(car["price_per_day"], number_of_days) + price_per_distance
					
					#creating structure	for the results
					rental_price = Hash.new
					rental_price["id"] = rental["id"]
					rental_price["price"] = total_price_with_discount
					rentals_prices_array.push(rental_price)
				end
			end
		end
		create_output_file(rentals_prices_array)
	end
	
	# Create final hash and store in the output file
	def create_output_file(rentals_prices_array)
		begin
			rentals_prices_hash = Hash.new
			rentals_prices_hash["rentals"] = rentals_prices_array

			File.open("output1.json","w") do |f|
				f.write(JSON.pretty_generate(rentals_prices_hash))
			end
		rescue Exception => e 
		puts "Error trying to create the output file."
		puts e.message
		end
	end
	
	# calculating number of days in a range
	def get_range_days_number (start_date, end_date)
		start_date = Date.strptime(start_date, '%Y-%m-%d') 
		final_date = Date.strptime(end_date	, '%Y-%m-%d')
		return (start_date .. final_date).count
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
end

#
rental = RentalCalculator.new
rental.read_input_file()
rental.check_rental_prices()