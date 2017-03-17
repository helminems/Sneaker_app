require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'sneakerpimps_app',
}

ActiveRecord::Base.establish_connection(options)
