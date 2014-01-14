/**
 * User: miguel
 * Date: 18/09/2013
 */
package cukes.cucumber
{
import com.flashquartermaster.cuke4as3.net.*;

import flash.events.Event;
import flash.events.ServerSocketConnectEvent;
import flash.net.ServerSocket;
import flash.net.Socket;

public class CucumberConnectionBuilder
{

    private var _port : uint;

    private var _server : ServerSocket;

    private var _cucumberConnection : CucumberConnection;

    public function build(port:uint) : ICucumberConnection
    {
        if(_server)
        {
            throw new Error("Cucumber Connection is already active at :" + _port);
        }

        this._port = port;

        _server = new ServerSocket();
        _server.addEventListener(ServerSocketConnectEvent.CONNECT, onServerSocketConnect);
        _server.addEventListener(Event.CLOSE, onServerSocketClose);
        _server.bind( _port );
        _server.listen();

        _cucumberConnection = new CucumberConnection();
        return _cucumberConnection;
    }

    private function onServerSocketConnect(event:ServerSocketConnectEvent):void
    {
        const socket : Socket = event.socket as Socket;
        _cucumberConnection.start(socket);
    }

    private function onServerSocketClose(event:Event):void
    {
        destroy();
    }


    public function destroy() : void
    {
        if( _server != null )
        {
            if( _server.listening )
            {
                _server.close();
            }

            _server.removeEventListener(ServerSocketConnectEvent.CONNECT, onServerSocketConnect);
            _server.removeEventListener(Event.CLOSE, onServerSocketClose);
            _server = null;
        }
        if(_cucumberConnection)
        {
            _cucumberConnection.destroy();
        }

        throw new Error("SSOCKET SERVER CLOSED!!!");
    }

}
}
