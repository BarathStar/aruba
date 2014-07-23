Feature: Command environment variables

  In order to test command line applications which make use of environment variables
  As a developer using Cucumber
  I want to use the command environment variable step

  Scenario: Changing the environment
    Given I set the environment variables to:
      | variable           | value      |
      | LONG_LONG_VARIABLE | long_value |
    When I run `/usr/bin/env`
    Then the output should contain:
      """
      long_value
      """

  Scenario: Append value to environment variable
    Given I set the environment variables to:
      | variable           | value      | action |
      | LONG_LONG_VARIABLE | long_value |        |
      | LONG_LONG_VARIABLE | append     | +      |
    When I run `/usr/bin/env`
    Then the output should contain:
      """
      LONG_LONG_VARIABLE=long_valueappend
      """

  Scenario: Append value to environment variable
    Given I set the environment variables to:
      | variable           | value      | action |
      | LONG_LONG_VARIABLE | long_value |        |
      | LONG_LONG_VARIABLE | prepend    | .      |
    When I run `/usr/bin/env`
    Then the output should contain:
      """
      LONG_LONG_VARIABLE=prependlong_value
      """
