Feature: Octocat ASCII API

  Background:
    Given I have "Github::Client::Say" instance

  Scenario: ASCII octocat with random text

    Given I want to say resource
    When I make request within a cassette named "say/random"
    Then the response status should be 200
      And the response type should be TEXT
      And the response should contain:
        """
                       MMM.           .MMM
                       MMMMMMMMMMMMMMMMMMM
                       MMMMMMMMMMMMMMMMMMM      _______________________________________
                      MMMMMMMMMMMMMMMMMMMMM    |                                       |
                     MMMMMMMMMMMMMMMMMMMMMMM   | Non-blocking is better than blocking. |
                    MMMMMMMMMMMMMMMMMMMMMMMM   |_   ___________________________________|
                    MMMM::- -:::::::- -::MMMM    |/
                     MM~:~   ~:::::~   ~:~MM
                .. MMMMM::. .:::+:::. .::MMMMM ..
                      .MM::::: ._. :::::MM.
                         MMMM;:::::;MMMM
                  -MM        MMMMMMM
                  ^  M+     MMMMMMMMM
                      MMMMMMM MM MM MM
                           MM MM MM MM
                           MM MM MM MM
                        .~~MM~MM~MM~MM~~.
                     ~~~~MM:~MM~~~MM~:MM~~~~
                    ~~~~~~==~==~~~==~==~~~~~~
                     ~~~~~~==~==~==~==~~~~~~
                         :~==~==~==~==~~
        """

  Scenario: ASCII octocat with custom text

    Given I want to say resource with the following params:
        | text             |
        | Hello cool world |
    When I make request within a cassette named "say/custom"
    Then the response status should be 200
      And the response type should be TEXT
      And the response should contain:
        """
                       MMM.           .MMM
                       MMMMMMMMMMMMMMMMMMM
                       MMMMMMMMMMMMMMMMMMM      __________________
                      MMMMMMMMMMMMMMMMMMMMM    |                  |
                     MMMMMMMMMMMMMMMMMMMMMMM   | Hello cool world |
                    MMMMMMMMMMMMMMMMMMMMMMMM   |_   ______________|
                    MMMM::- -:::::::- -::MMMM    |/
                     MM~:~   ~:::::~   ~:~MM
                .. MMMMM::. .:::+:::. .::MMMMM ..
                      .MM::::: ._. :::::MM.
                         MMMM;:::::;MMMM
                  -MM        MMMMMMM
                  ^  M+     MMMMMMMMM
                      MMMMMMM MM MM MM
                           MM MM MM MM
                           MM MM MM MM
                        .~~MM~MM~MM~MM~~.
                     ~~~~MM:~MM~~~MM~:MM~~~~
                    ~~~~~~==~==~~~==~==~~~~~~
                     ~~~~~~==~==~==~==~~~~~~
                         :~==~==~==~==~~
        """
