require 'mongo_beautiful_logger'

# MongoDB Driver:
Mongo::Logger.logger = MongoBeautifulLogger.new($stdout)

# Mongoid ODM:
Mongoid.logger = MongoBeautifulLogger.new($stdout)
