Feature: Basic sqitch access control 

    Background: Setup environment without JWT Auth
        Given I send and accept JSON
        And I add Headers:
            | Prefer | return=representation |
        

    Scenario: Add/update a comment without a JWT to see access denied
        When I set JSON request body to:
        """
        {
        "message": "The system must be tested"
        }
        """
        And  I send a POST request to "http://api:8180/comments"
        Then the response status should be "401"
