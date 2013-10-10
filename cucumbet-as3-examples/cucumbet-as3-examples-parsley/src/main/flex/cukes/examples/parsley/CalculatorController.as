/**
 * User: miguel
 * Date: 27/09/2013
 */
package cukes.examples.parsley
{
public class CalculatorController
{

    [MessageDispatcher]
    public var dispatchMessage : Function;

    [MessageHandler]
    public function handleCalculationRequestMessage (msg:CalculationRequestMessage)
    {
        const res : Number = msg.value1 + msg.value2;
        dispatchMessage(new CalculatorResultMessage(res));
    }

}
}
