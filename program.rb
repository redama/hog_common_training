class Program

	attr_accessor :criteria
	attr_accessor :count
	attr_accessor :priceLimit

	attr_accessor :uri

	def initialize
		@criteria = "5c"
		@count = 3
		@priceLimit = 200

		@uri = URI('https://www.leboncoin.fr/telephonie/offres/ile_de_france/?f=a&th=1&ps=8&pe=11&q=iphone')

		@selector_prices = "h3.item_price"
		@selector_articles = "section.item_infos"
	end

	def selector_titles
		selector_titles = %Q[h2.item_title:contains("#{@criteria}")]
		return selector_titles
	end

	def display_filtred_elmts_by_name
		parser = HtmlParser.new(@uri)
		parser.query_with_css_selector( self.selector_titles )
		list = parser.get_results

		puts "Les objets qui contiennent (#{criteria}) : "
		if list.length == 0
			puts "Aucun"
		else
			list = list.first(@count)
			list.each do |obj|
				puts obj
			end
		end
	end

	def display_filtred_elmts_by_price
		doc_parser = HtmlParser.new(@uri)
		doc_parser.query_with_css_selector( @selector_articles )

		elmt_parser = HtmlParser.new

		if doc_parser.current_result.respond_to?("each")

			puts "Les objets avec un prix > #{priceLimit} : "

			doc_parser.current_result.each do |obj|
				elmt_parser.current_result = obj
				elmt_parser.query_with_css_selector("h3.item_price", true)
				
				elmt_price = elmt_parser.get_results(true, true)
				
				next if elmt_price.nil? or elmt_price[0].nil?
				elmt_price = elmt_price[0]

				if elmt_price > @priceLimit
					elmt_parser.current_result = obj
					elmt_parser.query_with_css_selector("h2.item_title", true)
					elmt_name = elmt_parser.get_results(false, true)
					puts elmt_name
				end
			end
			
		end
	end

	def display_total_price
		parser = HtmlParser.new(@uri)
		
		total = 0

		parser.query_with_css_selector( @selector_prices )
		list = parser.get_results(true)

		list.each do |obj|
			total += obj
		end

		puts "La somme totale : #{total}"

	end
end