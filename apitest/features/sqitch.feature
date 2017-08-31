Feature: Basic sqitch schema management

    Background: Setup environment
        Given I am a client
        # TODO: set up auth

    Scenario: Search for all regulations
        When I request a list of regulations
        Then the request is successful
        And the response is a list of at least 1 regulation
        And one response has the following attributes:
            | attribute | type    | value |
            | id        | numeric | 1     |

    # Scenario: Search for nonexistent regulation
    #     When I make an untrusted GET request to "/regulation" with parameters
    #     |description|
    #     |nonexisting|
    #     Then the response status code should equal 404