Feature: Reporting Issue

  In order to get an overview
  As a developer using Cucumber
  I want to create a report

  Scenario: use a file
    Given a file named "input" with:
    """
    test
    """
    When I run `cat test`
    Then the output should contain "test"
