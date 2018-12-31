package actions

import (
	"testing"
)

func TestSendSlackNotification(t *testing.T) {
	err := sendSlackNotification("Testing the Slack Notification from go test.")
	if err != nil {
		if err.Error() == "No Slack Webhook found" {
			t.Skip("No SLACK_WEBHOOK environment variable")
		}
		t.Errorf("Failed test because: %s", err.Error())
	}
}
