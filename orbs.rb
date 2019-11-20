require "sinatra"
require 'sinatra/json'
require "sinatra/reloader" if development?
require "sequel"
require_relative "db.rb"


DB = Sequel.connect(adapter: 'mysql2', host: HOST, database: DBNAME, user: USERNAME, password: PASSWORD)
get '/' do
    DB.fetch("SELECT name,inet_ntoa(ip) as ip,water_uuid, elec_uuid, elec_rvid, water_rvid, relative_value FROM orbs o inner join relative_values rv on o.water_rvid=rv.id").map do |row|
      content_type :json
      output = {
        :name=>row[:name],
        :ip=>row[:ip],
        :water_uuid=>row[:water_uuid],
        :elec_uuid=>row[:elec_uuid],
        :elec_rvid=>row[:elec_rvid],
        :water_rvid=>row[:water_rvid],
        :relative_value=>row[:relative_value]
      }
      output.to_json
    end
end
