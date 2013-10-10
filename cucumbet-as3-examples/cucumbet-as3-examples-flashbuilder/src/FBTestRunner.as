package
{
	import flash.display.Sprite;
	
	import cukes.CukesTestRunner;
	import cukes.stepdefinitions.CalculatorSteps;
	
	public class FBTestRunner extends Sprite
	{
		public function FBTestRunner()
		{
			super();
			
			const runner : CukesTestRunner = new CukesTestRunner();
			runner.stepDefinitions = [CalculatorSteps];
			runner.run(loaderInfo);	
		}
	}
}