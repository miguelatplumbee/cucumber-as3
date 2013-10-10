@math
Feature: How to do math
    As a hopeless mathematician
    I want to be able to do some math


    Background:
      Given I have entered 3 into the calculator

	@add
	Scenario: Adding two numbers
	    And I have entered 1 into the calculator
	    When I want it to add
	    Then the current value should be 4
    
    @divide
	Scenario: Dividing two numbers
		And I have entered 2 into the calculator
		When I want it to divide
		Then the current value should be 1.5