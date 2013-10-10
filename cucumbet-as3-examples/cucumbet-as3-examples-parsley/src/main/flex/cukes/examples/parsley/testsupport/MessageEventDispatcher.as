/**
 * User: miguel
 * Date: 06/10/2013
 */
package cukes.examples.parsley.testsupport
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class MessageEventDispatcher extends EventDispatcher
{

    public function messageHandler(message:Object) : void
    {
        const timer : Timer  = new Timer(1,1);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();
    }

    private function onTimer(event:TimerEvent) : void
    {
        event.target.removeEventListener(TimerEvent.TIMER, onTimer);
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}
