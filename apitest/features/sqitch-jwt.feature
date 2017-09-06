Feature: Basic sqitch API interaction with JWT

    Background: Setup environment with JWT Auth
        Given I am a client
        And I add Headers:
            | Prefer        | return=representation |
            | Authorization | Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibWVtYmVyIiwibmFtZSI6IkpvaG4gRG9lIiwiZW1haWwiOiJ1c2VyMUBoYXZlbmdyYy5jb20iLCJhZG1pbiI6ZmFsc2V9.Ex7B1H8L1PWZdS0DK-KPOF8LMUDvQHxZQYnVtcq9eG8 |
        # Note that this JWT was created at http://jwt.io/#debugger-io using the payload
        # {
        #     "role": "member",
        #     "name": "John Doe",
        #     "email": "user1@havengrc.com",
        #     "admin": false
        # }
        #
        # And the JWT secret DfWbWFIdCyk4bFZi6iW4Gi3sZtqmmazG2F4PPRqf4Ek= (base64 encoded)
        # this JWT secret was generated for testing purposes using `openssl rand -base64 32`
        # the same JWT secret is specified in postgrest/config so that auth will work.
        # TODO: figure out how to share a secret between keycloak so the Elm UI can authenticate

    Scenario: Add/update a comment
        When I request to create a comment with:
            | message | string  | "The system must be tested" |
        Then the request is successful and a comment was created
        And print the response
    
    Scenario: Search for all comments
        When I request a list of comments
        Then the request is successful
        And the response is a list of at least 1 comment
