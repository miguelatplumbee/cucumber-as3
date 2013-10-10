/**
 * User: miguel
 * Date: 19/09/2013
 */
package cukes.cucumber
{
import flash.events.IEventDispatcher;

[Event(name="request", type="cukes.cucumber.events.CucumberRequestEvent")]
[Event(name="connection_closed", type="cukes.cucumber.events.CucumberRequestEvent")]

public interface ICucumberConnection extends IEventDispatcher
{

    function send(data:Array) : void;


}
}
