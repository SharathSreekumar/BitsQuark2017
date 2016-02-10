require "base64"

client_id = "V1:ktnhqq42jb128wew:DEVCENTER:EXT" #VjE6a3RuaHFxNDJqYjEyOHdldzpERVZDRU5URVI6RVhU
client_secret = "4I5NbyLe" #NEk1TmJ5TGU=
client_id = Base64.encode64(client_id)
puts client_id
client_secret = Base64.encode64(client_secret)
puts client_secret
final_string = client_id + ":" + client_secret
puts final_string
final_string = Base64.encode64(final_string)
puts final_string

#VmpFNmEzUnVhSEZ4TkRKcVlqRXlPSGRsZHpwRVJWWkRSVTVVUlZJNlJWaFU6TkVrMVRtSjVUR1U9

=begin
require 'oauth'
require 'json'

access_token = "T1RLAQIcT4MC9FDXdjJsd8NZeuNFliMHXRCRbQK6j7gCnt/xHUnIreshAACg4rAuxyaAj9kApEYKPZa006sBD/Xk4WPVM8hAm15qSsU8XTKMirgynzZFS2F6kdZagoxm6zWFQmJqG5GnAOpgZfvGtqY6z0x24e1c0h+gvYe8gOgslXkdvOFETcPSp0FHGFWe2m9qXnqSIXqe7YwQiL1GMzb75VHG+xQxm1dQ5O+JCMTBLkDyFIzIQWU79wrSzZZqnzJxtIZez5ZqmFL/yg**"

HEADER = 'Authorization: '+access_token
=end