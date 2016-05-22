# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'mongo'
require 'json'
require 'pp'

enable :cross_origin
SERVER = '127.0.0.1'
PORT   = '27017'
db = Mongo::Client.new(["#{SERVER}:#{PORT}"], database: 'web')[:will]

post '/add' do
  cross_origin
  data = JSON.parse(request.body.read)
  key  = {'_id'  => data['char']}
  dt   = {'data' => [data['data']]}

  if db.find(key).count == 0 then db.insert_one(key.merge dt)
  else db.find_one_and_replace(key, (key.merge dt))
  end
  {'status' => 'true'}.to_json
end

post '/trans' do
  cross_origin
  ret   = []
  query = JSON.parse(request.body.read)['query']
  query.split('').each do |char|
    dt = db.find('_id' => char).first or next
    dt = dt['data']
    ret.push(dt[rand(dt.size)])
  end
  ret.to_json
end

