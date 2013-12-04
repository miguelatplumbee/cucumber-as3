# cucumber-as3

> Write step definitions in Actionscript and use them to instrument your cucumber tests.

**Cucumber-as3** enables Actionscript developers to write and run functional tests using [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin) syntax and [Cucumber](http://cukes.info).

Cucumber-as3 is not a reimplementation of cucumber in a different language (such as cucumber-jvm or cucumber-js). Instead, it makes use of cucumber [wire protocol](https://github.com/cucumber/cucumber/wiki/Wire-Protocol) to test features against a TestRunner written in AS3.

 * [Getting Started](https://github.com/miguelatplumbee/cucumber-as3/blob/master/cucumber-as3-wiki/getting_started.md)
 * [Writing step definitions in AS3](https://github.com/miguelatplumbee/cucumber-as3/blob/master/cucumber-as3-wiki/step_definitions.md)

### Usage

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


and a `Calculator` written in Actionscript:

 ```as3
public class Calculator {

    public function push(n:Number):void { ... }

    public function divide():Number { ... }

    public function add():Number { ... }

}
 ```

you can implement the step definitions required by the test:


 ```as3
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
 ```

Next step is to prepare your **TestRunner** and execute it as an Air application

```as3
public class TestRunner extends Sprite
{
    public function TestRunner () {
        super();

        const runner : CukesTestRunner = new CukesTestRunner();
        runner.stepDefinitions = [Calculator_Steps];
        runner.run();
    }
}
```

Finally execute the test using cucumber in a terminal

 ```bash
 cucumber calculator.feature
 ```