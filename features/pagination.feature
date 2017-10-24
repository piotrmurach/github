Feature: Github API pagination

  The gem permits to paginate resources.

  Scenario: Passing per_page param

    Given I have "Github::Client::Repos" instance
    When I want to list resources
      And I pass the following request options:
        | user   | per_page |
        | wycats | 45       |
      And I make request within a cassette named "pagination/repos/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 45 items

    When I request next page within a cassette named "pagination/repos/list/next"
    Then the response status should be 200
      And the response should have 45 items

  Scenario: Returned paginated resources are different

    Given I have "Github::Client::Repos" instance
    When I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
      And I make request within a cassette named "pagination/repos/diff"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 30 items

    When I request next page within a cassette named "pagination/repos/diff/next"
    Then the response status should be 200
      And the response should have 30 items
      And the response collection of resources is different for "name" attribute

  Scenario: Calling 'commits' for Github::Client::Repos with per_page param

    Given I have "Github::Client::Repos::Commits" instance
    When I am looking for "list" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I pass the following request options:
        | per_page |
        | 45       |
      And I make request within a cassette named "pagination/repos/commits/list"
    Then the response status should be 200
      And the response type should be JSON
      And the response should have 45 items

    When I request next page within a cassette named "pagination/repos/commits/next"
    Then the response status should be 200
      And the response should have 45 items

  Scenario: Calling 'list' for Github::Client::Repos::Commits returns different collections

    Given I have "Github::Client::Repos::Commits" instance
    When I am looking for "list" with the following params:
      | user          | repo   |
      | peter-murach  | github |
      And I make request within a cassette named "pagination/repos/commits/sha"
    Then the response status should be 200
      And the response should have 30 items

    When I request next page within a cassette named "pagination/repos/commits/sha/next"
    Then the response status should be 200
      And the response should have 30 items
      And the response collection of resources is different for "sha" attribute

  Scenario: Requesting resources with per_page helper

    Given I have "Github::Client::Repos" instance
      And I want to list resources
      And I pass the following request options:
        | user   |
        | wycats |
    When I make request within a cassette named "pagination/repos/per_page/first"
    Then the response status should be 200
    When I iterate through collection pages within a cassette named "pagination/repos/per_page/each_page"
    Then this collection should include first page

  Scenario: Navigating resource links with query parameters

    Given I have "Github::Client::Issues" instance
      And I want to list resources with the following params:
        | user         | repo   |
        | peter-murach | github |
      And I pass the following request options:
        | state  | per_page | user         | repo   |
        | closed | 50       | peter-murach | github |
    When I make request within a cassette named "pagination/issues/list/first"
    Then the response status should be 200
      And the response next link should contain:
        | page | per_page | state  |
        | 2    | 50       | closed |
      And the response last link should contain:
        | page | per_page | state  |
        | 3    | 50       | closed |

  Scenario: Navigate to Next page
    Given I have "Github::Client::Issues" instance
      And I want to list resources with the following params:
        | user         | repo   |
        | peter-murach | github |
      And I pass the following request options:
        | state  | per_page | user         | repo   |
        | closed | 50       | peter-murach | github |
    When I make request within a cassette named "pagination/issues/list/first"
      And I request next page within a cassette named "pagination/issues/list/next"
    Then the response status should be 200
      And the response first link should contain:
        | page | per_page | state  |
        | 1    | 50       | closed |
      And the response next link should contain:
        | page | per_page | state  |
        | 3    | 50       | closed |
      And the response prev link should contain:
        | page | per_page | state  |
        | 1    | 50       | closed |
      And the response last link should contain:
        | page | per_page | state  |
        | 3    | 50       | closed |

  Scenario: Navigate to Last page

    Given I have "Github::Client::Issues" instance
      And I want to list resources with the following params:
        | user         | repo   |
        | peter-murach | github |
      And I pass the following request options:
        | state  | per_page | user         | repo   |
        | closed | 50       | peter-murach | github |
    When I make request within a cassette named "pagination/issues/list/first"
      And I request last page within a cassette named "pagination/issues/list/last"
    Then the response status should be 200
      And the response prev link should contain:
        | page | per_page | state  |
        | 2    | 50       | closed |
      And the response first link should contain:
        | page | per_page | state  |
        | 1    | 50       | closed |

  Scenario: Navigate to Previous page

    Given I have "Github::Client::Issues" instance
      And I want to list resources with the following params:
        | user         | repo   |
        | peter-murach | github |
      And I pass the following request options:
        | state  | per_page | page | user         | repo   |
        | closed | 50       | 3    | peter-murach | github |
    When I make request within a cassette named "pagination/issues/list/lastest"
      And I request prev page within a cassette named "pagination/issues/list/prev"
    Then the response status should be 200
      And the response prev link should contain:
        | page | per_page | state  |
        | 1    | 50       | closed |
      And the response next link should contain:
        | page | per_page | state  |
        | 3    | 50       | closed |
      And the response first link should contain:
        | page | per_page | state  |
        | 1    | 50       | closed |
      And the response last link should contain:
        | page | per_page | state  |
        | 3    | 50       | closed |
