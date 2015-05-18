Feature: Reporting

  In order to get an overview
  As a developer using Cucumber
  I want to create a report

  @wip
  Scenario: use a file
    Given I use a fixture named "reporting_issue_stdout"
    And I set the environment variables to:
       | variable         | value   |
       | ARUBA_REPORT_DIR | tmp/doc |
    When I successfully run `bundle exec cucumber`
    Then the file "tmp/aruba/blub" should exist
