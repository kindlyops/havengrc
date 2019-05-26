# uncomment to see debug logs of http traffic
# ENV['cucumber_api_verbose'] = 'true'
require 'cucumber-api'

Before do
  @api_server = ENV['API_SERVER'] || 'localhost:8180'
  @web_server = ENV['WEB_SERVER'] || 'localhost:2015'
end


