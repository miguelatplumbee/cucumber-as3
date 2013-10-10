/**
 * User: miguel
 * Date: 18/09/2013
 */
package cukes.cucumber
{
import com.flashquartermaster.cuke4as3.net.*;
import com.adobe.serialization.json.JSON;
import cukes.cucumber.events.CucumberRequestEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.ProgressEvent;
import flash.net.Socket;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

[Event(name="request", type="cukes.cucumber.events.CucumberRequestEvent")]
[Event(name="connection_closed", type="cukes.cucumber.events.CucumberRequestEvent")]

public class CucumberConnection extends EventDispatcher implements ICucumberConnection
{

    private static const LOG : Logger = LogContext.getLogger(CucumberConnection);

    public static var EOT:String = "\n";

    private var _socket : Socket;

    public function start(socket:Socket) : void
    {
        if(!_socket)
        {
            _socket = socket;
            _socket.addEventListener(Event.CONNECT, onSocketDataReceived);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataReceived);
            _socket.addEventListener(Event.CLOSE, onSocketClose);
        }
    }

    public function destroy():void
    {
        if( _socket != null )
        {
            _socket.removeEventListener(Event.CONNECT, onSocketDataReceived);
            _socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketDataReceived);
            if( _socket.connected )
            {
                _socket.close();
            }
            _socket = null;
        }
    }

    public function send(data:Array):void
    {
        const encoded:String = com.adobe.serialization.json.JSON.encode(data);
        _socket.writeUTFBytes(encoded + EOT);
        _socket.flush();
    }

    private function onSocketDataReceived(event:Event):void
    {
        const rawSocketData : String = _socket.readUTFBytes(_socket.bytesAvailable);
        LOG.info("cucumber request received: {0}", rawSocketData);
        if(rawSocketData != EOT)
        {
            const data : Array = com.adobe.serialization.json.JSON.decode(rawSocketData);
            dispatchRequestEvent(data);
        }
    }

    private function dispatchRequestEvent(data:Array) : void
    {
        const messageType : String = data[0];
        const payload : Object = data[1];
        const event : CucumberRequestEvent =
                new CucumberRequestEvent(CucumberRequestEvent.REQUEST, messageType, payload);
        dispatchEvent(event);
    }

    private function onSocketClose(event:Event) : void
    {
        destroy();
        dispatchEvent(new CucumberRequestEvent(CucumberRequestEvent.CONNECTION_CLOSED));
    }

}
}
