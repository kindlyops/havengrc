require 'cucumber-api/response'
require 'rest-client'

Given(/^I sign in to keycloak with "([^"]*)" and "([^"]*)"$/) do |username, password|
  realm = 'havendev'
  auth_server = ENV['AUTH_SERVER'] || 'localhost:8080'
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
