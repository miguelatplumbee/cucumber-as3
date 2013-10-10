package cukes.cucumber.events
{
import flash.events.Event;

public class CucumberRequestEvent extends Event
{

    public static const REQUEST : String = "request";
    public static const CONNECTION_CLOSED : String = "connection_closed";

    private var _payload : Object;
    private var _requestType : String;

    public function CucumberRequestEvent (type:String, requestType:String=null, payload:Object=null)
    {
        super(type);
        _requestType = requestType;
        _payload = payload;
    }

    public function get requestType() : String
    {
        return _requestType;
    }

    public function get payload() : Object
    {
        return _payload;
    }

}
}
