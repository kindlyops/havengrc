Feature: Basic sqitch API interaction with JWT

    Background: Setup environment with JWT Auth
        Given I am a client
        And I add Headers:
            | Prefer        | return=representation |
            | Authorization | Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibWVtYmVyIiwibmFtZSI6IkpvaG4gRG9lIiwiZW1haWwiOiJ1c2VyMUBoYXZlbmdyYy5jb20iLCJhZG1pbiI6ZmFsc2V9.Ex7B1H8L1PWZdS0DK-KPOF8LMUDvQHxZQYnVtcq9eG8 |


    Scenario: Add/update a comment
        When I request to create a comment with:
            | message | string  | "The system must be tested" |
        Then the request is successful and a comment was created
        And print the response
    
    Scenario: Search for all comments
        When I request a list of comments
        Then the request is successful
        And the response is a list of at least 1 comment
