require 'sinatra'
require 'json'
require 'net/http'
require 'open-uri'
require 'openssl'
require 'httparty'
require 'resolv-replace'

$ap_input = "BOM"
$theme_input = "shopping"
#$number_of_results = "10"

get '/' do
	url = 'https://api.test.sabre.com/v1/lists/top/destinations?'
	origin_ap = "origin="+ $ap_input		#creates parameter to be appended to URL for origin airport
	td = "&topdestinations=10"
	theme = "&theme=" + $theme_input
	uri = URI(url+origin_ap+td+theme)
	headers = { "Authorization" => "bearer T1RLAQIcT4MC9FDXdjJsd8NZeuNFliMHXRCRbQK6j7gCnt/xHUnIreshAACg4rAuxyaAj9kApEYKPZa006sBD/Xk4WPVM8hAm15qSsU8XTKMirgynzZFS2F6kdZagoxm6zWFQmJqG5GnAOpgZfvGtqY6z0x24e1c0h+gvYe8gOgslXkdvOFETcPSp0FHGFWe2m9qXnqSIXqe7YwQiL1GMzb75VHG+xQxm1dQ5O+JCMTBLkDyFIzIQWU79wrSzZZqnzJxtIZez5ZqmFL/yg**"}
	user = HTTParty.get(uri, :headers => headers)
	i = JSON.parse(user.to_json)

	# puts i["Destinations"][1].class
	# puts i["Destinations"][1]["Destination"]["CityName"]
	# puts i["Destinations"][1]["Destination"].class

	for z in 0..9
		if i["Destinations"][z]["Destination"]["CityName"] == nil
			puts i["Destinations"][z]["Destination"]["CountryName"]
		else	
			puts i["Destinations"][z]["Destination"]["CityName"]
		end
	end
	#puts parsed_value
end