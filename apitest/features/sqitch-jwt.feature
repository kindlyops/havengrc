Feature: Basic sqitch API interaction with JWT

    Background: Setup environment with JWT Auth
        Given I send and accept JSON
        And I sign in to keycloak with "user1@havengrc.com" and "password"
        And I add Headers:
            | Prefer | return=representation             |
        And I wait for 2 seconds


    Scenario: Add/update a comment without ability to spoof the user_email
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested"
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/comments"
        Then the response status should be "201"
        And the JSON response should have "$.user_id" of type string and value "90920d91-3090-4b4a-ae2a-2377cfa06ecd"
        And the JSON response should have "$.user_email" of type string and value "user1@havengrc.com"
        And the JSON response should have "$.message" of type string and value "The system must be tested"

    Scenario: Search for all comments
        When I send a GET request to "http://{buffalo_server}/api/comments"
        Then the response status should be "200"
        And the JSON response root should be array
        And the JSON response should have "$[0].user_id" of type string and value "90920d91-3090-4b4a-ae2a-2377cfa06ecd"
        And the JSON response should have "$[0].user_email" of type string and value "user1@havengrc.com"
        And the JSON response should have "$[0].message" of type string and value "The system must be tested"


    Scenario: Add a comment and try to spoof the author to see failure
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested cause you got hacked",
        "user_email": "hacker@world.com"
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/comments"
        Then the response status should be "400"

    Scenario: Add a comment from a second user
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested"
        }
        """
        And I sign in to keycloak with "test@test.com" and "password"
        And  I send a POST request to "http://{buffalo_server}/api/comments"
        Then the response status should be "201"
        And the JSON response should have "$.user_id" of type string and value "7252c47c-8942-446b-89d4-74e0dcbb2550"
        And the JSON response should have "$.user_email" of type string and value "test@test.com"
        And the JSON response should have "$.message" of type string and value "The system must be tested"

    Scenario: Confirm that I can only see the first users comments
        When I send a GET request to "http://{buffalo_server}/api/comments"
        Then the response status should be "200"
        And the JSON response root should be array
        Then all "user_email" fields should be of type string and value "user1@havengrc.com"

    Scenario: Get an onboarding state
        When I send a GET request to "http://{buffalo_server}/api/onboarding"
        Then the response status should be "200"
        And the JSON response should have "$.status" of type string and value "new"

    Scenario: Confirm you cannot post unknown json keys
        When I set JSON request body to:
        """
        {
        "extra_info": "some extra stuff"
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/onboarding"
        Then the response status should be "400"

    Scenario: Confirm you can post one key
        When I set JSON request body to:
        """
        {
        "status": "testing"
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/onboarding"
        Then the response status should be "200"
        And the JSON response should have "$.status" of type string and value "testing"
        And the JSON response should have "$.downloaded_report" of type boolean and value "false"

    Scenario: Add/update an onboarding state
        When I set JSON request body to:
        """
        {
        "status": "new",
        "downloaded_report": false
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/onboarding"
        Then the response status should be "200"
        And the JSON response should have "$.status" of type string and value "new"
        And the JSON response should have "$.downloaded_report" of type boolean and value "false"