## Getting started with cucumber-as3


Given the following feature:

 ```gherkin
 Feature: how to do some math

 	Scenario: Adding two numbers
 	    Given I have entered 3 into the calculator
 	    And I have entered 1 into the calculator
 	    When I want it to add
 	    Then the current value should be 4
 ```

 and the following `Calculator` class written in Actionscript

  ```as3
 package {

 import flash.display.Sprite;

 public class Calculator extends Sprite {

    private var stack:Vector.<Number>;

    public function Calculator() {
        stack = new Vector.<Number>();
    }

    public function push(n:Number):void {
        stack.push(n);
    }

    public function add():Number {
        return stack[0] + stack[1];
    }
 }
 }
```


step definitions for this tests can be written using Actionscript:


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

In order to execute this test using cucumber we need to enable communication between out Actionscript TestRunner and cucumber runner. A file with `.wire` extension is expected to be found in `step_definitions` folder. The layout of the project should look like this:


![Alt text](https://github.com/miguelatplumbee/cucumber-as3/blob/master/cucumber-as3-wiki/img/file_layout_1.png)
