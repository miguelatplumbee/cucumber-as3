package
{
import cukes.CukesTestRunner;

import flash.display.Sprite;

import step_definitions.Calculator_Steps;

public class TestRunner extends Sprite
{
    public function TestRunner ()
    {
        super();

        const runner : CukesTestRunner = new CukesTestRunner();
        runner.stepDefinitions = [Calculator_Steps];
        runner.run(loaderInfo);

    }

}
}