require 'sinatra'
require 'json'
require 'net/http'
require 'open-uri'
require 'base64'
require 'httparty'
require 'openssl'
require 'resolv-replace'

get '/' do
	url = 'https://api.test.sabre.com/v1/shop/flights/cheapest/fares/DFW'
	uri = URI(url)
	headers = { "Authorization" => "Bearer T1RLAQIcT4MC9FDXdjJsd8NZeuNFliMHXRCRbQK6j7gCnt/xHUnIreshAACg4rAuxyaAj9kApEYKPZa006sBD/Xk4WPVM8hAm15qSsU8XTKMirgynzZFS2F6kdZagoxm6zWFQmJqG5GnAOpgZfvGtqY6z0x24e1c0h+gvYe8gOgslXkdvOFETcPSp0FHGFWe2m9qXnqSIXqe7YwQiL1GMzb75VHG+xQxm1dQ5O+JCMTBLkDyFIzIQWU79wrSzZZqnzJxtIZez5ZqmFL/yg**"}
	user = HTTParty.get(uri, :headers => headers)
	puts user
end