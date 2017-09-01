Feature: Basic sqitch schema management

    Background: Setup environment
        Given I am a client
        # TODO: set up auth

    Scenario: Add/update a regulation
        Given I add Headers:
            | Prefer | return=representation |
        When I request to create a regulation with:
            | attribute   | type    | value                                        |
            | identifier  | string  | "CFR 21.11 A"                                |
            | uri         | string  | "http://example.org/regulations/cfr/21/11#A" |
            | description | string  | "The system must be tested"                  |
        Then the request is successful and a regulation was created
    
    Scenario: Search for all regulations
        When I request a list of regulations
        Then the request is successful
        And the response is a list of at least 1 regulation
        # And one regulation has the following attributes:
        #     | attribute   | type   | value |
        #     | description | string | "The system must be tested" |

    # Scenario: Search for nonexistent regulation
    #     When I make an untrusted GET request to "/regulation" with parameters
    #     |description|
    #     |nonexisting|
    #     Then the response status code should equal 404
    # Scenario: Add/update a regulation
    #     When I set JSON request body to:
    #         """
    #         {
    #            "identifier": "CFR 21.11 A",
    #            "uri": "http://example.org/regulations/cfr/21/11#A",
    #            "description": "This fake regulation deals with the requirement to test our system"
    #         }
    #         """
    #     And I send a POST request to "http://api/regulation"
    #     Then the response has a list of regulations
    #     And the response has one regulation with attributes:
    #         | attribute  | type   | value                                        |
    #         | uri        | string | "http://example.org/regulations/cfr/21/11#A" |
    #         | identifier | string | "CFR 21.11 A"                                |