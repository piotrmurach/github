Feature: Notifications API

  Background:
    Given I have "Github::Client::Activity::Notifications" instance

  Scenario: List

    Given I want to list resources
      And I pass the following request options:
        | user   | repo          |
        | wycats | handlebars.js |
    When I make request within a cassette named "activity/notifications/list_user"
    Then the response status should be 200
      And the response type should be JSON
      And the response should be empty
