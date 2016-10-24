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
				
					#calculating number of days
					start_date = Date.strptime(rental["start_date"], '%Y-%m-%d') 
					final_date = Date.strptime(rental["end_date"], '%Y-%m-%d')
					number_of_days = (start_date .. final_date).count
					
					#calculating prices per day and distance
					price_for_days = car["price_per_day"] * number_of_days
					price_for_distance = car["price_per_km"] * rental["distance"]
					
					#creating structure	for the results
					rental_price = Hash.new
					rental_price["id"] = rental["id"]
					rental_price["price"] = price_for_days + price_for_distance
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
end

#
rental = RentalCalculator.new
rental.read_input_file()
rental.check_rental_prices()