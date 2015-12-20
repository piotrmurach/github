Feature: Feeds API

  Background:
    Given I have "Github::Client::Activity::Feeds" instance

  Scenario: List

    Given I want to list resources
    When I make request within a cassette named "activity/feeds/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

#  Scenario: Get
#
#    Given I want to get resource with the following arguments:
#      | name     |
#      | timeline |
#    When I make request within a cassette named "activity/feeds/get_timeline"
#    Then the response status should be 200
#      And the response type should be JSON
#      And the response should not be empty
