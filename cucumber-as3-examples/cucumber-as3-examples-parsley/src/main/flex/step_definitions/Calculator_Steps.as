package step_definitions
{

import cukes.examples.parsley.CalculatorPM;
import cukes.examples.parsley.CalculatorResultMessage;
import cukes.examples.parsley.testsupport.ParsleySupport;

import org.flexunit.asserts.assertEquals;

public class Calculator_Steps
{


    [Given (/^I sum (\d+) and (\d+)$/, "async")]
    public function pushNumber (n:Number, m:Number):void
    {
        ParsleySupport.proceedOnMessage(this, CalculatorResultMessage);

        const pm:CalculatorPM = ParsleySupport.getContext().getObjectByType(CalculatorPM) as CalculatorPM;
        pm.doSum(n, m);
    }

    [Then (/^the result should be (\d+)$/)]
    public function checkValue (value:Number):void
    {
        const pm:CalculatorPM = ParsleySupport.getContext().getObjectByType(CalculatorPM) as CalculatorPM;
        assertEquals(value, pm.lastResult);
    }
}
}