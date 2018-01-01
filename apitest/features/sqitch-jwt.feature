Feature: Basic sqitch API interaction with JWT

    Background: Setup environment with JWT Auth
        Given I am a client
        And I sign in to keycloak with "user1@havengrc.com" and "password"
        And I add Headers:
            | Prefer | return=representation             |


    Scenario: Add/update a comment without ability to spoof the user_email
        When I request to create a comment with:
            | attribute | type   | value                     |
            | message   | string | The system must be tested |
        Then the request is successful and a comment was created
        Then the response is a list of 1 comment
        Then one item has the following attributes:
            | attribute  | type     | value                                |
            | user_email | string   | user1@havengrc.com                   |
            | user_id    | string   | 90920d91-3090-4b4a-ae2a-2377cfa06ecd |
            | message    | string   | The system must be tested            |


    Scenario: Search for all comments
        When I request a list of comments
        Then the request is successful
        And the response is a list of at least 1 comment

    Scenario: Add a comment and try to spoof the author to see failure
        When I request to create a comment with:
            | attribute  | type    | value                     |
            | message    | string  | The system must be tested |
            | user_email | string  | hacker@world.com          |
        Then the request failed because it was invalid
