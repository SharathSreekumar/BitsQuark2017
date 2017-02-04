require 'sinatra'
require 'json'
require 'net/http'
require 'open-uri'
#require 'openssl'
require 'httparty'
require 'resolv-replace'

AIRPORTS = {
	'IXA'=>'Agartala,Singerbhil Airport (IXA)',
	'AGX'=>'Agatti Island,Agatti Island Airport (AGX)',
	'AGR'=>'Agra,Kheria Airport (AGR)',
	'AMD'=>'Ahmedabad,Ahmedabad Airport (AMD)',
	'AJL'=>'Aizawl,Aizawl Airport (AJL)',
	'AKD'=>'Akola,Akola Airport (AKD)',
	'IXD'=>'Allahabad,Bamrauli Airport (IXD)',
	'IXV'=>'Along,Along Airport (IXV)',
	'ATQ'=>'Amritsar,Raja Sansi Airport (ATQ)',
	'IXU'=>'Aurangabad,Chikkalthana Airport (IXU)',
	'IXB'=>'Bagdogra,Bagdogra Airport (IXB)',
	'RGH'=>'Balurghat,Balurghat Airport (RGH)',
	'BLR'=>'Bangalore,Hindustan Airport (BLR)',
	'BEK'=>'Bareli,Bareli Airport (BEK)',
	'IXG'=>'Belgaum,Sambre Airport (IXG)',
	'BEP'=>'Bellary,Bellary Airport (BEP)',
	'BUP'=>'Bhatinda,Bhatinda Airport (BUP)',
	'BHU'=>'Bhavnagar,Bhavnagar Airport (BHU)',
	'BHO'=>'Bhopal,Bhopal Airport (BHO)',
	'BBI'=>'Bhubaneswar,Bhubaneswar Airport (BBI)',
	'BHJ'=>'Bhuj,Rudra Mata Airport (BHJ)',
	'BKB'=>'Bikaner,Bikaner Airport (BKB)',
	'PAB'=>'Bilaspur,Bilaspur Airport (PAB)',
	'BOM'=>'Bombay (Mumbai),Chhatrapati Shivaji Airport (BOM)',
	'CCU'=>'Calcutta (Kolkata),Netaji Subhas Chandra Airport (CCU)',
	'CBD'=>'Car Nicobar,Car Nicobar Airport (CBD)',
	'IXC'=>'Chandigarh,Chandigarh Airport (IXC)',
	'CJB'=>'Coimbatore,Peelamedu Airport (CJB)',
	'COH'=>'Cooch Behar,Cooch Behar Airport (COH)',
	'CDP'=>'Cuddapah,Cuddapah Airport (CDP)',
	'NMB'=>'Daman,Daman Airport (NMB)',
	'DAE'=>'Daparizo,Daparizo Airport (DAE)',
	'DAI'=>'Darjeeling,Darjeeling Airport (DAI)',
	'DED'=>'Dehra Dun,Dehra Dun Airport (DED)',
	'DEL'=>'Delhi,Indira Gandhi International Airport (DEL)',
	'DEP'=>'Deparizo,Deparizo Airport (DEP)',
	'DBD'=>'Dhanbad,Dhanbad Airport (DBD)',
	'DHM'=>'Dharamsala,Gaggal Airport (DHM)',
	'DIB'=>'Dibrugarh,Chabua Airport (DIB)',
	'DMU'=>'Dimapur,Dimapur Airport (DMU)',
	'DIU'=>'Diu,Diu Airport (DIU)',
	'GAY'=>'Gaya,Gaya Airport (GAY)',
	'GOI'=>'Goa,Dabolim Airport (GOI)',
	'GOP'=>'Gorakhpur,Gorakhpur Airport (GOP)',
	'GUX'=>'Guna,Guna Airport (GUX)',
	'GAU'=>'Guwahati,Borjhar Airport (GAU)',
	'GWL'=>'Gwalior,Gwalior Airport (GWL)',
	'HSS'=>'Hissar,Hissar Airport (HSS)',
	'HBX'=>'Hubli,Hubli Airport (HBX)',
	'HYD'=>'Hyderabad,Begumpet Airport (HYD)',
	'IMF'=>'Imphal,Municipal Airport (IMF)',
	'IDR'=>'Indore,Indore Airport (IDR)',
	'JLR'=>'Jabalpur,Jabalpur Airport (JLR)',
	'JGB'=>'Jagdalpur,Jagdalpur Airport (JGB)',
	'JAI'=>'Jaipur,Sanganeer Airport (JAI)',
	'JSA'=>'Jaisalmer,Jaisalmer Airport (JSA)',
	'IXJ'=>'Jammu,Satwari Airport (IXJ)',
	'JGA'=>'Jamnagar,Govardhanpur Airport (JGA)',
	'IXW'=>'Jamshedpur,Sonari Airport (IXW)',
	'PYB'=>'Jeypore,Jeypore Airport (PYB)',
	'JDH'=>'Jodhpur,Jodhpur Airport (JDH)',
	'JRH'=>'Jorhat,Rowriah Airport (JRH)',
	'IXH'=>'Kailashahar,Kailashahar Airport (IXH)',
	'IXQ'=>'Kamalpur,Kamalpur Airport (IXQ)',
	'IXY'=>'Kandla,Kandla Airport (IXY)',
	'KNU'=>'Kanpur,Kanpur Airport (KNU)',
	'IXK'=>'Keshod,Keshod Airport (IXK)',
	'HJR'=>'Khajuraho,Khajuraho Airport (HJR)',
	'IXN'=>'Khowai,Khowai Airport (IXN)',
	'COK'=>'Kochi,Kochi Airport (COK)',
	'KLH'=>'Kolhapur,Kolhapur Airport (KLH)',
	'KTU'=>'Kota,Kota Airport (KTU)',
	'CCJ'=>'Kozhikode,Calicut International Airport (CCJ)',
	'KUU'=>'Kulu,Bhuntar Airport (KUU)',
	'IXL'=>'Leh,Leh Airport (IXL)',
	'IXI'=>'Lilabari,Lilabari Airport (IXI)',
	'LKO'=>'Lucknow,Amausi Airport (LKO)',
	'LUH'=>'Ludhiana,Ludhiana Airport (LUH)',
	'MAA'=>'Madras (Chennai),Chennai Airport (MAA)',
	'IXM'=>'Madurai,Madurai Airport (IXM)',
	'LDA'=>'Malda,Malda Airport (LDA)',
	'IXE'=>'Mangalore,Bajpe Airport (IXE)',
	'MOH'=>'Mohanbari,Mohanbari Airport (MOH)',
	'MZA'=>'Muzaffarnagar,Muzaffarnagar Airport (MZA)',
	'MZU'=>'Muzaffarpur,Muzaffarpur Airport (MZU)',
	'MYQ'=>'Mysore,Mysore Airport (MYQ)',
	'NAG'=>'Nagpur,Sonegaon Airport (NAG)',
	'NDC'=>'Nanded,Nanded Airport (NDC)',
	'ISK'=>'Nasik,Gandhinagar Airport (ISK)',
	'NVY'=>'Neyveli,Neyveli Airport (NVY)',
	'OMN'=>'Osmanabad,Osmanabad Airport (OMN)',
	'PGH'=>'Pantnagar,Pantnagar Airport (PGH)',
	'IXT'=>'Pasighat,Pasighat Airport (IXT)',
	'IXP'=>'Pathankot,Pathankot Airport (IXP)',
	'PAT'=>'Patna,Patna Airport (PAT)',
	'PNY'=>'Pondicherry,Pondicherry Airport (PNY)',
	'PBD'=>'Porbandar,Porbandar Airport (PBD)',
	'IXZ'=>'Port Blair,Port Blair Airport (IXZ)',
	'PNQ'=>'Pune,Lohegaon Airport (PNQ)',
	'PUT'=>'Puttaparthi,Puttaprathe Airport (PUT)',
	'RPR'=>'Raipur,Raipur Airport (RPR)',
	'RJA'=>'Rajahmundry,Rajahmundry Airport (RJA)',
	'RAJ'=>'Rajkot,Civil Airport (RAJ)',
	'RJI'=>'Rajouri,Rajouri Airport (RJI)',
	'RMD'=>'Ramagundam,Ramagundam Airport (RMD)',
	'IXR'=>'Ranchi,Ranchi Airport (IXR)',
	'RTC'=>'Ratnagiri,Ratnagiri Airport (RTC)',
	'REW'=>'Rewa,Rewa Airport (REW)',
	'RRK'=>'Rourkela,Rourkela Airport (RRK)',
	'RUP'=>'Rupsi,Rupsi Airport (RUP)',
	'SXV'=>'Salem,Salem Airport (SXV)',
	'TNI'=>'Satna,Satna Airport (TNI)',
	'SHL'=>'Shillong,Shillong Airport (SHL)',
	'SSE'=>'Sholapur,Sholapur Airport (SSE)',
	'IXS'=>'Silchar,Kumbhirgram Airport (IXS)',
	'SLV'=>'Simla,Simla Airport (SLV)',
	'SXR'=>'Srinagar,Srinagar Airport (SXR)',
	'STV'=>'Surat,Surat Airport (STV)',
	'TEZ'=>'Tezpur,Salonibari Airport (TEZ)',
	'TEI'=>'Tezu,Tezu Airport (TEI)',
	'TJV'=>'Thanjavur,Thanjavur Airport (TJV)',
	'TRV'=>'Thiruvananthapuram,Thiruvananthapuram International Airport (TRV)',
	'TRZ'=>'Tiruchirapally,Civil Airport (TRZ)',
	'TIR'=>'Tirupati,Tirupati Airport (TIR)',
	'TCR'=>'Tuticorin,Tuticorin Airport (TCR)',
	'UDR'=>'Udaipur,Dabok Airport (UDR)',
	'BDQ'=>'Vadodara,Vadodara Airport (BDQ)',
	'VNS'=>'Varanasi,Varanasi Airport (VNS)',
	'VGA'=>'Vijayawada,Vijayawada Airport (VGA)',
	'VTZ'=>'Visakhapatnam,Visakhapatnam Airport (VTZ)',
	'WGC'=>'Warangal,Warangal Airport (WGC)'
}

$url_domain = 'https://api.test.sabre.com'
$auth_data_file = 'json/auth_data.json'
$auth_api_file = 'json/auth_bits.json'
$authorization = "bearer T1RLAQJ0MqUAAJ39yhTrBCImMIe4lYjt1xC7C62diUkS+27XIJmxigjgAADAhAM5dg+n3zlrP0/hwwN/yQIqnR5lsvggY+kYELKD4n7hAYZ4xF+FJrOQl7bX+9MJVMMZbt4zvPWPRaQssmt2aWfEgM2PrCDYpfbeaCrKNWB4O8xsDXIfBIW3f46KC/skpBki5wuTDKBtrzGADXW/Ydk6lOfvZEcBiwCdBhVC8TkSQex6QGEhi1/HMj+aF0K75zMljm7rNsbLD+a11zju66g7YKcWEYtNxgYE60UMhCZELxZ+LZlqTIfCxOZnT9y+"
#$airport_filepath = 'json/airports.json'
$india_airports = 'json/indian_airports.json'
$country_filepath = 'json/countries.json' # Location of the countries file
$theme_filepath = 'json/themes.json' # Location of the themes file
$ap_input = "BOM"
$theme_input = "shopping"
#$number_of_results = "10"

get '/' do
	@data = Hash.new
	@data = AIRPORTS
	#@data = File.read($airport_filepath)

	destinatn = File.read($country_filepath)
	@dataD = JSON.parse(destinatn)

	theme = File.read($theme_filepath)
	@dataT = JSON.parse(theme)
	@checkDest = 0
	@costDest = 0
	erb :index
	#puts parsed_value
end

post '/' do
	#puts "inside post"
	@searchBox = params[:Source]
	@themeBox = params[:Theme]
	puts @searchBox
	url = $url_domain + '/v1/lists/top/destinations?'
	origin_ap = "origin="+ @searchBox		#creates parameter to be appended to URL for origin airport
	td = "&topdestinations=10"
	theme = "&theme=" + @themeBox#$theme_input
	uri = URI(url+origin_ap+td+theme)
	#puts url+origin_ap+td+theme
	headers = { "Authorization" => $authorization}
	user = HTTParty.get(uri, :headers => headers)
	i = JSON.parse(user.to_json)
	puts i.key?("Destinations")
	# puts i["Destinations"][1].class
	# puts i["Destinations"][1]["Destination"]["CityName"]
	# puts i["Destinations"][1]["Destination"].class

	# for z in 0..9
	# 	if i["Destinations"][z]["Destination"]["CityName"] == nil
	# 		puts i["Destinations"][z]["Destination"]["CountryName"]
	# 	else
	# 		puts i["Destinations"][z]["Destination"]["CityName"]
	# 	end
	# end

	@data = Hash.new
	@data = AIRPORTS
	#@data = File.read($airport_filepath)

	theme = File.read($theme_filepath)
	@dataT = JSON.parse(theme)
	@costDest = 0
	if i.key?("Destinations")
		@dataD = i["Destinations"]
		@checkDest = 1
	else
		destinatn = File.read($country_filepath)
		@dataD = JSON.parse(destinatn)
		@checkDest = 0
	end
	erb :index
end

get '/cost' do
	costBox = params[:Direction]

	@data = Hash.new
	@data = AIRPORTS
	#@data = File.read($airport_filepath)

	destinatn = File.read($country_filepath)
	@dataD = JSON.parse(destinatn)

	theme = File.read($theme_filepath)
	@dataT = JSON.parse(theme)
	@checkDest = 0
	@costDest = 0

	url = $url_domain + '/v1/shop/flights/cheapest/fares/'+ costBox
	uri = URI(url)
	headers = { "Authorization" => "Bearer T1RLAQIcT4MC9FDXdjJsd8NZeuNFliMHXRCRbQK6j7gCnt/xHUnIreshAACg4rAuxyaAj9kApEYKPZa006sBD/Xk4WPVM8hAm15qSsU8XTKMirgynzZFS2F6kdZagoxm6zWFQmJqG5GnAOpgZfvGtqY6z0x24e1c0h+gvYe8gOgslXkdvOFETcPSp0FHGFWe2m9qXnqSIXqe7YwQiL1GMzb75VHG+xQxm1dQ5O+JCMTBLkDyFIzIQWU79wrSzZZqnzJxtIZez5ZqmFL/yg**"}
	userC = HTTParty.get(uri, :headers => headers)
	j = JSON.parse(userC.to_json)
	@costDest = 1
	@dataC = j["FareInfo"]
	erb :index
end


get '/v2/api/top-destinations' do # APi to get top destinations
	@searchBox = params[:source]
	@themeBox = params[:theme]
	#puts @searchBox
	url = $url_domain + '/v1/lists/top/destinations?'
	origin_ap = "origin="+ @searchBox		#creates parameter to be appended to URL for origin airport
	td = "&topdestinations=10"
	theme = "&theme=" + @themeBox#$theme_input
	uri = URI(url+origin_ap+td+theme)
	#puts url+origin_ap+td+theme
	headers = { "Authorization" => $authorization}
	destination = HTTParty.get(uri, :headers => headers)
	i = JSON.parse(destination.to_json)

	if i.key?("Destinations")
		return destination.to_json#render json: destination.to_json
	else
		msg = { :status => "400", :message => "Failed"}
		return msg.to_json#render :json => msg
	end
end

get '/v2/api/travel-themes' do ## API to get the Top Travel Themes
	url = $url_domain + '/v1/lists/supported/shop/themes/'
	uri = URI(url)
	headers = { "Authorization" => $authorization}
	themes = HTTParty.get(uri, :headers => headers)
	i = JSON.parse(themes.to_json)
	if i.key?("Themes")
		return themes.to_json
	else
		msg = { :status => "400", :message => "Failed"}
		return msg.to_json
	end
end

get '/v2/api/countries-list' do # retrieves a list of origin and destination countries
	url = $url_domain + '/v1/lists/supported/countries?'
	pointofsalecountry = 'pointofsalecountry=' + params[:countrycode]
	uri = URI(url + pointofsalecountry)
	headers = { "Authorization" => $authorization }
	country_list = HTTParty.get(uri, :headers => headers)
	i = JSON.parse(country_list.to_json)
	return country_list.to_json
end

get '/v2/api/airports' do
		airport = File.read($india_airports)
		return airport
end

get '/v2/api/auth' do ## API to generate new Access_Token
	require "base64" ## This dependency is added here as it is not needed in any other function

	user_detail = File.read($auth_data_file)
	@details = JSON.parse(user_detail)
	client_id = Base64.encode64(@details[0]['client_id'])
	client_secret = Base64.encode64(@details[0]['client_secret'])

	auth_access_key = Base64.encode64(client_id + ':' + client_secret) # Base64(Base64(client_id) + ':' + Base64(client_secret))

	url = $url_domain + '/v2/auth/token'
	uri = URI(url)
	headers = {"Authorization" => "Basic ", "Content-Type" => "application/x-www-form-urlencoded", "Accept" => "*/*"}
	body = {"grant_type" => "client_credentials"}.to_json
	access_permission = HTTParty(uri, :headers => headers, :body => body)
	if access_permission.key?("access_token") ##Checks if the exist in the data received
		File.write($auth_api_file, access_permission) ## Access_token exist, then store the new token
		puts "wrote"
	else ## Continue with the old token
		access_permission = File.read($auth_api_file)
		access_permission = JSON.parse(access_permission)
	end

	$authorization = access_permission['token_type'] + ' ' + access_permission["access_token"] ## Assign the new/old API auth to the Global variable
end
