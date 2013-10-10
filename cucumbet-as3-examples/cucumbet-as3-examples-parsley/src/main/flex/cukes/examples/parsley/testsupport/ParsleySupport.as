/**
 * User: miguel
 * Date: 30/09/2013
 */
package cukes.examples.parsley.testsupport
{
import flash.events.Event;

import org.flexunit.async.Async;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.processor.messaging.receiver.MessageHandler;

public class ParsleySupport
{

    private static const DEFAULT_TIMEOUT : Number = 5000;

    private static var context : Context;

    private static var parsleyRegistry : MessageReceiverRegistry;

    private static var messageEventDispatcher : MessageEventDispatcher;

    private static var messageTarget : MessageTarget;

    public static function setContext (value:Context) : void
    {
        context = value;
        parsleyRegistry = context.scopeManager.getScope(ScopeName.GLOBAL).messageReceivers;
    }

    public static function getContext () : Context
    {
        return context;
    }

    public static function destroyContext () : void
    {
        context.destroy();
        parsleyRegistry = null;
    }

    public static function proceedOnMessage(stepsObject : Object, messageType:Class, selector:String = null) : void
    {
        messageEventDispatcher = new MessageEventDispatcher();
        registerMessageHandler(messageEventDispatcher, "messageHandler", messageType, selector);
        Async.proceedOnEvent(stepsObject, messageEventDispatcher, Event.COMPLETE, DEFAULT_TIMEOUT);
    }

    private static function registerMessageHandler(provider:Object, methodName:String, messageType:Class, selector:* = null) : void
    {
        messageTarget = new MessageHandler(Provider.forInstance(provider),
                methodName, selector, ClassInfo.forClass(messageType));
        parsleyRegistry.addTarget(messageTarget);
    }

}
}
