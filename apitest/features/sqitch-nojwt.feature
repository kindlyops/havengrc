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
        And  I send a POST request to "http://{api_server}/comments"
        Then the response status should be "401"

    Scenario: Get likert questions
        When I send a GET request to "http://{api_server}/likert_questions"
        Then the response status should be "200"
        And the JSON response root should be array
	And the JSON response should have "$[0].title" of type string and value "Security Value of Failure"

    Scenario: Delete likert questions
        When I send a DELETE request to "http://{api_server}/likert_questions"
        Then the response status should be "401"

    Scenario: Add/update a question without a JWT to see access denied
        When I set JSON request body to:
        """
	{
	"uuid":"fakeuuid",
	"created_at":"2018-07-31T16:24:51.152842+00:00",
	"survey_id":"somesurveyID",
	"choice_group_id":"somegroupid",
	"order_number":3,
	"title":"newgroup"
	}
        """
        And  I send a POST request to "http://{api_server}/likert_questions"
        Then the response status should be "401"

    Scenario: Get ipsative surveys
        When I send a GET request to "http://{api_server}/ipsative_surveys"
        Then the response status should be "200"
        And the JSON response root should be array
	And the JSON response should have "$[0].author" of type string and value "Lance Hayden"

    Scenario: Delete ipsative surveys
        When I send a DELETE request to "http://{api_server}/ipsative_surveys"
        Then the response status should be "401"

    Scenario: Save registration with invalid email address
        When I set JSON request body to:
        """
        {
        "email": "_@_",
        "survey_results": []
        }
        """
        And  I send a POST request to "http://{buffalo_server}/api/registration_funnel"
        Then the response status should be "422"