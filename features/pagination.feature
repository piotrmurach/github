Feature: Githu API pagination
  In order to paginate number of received records
  As a user
  I want to be able to view them in chunks

  Scenario: Passing per_page param
    Given I have "Github::Repos" instance
    When I want to list resources
      And I pass the following request options:
        | user   | per_page |
        | wycats | 45       |
      And I make request within a cassette named "pagination/repos/list"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should have 45 items

    When I request "next" page within a cassette named "pagination/repos/list/next"
    Then the response should be "200"
      And the response should have 45 items

  Scenario: Returned paginated resources are different
    Given I have "Github::Repos" instance
    When I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
      And I make request within a cassette named "pagination/repos/diff"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should have 30 items

    When I request "next" page within a cassette named "pagination/repos/diff/next"
    Then the response should be "200"
      And the response should have 30 items
      And the response collection of resources is different for "name" attribute

  Scenario: Calling 'commits' for Github::Repos with per_page param
    Given I have "Github::Repos::Commits" instance
    When I am looking for "list" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I pass the following request options:
        | per_page |
        | 45       |
      And I make request within a cassette named "pagination/repos/commits/list"
    Then the response should be "200"
      And the response type should be "JSON"
      And the response should have 45 items

    When I request "next" page within a cassette named "pagination/repos/commits/next"
    Then the response should be "200"
      And the response should have 45 items

  Scenario: Calling 'list' for Github::Repos::Commits returns different collections
    Given I have "Github::Repos::Commits" instance
    When I am looking for "list" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "pagination/repos/commits/sha"
    Then the response should be "200"
      And the response should have 30 items

    When I request "next" page within a cassette named "pagination/repos/commits/sha/next"
    Then the response should be "200"
      And the response should have 30 items
      And the response collection of resources is different for "sha" attribute

  Scenario: Requesting resources with per_page helper
    Given I have "Github::Repos" instance
    When I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
      And I make request within a cassette named "pagination/repos/per_page/first"
    Then the response should be "200"
    When I iterate through collection pages within a cassette named "pagination/repos/per_page/each_page"
    Then this collection should include first page

