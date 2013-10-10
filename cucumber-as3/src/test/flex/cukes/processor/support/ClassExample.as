/**
 * User: miguel
 * Date: 20/09/2013
 */
package cukes.processor.support
{
public class ClassExample
{

    [BeforeScenario]
    public function executeBeforeScenario() : void
    {

    }

    [AfterScenario]
    public function afterScenario() : void
    {

    }

    [Given(/^I have entered (\d+) into the calculator$/g)]
    public function pushNumber( n:Number ):void
    {
    }

    [When(/^I want it to (add|divide)$/)]
    public function pressButton( button:String ):void
    {
    }

    [Then(/^the current value should be (.*)$/)]
    public function checkValue( value:Number ):void
    {
    }

}
}
