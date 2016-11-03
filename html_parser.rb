require 'open-uri'
require 'nokogiri'

class HtmlParser

	attr_reader :uri
	attr_accessor :current_result

	def initialize(uri = nil)

		@current_result = nil
		@uri = uri

		unless uri.nil?
			@doc = Nokogiri::HTML(open(uri))
		end
	end

	# Get integer from DOM node, and strip white spaces, and the currency
	def self.get_price_from_html_elmt(html_elmt)
		if html_elmt.nil?
			return 0
		end
		return Integer(html_elmt.content.strip[0...-2])
	end

	# Get text from DOM node, and strip white spaces
	def self.get_text_from_html_elmt(html_elmt)
		if html_elmt.nil?
			return ''
		end
		return html_elmt.content.strip
	end

	# Select DOM elements with a css selector
	# Allow to search in the whole doc, or only from the last result
	def query_with_css_selector(css_selector, from_last_result = false, store = true)
		res = nil
		src = nil

		if from_last_result
			src = @current_result
		else
			src = @doc
		end

		if src.respond_to?("css")
			res = src.css(css_selector)
		end
		
		if store
			@current_result = res
		end

		return res
	end

	# Get values from the stored DOM elements
	# Can parse results to integers, and can return only the first element
	def get_results(as_integer = false, only_first = false)
		res = Array.new

		if @current_result.respond_to?("each")
			current_result.each do |obj|
				if as_integer
					res.push( HtmlParser::get_price_from_html_elmt(obj) )
				else
					res.push( HtmlParser::get_text_from_html_elmt(obj) )
				end
				
				break if only_first
			end
		else
			puts "current_result not set"
		end

		return res
	end
end