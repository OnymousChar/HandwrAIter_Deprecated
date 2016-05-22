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
  dt   = {'data' => data['data']}
  if db.find(key).count == 0 then db.insert_one(key.merge dt)
  else db.find_one_and_replace(key, dt)
  end
  {'status' => 'true'}.to_json
end

post '/add_one' do
  cross_origin
  data = JSON.parse(request.body.read)

  key = data['char']
  if File.exist?(key)
    File.read(key) do |f|
      d = Marshal.load(f.read).push(data['data'])
      File.write(key,'w'){ |f| f.write(Marshal.dump(d)) }
    end
  else
    File.write(key,'w'){ |f| f.write(Marshal.dump([data['data']])) }
  end
  {'status' => 'true'}.to_json
end

post '/del' do
  cross_origin
  query = JSON.parse(request.body.read)['query']
  db.find_one_and_delete({'_id' => query})
  {'status' => 'true'}.to_json
end

post '/trans' do
  cross_origin
  ret   = []
  query = JSON.parse(request.body.read)['query']
  query.split('').each do |char|
    File.exist?(query) or next
    dt = File.open(query){ |f| Marshal.load(f.read).push(data['data']) }
    ret.push(dt[rand(dt.size)].gsub(/\n/,''))
  end
  ret.to_json
end

