Feature: Basic sqitch access control 

    Background: Setup environment without JWT Auth
        Given I am a client
        And I add Headers:
            | Prefer | return=representation |
        

    Scenario: Add/update a comment without a JWT to see access denied
        When I request to create a comment with:
            | message | string  | "The system must be tested" |
        Then the request fails because we are unauthorized
