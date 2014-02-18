/**
 * User: miguel
 * Date: 19/09/2013
 */
package cukes
{
import com.flashquartermaster.cuke4as3.filesystem.WireFileParser;
import com.flashquartermaster.cuke4as3.net.CommandProcessor;
import com.flashquartermaster.cuke4as3.reflection.StepInvoker;
import com.flashquartermaster.cuke4as3.reflection.StepMatcher;
import com.flashquartermaster.cuke4as3.reflection.StepsProcessor;

import cukes.cucumber.CucumberConnectionBuilder;
import cukes.error.ErrorHandler;

import flash.desktop.NativeApplication;

import flash.display.Stage;
import flash.events.Event;

public class ApplicationContext
{
    public const loggingConfig : LoggingConfig = new LoggingConfig();

    public const errorHandler : ErrorHandler = new ErrorHandler();

    public const main : Main = new Main();

    public const cucumberConnectionBuilder : CucumberConnectionBuilder = new CucumberConnectionBuilder();

    public const testRunnerParameters : TestRunnerParameters = new TestRunnerParameters();

    public const wireFileParser : WireFileParser = new WireFileParser();

    public const stepsProcessor : StepsProcessor = new StepsProcessor();

    public const commandProcessor : CommandProcessor = new CommandProcessor();

    public const stepInvoker : StepInvoker = new StepInvoker();

    public const stepMatcher : StepMatcher = new StepMatcher(stepInvoker);

    public function ApplicationContext(stage:Stage)
    {
        trace("Creating cukes runner");
        resolveMain();
        resolveCommandProcessor();
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onCloseApp);
    }

    private function onCloseApp(event:Event) : void
    {
        trace("Closing Socket and Socket Server");
        cucumberConnectionBuilder.destroy();
    }

    private function resolveMain() : void
    {
        main.commandProcessor = commandProcessor;
        main.cucumberConnectionBuilder = cucumberConnectionBuilder;
        main.stepMatcher = stepMatcher;
        main.stepsProcessor = stepsProcessor;
        main.testRunnerParams = testRunnerParameters;
        main.wireFileParser = wireFileParser;
    }

    private function resolveCommandProcessor() : void
    {
        commandProcessor.stepInvoker = stepInvoker;
        commandProcessor.stepMatcher = stepMatcher;
    }

}
}
