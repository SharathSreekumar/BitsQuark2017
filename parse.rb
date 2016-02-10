require 'json'

input = "Pakistan"


file = File.read('countries.json')
full_list = JSON.parse(file)

full_list.each do |i|
	if input == i["Name"]
		puts i["Code"]
	end
end



#puts full_list