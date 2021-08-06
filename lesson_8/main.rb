require_relative './modules/railway_helpers'
Dir["./interface/*.rb"].each { |file| require file }

TextInterface.run!
