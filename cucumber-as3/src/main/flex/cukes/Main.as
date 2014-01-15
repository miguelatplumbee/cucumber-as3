/**
 * User: miguel
 * Date: 19/09/2013
 */
package cukes
{
import com.flashquartermaster.cuke4as3.events.ProcessedCommandEvent;
import com.flashquartermaster.cuke4as3.filesystem.WireFileParser;
import com.flashquartermaster.cuke4as3.net.ICommandProcessor;
import cukes.cucumber.events.CucumberRequestEvent;
import com.flashquartermaster.cuke4as3.reflection.StepMatcher;
import com.flashquartermaster.cuke4as3.reflection.StepsProcessor;
import com.flashquartermaster.cuke4as3.vo.CucumberServerInfo;

import cukes.cucumber.CucumberConnectionBuilder;
import cukes.cucumber.ICucumberConnection;

import flash.filesystem.File;

public class Main
{

    [Inject]
    public var stepMatcher : StepMatcher;

    [Inject]
    public var stepsProcessor : StepsProcessor;

    [Inject]
    public var cucumberConnectionBuilder : CucumberConnectionBuilder;

    [Inject]
    public var testRunnerParams : TestRunnerParameters;

    [Inject]
    public var wireFileParser : WireFileParser;

    [Inject]
    public var commandProcessor : ICommandProcessor;

    private var _cucumberConnection : ICucumberConnection;

    public function run() : void
    {
        testRunnerParams.featuresDir = File.applicationDirectory.nativePath;

        stepMatcher.matchableSteps = stepsProcessor.getMatchableStepsArray(testRunnerParams.stepDefinitions);

        const cucumberServerInfo : CucumberServerInfo = wireFileParser.getServerInfoFromWireFile
                (testRunnerParams.featuresDir, testRunnerParams.cucumberPort);

        _cucumberConnection = cucumberConnectionBuilder.build(cucumberServerInfo.port);

        _cucumberConnection.addEventListener(CucumberRequestEvent.REQUEST, cucumberRequestHandler);

        commandProcessor.addEventListener(ProcessedCommandEvent.SUCCESS, stepSuccessHandler);
    }

    private function cucumberRequestHandler(event:CucumberRequestEvent) : void
    {
        commandProcessor.processCommand(event.requestType, event.payload);
    }

    private function stepSuccessHandler (event:ProcessedCommandEvent):void
    {
        _cucumberConnection.send(event.result);
    }

}
}
