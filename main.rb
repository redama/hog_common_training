require 'open-uri'
require 'nokogiri'

# Script's settings
criteria = "5c"
selectorTitles = %Q[h2.item_title:contains("#{criteria}")]
selectorPrices = "h3.item_price"
selectorArticles = "section.item_infos"

count = 2
priceLimit = 200

uri = URI('https://www.leboncoin.fr/telephonie/offres/ile_de_france/?f=a&th=1&ps=8&pe=11&q=iphone')

def get_price_from__html_elmt(html_elmt)
	if html_elmt.nil?
		return 0
	end
	return Integer(html_elmt.content.strip[0...-2])
end

if __FILE__ == $0

	begin
		# Open URL
		@doc = Nokogiri::HTML(open(uri))

		puts "Get result with success"

		# Get DOM elements
		resCriteria = @doc.css(selectorTitles)
		resAllPrices = @doc.css(selectorPrices)
		resAll = @doc.css(selectorArticles)

		# Display results
		if resCriteria.respond_to?("each")
			puts "Les objets qui contiennent (#{criteria}) : "
			if resCriteria.length == 0
				puts "Aucun"
			else
				resCriteria = resCriteria.first(count)
				resCriteria.each do |obj|
					next if obj.nil?
					puts obj.content.strip
				end
			end
		end

		# Evaluate total
		total = 0
		onePrice = 0
		if resAllPrices.respond_to?("each")
			resAllPrices.each do |obj|
				onePrice = get_price_from__html_elmt(obj)
				total += onePrice
			end
		end
		puts "La somme totale : #{total}"

		# Filter items by price
		if resAll.respond_to?("each")
			puts "Les objets avec un prix > #{priceLimit} : "
			resAll.each do |obj|
				childrens = obj.children
				onePrice = get_price_from__html_elmt( childrens.css("h3.item_price").first() )
				if onePrice > priceLimit
					puts childrens.css("h2.item_title").first().content.strip
				end
			end
		end

	rescue Exception => e
		puts "Error #{e.message }"
	end
end
