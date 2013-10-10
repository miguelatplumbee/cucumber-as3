/**
 * User: miguel
 * Date: 27/09/2013
 */
package cukes.examples.parsley
{
public class CalculatorPM
{

    [MessageDispatcher]
    public var dispatchMessage : Function;

    private var _lastResult : Number;

    public function get lastResult() : Number
    {
        return _lastResult;
    }

    public function doSum(value1 : Number, value2 : Number) : void
    {
        dispatchMessage(new CalculationRequestMessage(value1, value2));
    }

    [MessageHandler]
    public function handleCalculatorResultMessage(message:CalculatorResultMessage) : void
    {
        _lastResult = message.result;
    }

}
}
