/**
 * User: miguel
 * Date: 19/09/2013
 */
package cukes
{
import mx.logging.Log;
import mx.logging.LogEventLevel;
import mx.logging.targets.TraceTarget;

public class LoggingConfig
{

    [Init]
    public function init() : void
    {
        // TODO


        return;
        // Create a target.
        var logTarget:TraceTarget = new TraceTarget();

        // Log only messages for the classes in the mx.rpc.* and
        // mx.messaging packages.
        logTarget.filters = [];

        // Log all log levels.
        logTarget.level = LogEventLevel.ALL;

        // Add date, time, category, and log level to the output.
        logTarget.includeDate = true;
        logTarget.includeTime = true;
        logTarget.includeCategory = true;
        logTarget.includeLevel = true;

        // Begin logging.
        Log.addTarget(logTarget);
    }

}
}
