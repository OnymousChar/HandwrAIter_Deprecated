require 'rest-client'

HOST   = '52.193.93.208'
#PORT   = 4567
PORT   = 9292
SERVER = "http://#{HOST}:#{PORT}"

query = {'query' => 'abab'}.to_json
da = {'char' => 'a', 'data' => [
  'a1',
  'a2',
  'a3'
]}.to_json

db = {'char' => 'b', 'data' => [
  'b1',
  'b2',
  'b3'
]}.to_json

p RestClient.post(
  "#{SERVER}/add",
  da,
  :content_type => :json,
  :accept => :json
)

p RestClient.post(
  "#{SERVER}/add",
  db,
  :content_type => :json,
  :accept => :json
)

p RestClient.post(
  "#{SERVER}/trans",
  query,
  :content_type => :json,
  :accept => :json
)

