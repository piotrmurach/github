Feature: Contents API

  Background:
    Given I have "Github::Client::Repos::Contents" instance

  Scenario: Readme

    Given I want readme resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    When I make request within a cassette named "repos/contents/readme"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Get file contents

    Given I want get resource with the following params:
      | user         | repo   | path      |
      | peter-murach | github | README.md |
    When I make request within a cassette named "repos/contents/get"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Create a file

    Given I want create resource with the following params:
      | user  | repo            | path     |
      | murek | github_api_test | hello_world.rb |
      And I pass the following request options:
        | path      | content     | message        |
        | hello_world.rb | puts 'ruby' | Initial commit |
    When I make request within a cassette named "repos/contents/create"
    Then the response status should be 201
      And the response type should be JSON
      And the response should not be empty

  Scenario: Update a file

    Given I want create resource with the following params:
      | user  | repo            | path           |
      | murek | github_api_test | hello_world.rb |
      And I pass the following request options:
        | path           | content           | message       | sha                                      |
        | hello_world.rb | puts 'hello ruby' | Update commit | 25b0bef9e404bd2e3233de26b7ef8cbd86d0e913 |
    When I make request within a cassette named "repos/contents/update"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Delete a file

    Given I want delete resource with the following params:
      | user  | repo            | path           |
      | murek | github_api_test | hello_world.rb |
      And I pass the following request options:
        | path           | message                    | sha                                      |
        | hello_world.rb | Delete hello_world.rb file | 9ed559bc7c227577c734a1d71e84646058c28ab7 |
    When I make request within a cassette named "repos/contents/delete"
    Then the response status should be 200
      And the response type should be JSON
      And the response should not be empty

  Scenario: Archive

    Given I want archive resource with the following params:
      | user         | repo   |
      | peter-murach | github |
    And I pass the following request options:
      | archive_format | ref    |
      | tarball        | master |
    When I make request within a cassette named "repos/contents/archive"
    Then the response status should be 302
