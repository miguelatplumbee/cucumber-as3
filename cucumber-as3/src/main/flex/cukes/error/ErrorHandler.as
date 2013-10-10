/**
 * User: miguel
 * Date: 20/09/2013
 */
package cukes.error
{
import flash.desktop.NativeApplication;
import flash.display.LoaderInfo;
import flash.events.UncaughtErrorEvent;

public class ErrorHandler
{

    public function registerUncaughtErrorEventHandler(loaderInfo:LoaderInfo) : void
    {
//        loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors);
    }

    private function handleUncaughtErrors (event:UncaughtErrorEvent) : void
    {
        const error : Error = event.error;
        processError(error);
    }

    private function processError (error:*):void
    {
        if(error is CucumberConnectionError)
        {

        }
        else if(error is WireFileResolveError)
        {

        }
        NativeApplication.nativeApplication.exit(1);
    }

}
}
