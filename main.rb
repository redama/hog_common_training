require_relative 'html_parser.rb'
require_relative 'program.rb'

if __FILE__ == $0

	begin

		program = Program.new
		program.display_filtred_elmts_by_name
		program.display_filtred_elmts_by_price
		program.display_total_price

	rescue Exception => e
		puts "Error #{e.message }"
	end
end