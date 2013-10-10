/**
 * User: miguel
 * Date: 26/09/2013
 */
package {
import cukes.CukesTestRunner;

import features.BeforeAfterStepDefinitions;

import flash.display.Sprite;

public class TestRunner extends Sprite
{
    public function TestRunner ()
    {
        super();

        const runner : CukesTestRunner = new CukesTestRunner();
        runner.stepDefinitions = [BeforeAfterStepDefinitions];
        runner.run(loaderInfo);
    }

}
}