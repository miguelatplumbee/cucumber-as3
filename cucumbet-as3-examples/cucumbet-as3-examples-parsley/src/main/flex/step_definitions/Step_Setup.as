/**
 * User: miguel
 * Date: 30/09/2013
 */
package step_definitions
{
import cukes.examples.parsley.ApplicationContext;
import cukes.examples.parsley.testsupport.ParsleySupport;

import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;

public class Step_Setup
{

    [BeforeScenario]
    public function beforeScenario() : void
    {
        ParsleySupport.setContext(ActionScriptContextBuilder.build(ApplicationContext));
    }

    [AfterScenario]
    public function afterScenario() : void
    {
        ParsleySupport.destroyContext();
    }

}
}
