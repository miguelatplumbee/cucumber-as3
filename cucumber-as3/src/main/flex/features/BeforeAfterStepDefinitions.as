package features
{
import org.flexunit.asserts.assertEquals;

public class BeforeAfterStepDefinitions
{

    private static var flag : Number = 0;

    [BeforeScenario]
    public function beforeScenario() : void
    {
        flag += 1;
    }

    [AfterScenario]
    public function afterScenario() : void
    {
        flag = 0
    }

    [BeforeStep]
    public function beforeStep() : void
    {
        flag += 20;
    }

    [AfterStep]
    public function afterStep() : void
    {
        flag += 300;
    }

    [Given ( /^BeforeAfterStepDefinitions is running$/ )]
    public function step1():void
    {
    }

    [Then (/^flag value is (\d+)$/)]
    public function flagValueIs( n:Number ):void
    {
        assertEquals(n, flag);
    }

}
}
