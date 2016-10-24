require "./rentals_file_reader"
require "./rental_price_calculator"

rentalFileReader = RentalsFileReader.new
rentalFileReader.read_input_file # reading input file

priceCalculator = RentalPriceCalculator.new(rentalFileReader.cars, rentalFileReader.rentals, rentalFileReader.rentals_modifications) # creating car and rental entities
rentals_information = priceCalculator.calculate_rental_price # calculating the rental prices
rentalFileReader.create_output_file(rentals_information) # creating output with results