Feature: Before and After Hooks

    In order to allow users write flexible step definitions
    I want to support BeforeScenario, AfterScenario, BeforeTest and AfterStep hooks

  # Execution order before checking flag value: BeforeScenario -> BeforeStep -> AfterStep -> BeforeStep
  Scenario: BeforeScenario modify flag values in BeforeAfterDefinitions.as
      Given BeforeAfterStepDefinitions is running
      Then flag value is 341


  Scenario: Repeating the scenario to check AfterScenario has reset the flag
    Given BeforeAfterStepDefinitions is running
    Then flag value is 341

