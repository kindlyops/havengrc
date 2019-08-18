# uncomment to see debug logs of http traffic
# ENV['cucumber_api_verbose'] = 'true'
require 'cucumber-api'

Before do
  @buffalo_server = ENV['BUFFALO_SERVER'] || 'localhost:3000'
end


