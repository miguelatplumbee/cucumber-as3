/**
 * User: miguel
 * Date: 26/09/2013
 */
package cukes
{

import cukes.error.ErrorHandler;

import flash.display.LoaderInfo;
import flash.filesystem.File;

import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

public class CukesTestRunner
{

    public var stepDefinitions : Array;

    public var featuresDir : String;

    public var cucumberHost : String;

    public var cucumberPort : uint;

    public function run(loaderInfo:LoaderInfo = null) : void
    {
        const context : Context = ActionScriptContextBuilder.build(ApplicationContext);

        const errorHandler : ErrorHandler = context.getObjectByType(ErrorHandler) as ErrorHandler;
        errorHandler.registerUncaughtErrorEventHandler(loaderInfo);

        const params : TestRunnerParameters = context.getObjectByType(TestRunnerParameters) as TestRunnerParameters;
        params.stepDefinitions = stepDefinitions;
        params.featuresDir = featuresDir ? featuresDir : File.applicationDirectory.nativePath;
        params.cucumberHost = cucumberHost;
        params.cucumberPort = cucumberPort;

        const main : Main = context.getObjectByType(Main) as Main;
        main.run();
    }

}
}
