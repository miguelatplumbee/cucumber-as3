package cukes.stepdefinitions
{
	public class CalculatorSteps
	{
		private var _calculator:Calculator;
		private var _calculatorResult:Number;
		
		public function CalculatorSteps()
		{
			_calculator = new Calculator();
		}
		
		[Given(/^I have entered (\d+) into the calculator$/g)]
		public function pushNumber( n:Number ):void
		{
			_calculator.push( n );
		}
		
		[When(/^I want it to (add|divide)$/)]
		public function pressButton( button:String ):void
		{
			if( button == "divide" )
			{
				_calculatorResult = _calculator.divide();
			}
			else if( button == "add" )
			{
				_calculatorResult = _calculator.add();
			}
			else
			{
				throw new Error( "Unknown operation : " + button );
			}
		}
		
		[Then(/^the current value should be (.*)$/)]
		public function checkValue( value:Number ):void
		{
			if( _calculatorResult != value )
			{
				throw new Error( "Expected " + value + ", but got " + _calculatorResult );
			}
		}
		
	}
}