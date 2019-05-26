require 'cucumber-api/response'
require 'rest-client'
require 'json'
require 'jsonpath'
require 'minitest'

Given(/^I sign in to keycloak with "([^"]*)" and "([^"]*)"$/) do |username, password|
  realm = 'havendev'
  auth_server = ENV['AUTH_SERVER'] || 'dev.havengrc.com'
  request_url = "http://#{auth_server}/auth/realms/#{realm}/protocol/openid-connect/token"
  body = {
    'grant_type' => 'password',
    'client_id'  => realm,
    'username'   => username,
    'password'   => password
  }
  headers = {}
  response = RestClient.post request_url, body, headers
  access_token = JSON.parse(response)["access_token"]
  @headers = {} if @headers.nil?
  @headers['Authorization'] = "Bearer #{access_token}"
end

Given(/^I wait for (\d+) seconds?$/) do |n|
  sleep(n.to_i)
end

Then(/^all "([^"]*)" fields should be of type (numeric|string|boolean|numeric_string) and value "([^"]*)"$/) do |field, type, value|
  raise 'No response found.' if @response.nil?
  json = JSON.parse @response.body
  fields = JsonPath.new("$..#{field}").on(json)
  # puts "we got #{fields.length} fields back"
  # puts fields
  fields.each do |f|
    case type
    when 'numeric'
      assert f.is_a? Numeric
    when 'array'
      assert f.is_a? Array
    when 'string'
      assert f.is_a? String
    when 'boolean'
      assert !!f == f
    when 'numeric_string'
      assertf.is_a?(Numeric) or f.is_a?(String)
    when 'object'
      assert f.is_a? Hash
    else
      raise %/Invalid expected type '#{type}'/
    end
    assert_equal value, f
  end

end
