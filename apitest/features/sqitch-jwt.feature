Feature: Basic sqitch API interaction with JWT

    Background: Setup environment with JWT Auth
        Given I send and accept JSON
        And I sign in to keycloak with "user1@havengrc.com" and "password"
        And I add Headers:
            | Prefer | return=representation             |


    Scenario: Add/update a comment without ability to spoof the user_email
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested"
        }
        """
        And  I send a POST request to "http://{api_server}/comments"
        Then the response status should be "201"
        And the JSON response root should be array
        And the JSON response should have "$[0].user_id" of type string and value "90920d91-3090-4b4a-ae2a-2377cfa06ecd"
        And the JSON response should have "$[0].user_email" of type string and value "user1@havengrc.com"
        And the JSON response should have "$[0].message" of type string and value "The system must be tested"

    Scenario: Search for all comments
        When I send a GET request to "http://{api_server}/comments"
        Then the response status should be "200"
        And the JSON response root should be array
        And the JSON response should have "$[0].user_id" of type string and value "90920d91-3090-4b4a-ae2a-2377cfa06ecd"
        And the JSON response should have "$[0].user_email" of type string and value "user1@havengrc.com"
        And the JSON response should have "$[0].message" of type string and value "The system must be tested"


    Scenario: Add a comment and try to spoof the author to see failure
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested",
        "user_email": "hacker@world.com"
        }
        """
        And  I send a POST request to "http://{api_server}/comments"
        Then the response status should be "400"
