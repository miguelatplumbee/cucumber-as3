# Writing step definitions for cucumber-as3

With cucumber-as3 you can write step definitions for [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin)
features using a combination of plain as3 and metadata. [Read more about Gherkin syntax](http://docs.behat.org/guides/1.gherkin.html).

Given the following feature:

 ```gherkin
 Feature: how to do some math

 	Scenario: Adding two numbers
 	    Given I have entered 3 into the calculator
 	    And I have entered 1 into the calculator
 	    When I want it to add
 	    Then the current value should be 4
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

There's an excellent documentation on step definitions in
[Cucumber Documentation](http://cukes.info/step-definitions.html)

Metadata is used to define step definitions. Available metadata are `[Given]`, `[When]` and `[Then]` for execution
steps, and `[BeforeScenario]`, `[AfterScenario]`, `[BeforeStep]` and `[AfterStep]` for test
[hooks](https://github.com/cucumber/cucumber/wiki/Hooks).

Step definitions are matched to actual code using
[Regular Expressions](http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7ea9.html).
Check [Adobe Livedocs](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/RegExp.html) for more
information of regular expressions in as3.

Step definition classes must be included in a text fixture before running `cucumber`. See [running text fixtures](todo)

## Asynchronous step definitions

Given the asynchronous nature of as3 we'll often require
[FlexUnit Asynchronous Support](http://docs.flexunit.org/index.php?title=Writing_an_AsyncTest) to mark a step definition
as _complete_. We can use all asynchronous features from FlexUnit in step definitions as we normally do in FlexUnit test
cases.

Methods using asynchronous support must include `"async"` in metadata.

```as3
[Given (/^a precondition$/, "async") ]
```
