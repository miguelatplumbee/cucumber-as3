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

public class ApplicationContext
{
    public const loggingConfig : LoggingConfig = new LoggingConfig();

    public const main : Main = new Main();

    public const cucumberConnectionBuilder : CucumberConnectionBuilder = new CucumberConnectionBuilder();

    public const testRunnerParameters : TestRunnerParameters = new TestRunnerParameters();

    public const wireFileParser : WireFileParser = new WireFileParser();

    public const stepsProcessor : StepsProcessor = new StepsProcessor();

    public const commandProcessor : CommandProcessor = new CommandProcessor();

    public const stepInvoker : StepInvoker = new StepInvoker();

    public const stepMatcher : StepMatcher = new StepMatcher(stepInvoker);

    public const errorHandler : ErrorHandler = new ErrorHandler();

}
}
