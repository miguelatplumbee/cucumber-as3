# cucumber-as3

**cucumber-as3** allows developer to write step definitions in Actionscript and use them to instrument cucumber tests.

## example

Given the following feature written using Gherkin syntax:

 ```gherkin
 # calculator.feature
 Feature: how to do some math

 	Scenario: Adding two numbers
 	    Given I have entered 3 into the calculator
 	    And I have entered 1 into the calculator
 	    When I want it to add
 	    Then the current value should be 4
 ```


and a Calculator written in Actionscript:

 ```as3
public class Calculator {

		public function push(n:Number):void { ... }

		public function divide():Number { ... }

		public function add():Number { ... }
	}
}
 ```

you can implement the step definitions for this tests in as3:


 ```as3
package step_definitions {

    public class Calculator_Steps {

        private var _calculator:Calculator;

        [BeforeScenario]
        public function setup() : void {
            _calculator = new Calculator();
        }

        [AfterScenario]
        public function tearDown() : void {
            _calculator = null;
        }

        [Given(/^I have entered (\d+) into the calculator$/g)]
        public function pushNumber( n:Number ) : void {
            _calculator.push(n);
        }

        [When(/^I want it to add$/)]
        public function pressButton(button:String) : void {
            _calculator.add();
        }

        [Then(/^the current value should be (.*)$/)]
        public function checkValue(value:Number) : void {
            assertEquals(value, _calculator.result);
        }
    }
}
 ```

and execute the test using cucumber

 ```bash
 cucumber calculator.feature
 ```



