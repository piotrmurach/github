Feature: Ratelimit API

  Background:
    Given I have "Github::API" instance

  Scenario: Get ratelimit

    Given I want to ratelimit resource
    When I make request within a cassette named "ratelimit/get"
    Then the response should be 5000

  Scenario: Get ratelimit remaining

    Given I want to ratelimit_remaining resource
    When I make request within a cassette named "ratelimit/get_remaining"
    Then the response should be 4886

  Scenario: Get ratelimit reset time

    Given I want to ratelimit_reset resource
    When I make request within a cassette named "ratelimit/get_reset"
    Then the response should be 1398097303