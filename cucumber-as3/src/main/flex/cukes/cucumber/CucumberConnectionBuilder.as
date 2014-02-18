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

    private var _portRangeLast : uint;

    private var _server : ServerSocket;

    private var _cucumberConnection : CucumberConnection;

    private var _currentPortAttempt : uint;

    public function build(port:uint, portRangeLast:uint) : ICucumberConnection
    {
        if(_server)
        {
            throw new Error("Cucumber Connection is already active at :" + _port);
        }

        this._port = port;
        this._portRangeLast = portRangeLast;

        _currentPortAttempt = _port;
        while(_server == null)
        {
            createServerSocket();
        }

        _cucumberConnection = new CucumberConnection();
        return _cucumberConnection;
    }

    private function createServerSocket() : void
    {
        trace("creating server socket at " + _currentPortAttempt);
        var server : ServerSocket = new ServerSocket();
        try
        {
            server.bind( _currentPortAttempt );
            server.listen();
            server.addEventListener(ServerSocketConnectEvent.CONNECT, onServerSocketConnect);
            server.addEventListener(Event.CLOSE, onServerSocketClose);
            _server = server;
        }
        catch(error:Error)
        {
            trace("creating server failed at " + _currentPortAttempt);
            _currentPortAttempt++;
            if(_currentPortAttempt > _portRangeLast)
            {
                throw new Error("Unable to create server socket within the range: " + error.message);
            }

        }
    }

    private function onServerSocketConnect(event:ServerSocketConnectEvent):void
    {
        trace("cucumber socket server connected");
        const socket : Socket = event.socket as Socket;
        _cucumberConnection.destroy();
        _cucumberConnection.start(socket);
    }

    private function onServerSocketClose(event:Event):void
    {
        trace("cucumber socket server closed");
        destroy();
    }

    public function get serverSocket () : ServerSocket
    {
        return _server;
    }

    public function destroy() : void
    {
        if(_cucumberConnection)
        {
            _cucumberConnection.destroy();
        }

        if( _server != null )
        {
            trace("server listening" + _server.listening);
            if( _server.listening )
            {
                _server.close();
            }

            _server.removeEventListener(ServerSocketConnectEvent.CONNECT, onServerSocketConnect);
            _server.removeEventListener(Event.CLOSE, onServerSocketClose);
            _server = null;
        }

    }

}
}
