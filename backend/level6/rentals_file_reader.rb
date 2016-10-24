require "json"
require "date"
require "./rental_price_calculator"

class RentalsFileReader
	attr_reader	:cars
	attr_reader	:rentals
	attr_reader	:rentals_modifications
	
	#Read the input file and parse the json content
	def read_input_file
		begin  
			file = File.read('data.json')
			json_info = JSON.parse(file)
			
			#getting cars and rentals information
			@cars = json_info["cars"]
			@rentals = json_info["rentals"]
			@rentals_modifications = json_info["rental_modifications"]
		rescue Exception => e  
			puts "Error trying to read the input file!" 
			puts e.message
		end
	end
	
	#Create the output file and write the content
	def create_output_file(rentals)
		begin
			rentals_prices_hash = Hash.new
			rentals_prices_hash["rental_modifications"] = rentals

			File.open("output1.json","w") do |f|
				f.write(JSON.pretty_generate(rentals_prices_hash))
			end
		rescue Exception => e 
			puts "Error trying to create the output file."
			puts e.message
		end
	end
end