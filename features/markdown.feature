Feature: Markdown API

  Background:
    Given I have "Github::Client::Markdown" instance

  Scenario: Render arbitrary document

    Given I want to render resource
      And I pass the following request options:
        | text         | mode | context               |
        | Hello world  | gfm  | murek/github_api_test |
    When I make request within a cassette named "markdown/render"
    Then the response status should be 200
      And the response type should be HTML
      And the response should not be empty

#   Scenario: Render raw document text/plain
# 
#     Given I want to render_raw resource with the following params:
#         | text             |
#         | Hello cool world |
#     When I make request within a cassette named "markdown/render_raw"
#     Then the response status should be 200
#       And the response type should be HTML
#       And the response should not be empty
