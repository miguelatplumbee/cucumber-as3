/**
 * User: miguel
 * Date: 26/09/2013
 */
package cukes
{

import flash.display.LoaderInfo;
import flash.filesystem.File;

public class CukesTestRunner
{

    public var stepDefinitions : Array;

    public var featuresDir : String;

    public var cucumberPort : uint;

    private var context : ApplicationContext;

    public function run(loaderInfo:LoaderInfo = null) : void
    {
        context = new ApplicationContext();

        context.errorHandler.registerUncaughtErrorEventHandler(loaderInfo);

        const params : TestRunnerParameters = context.testRunnerParameters;
        params.stepDefinitions = stepDefinitions;
        params.featuresDir = featuresDir ? featuresDir : File.applicationDirectory.nativePath;
        params.cucumberPort = cucumberPort;

        context.main.run();
    }

    public function get isRunning() : Boolean
    {
        if(context.cucumberConnectionBuilder.serverSocket)
        {
            return context.cucumberConnectionBuilder.serverSocket.listening;
        }
        else
        {
            return false;
        }
    }

}
}
