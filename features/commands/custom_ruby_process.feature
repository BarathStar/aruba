Feature: Custom Ruby Process
 
  Running a lot of scenarios where each scenario uses Aruba
  to spawn a new ruby process can be time consuming.
  
  Aruba lets you plug in your own process class that can
  run a command in the same ruby process as Cucumber/Aruba.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Run a passing custom process
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'Hello World'
    """
    And a file named "features/custom_ruby_process.feature" with:
    """
    Feature: Hello World by ruby

      @in-process
      Scenario: Run command
        When I run `cli`
        Then the output should contain "Hello World"
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    Hello World
    """
    And the features should all pass
