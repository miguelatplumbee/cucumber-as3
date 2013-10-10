package cukes.stepdefinitions
{
	import flash.display.Sprite;
	
	public class Calculator extends Sprite
	{
		public var stack:Vector.<Number>;
		
		public function Calculator()
		{
			stack = new Vector.<Number>();
		}
		
		public function push(n:Number):void
		{
			stack.push(n);	
		}
		
		public function divide():Number
		{
			return stack[0] / stack[1];
		}
		
		public function add():Number
		{
			return stack[0] + stack[1];
		}
	}
}