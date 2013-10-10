/**
 * Copyright (c) 2011 FlashQuartermaster Ltd
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author Tom Coxen
 * @version
 **/
package com.flashquartermaster.cuke4as3.util
{
import com.flashquartermaster.cuke4as3.vo.MatchInfo;

public class CucumberMessageMaker
	{

        private static const PENDING:String = "pending";
        private static const SUCCESS:String = "success";

		public static function failMessage(message:String = "", exception:String = "", backtrace:String = ""):Array
		{
			//protect from null vaues
			message = message != null ? message : "";
			exception = exception != null ? exception : "";
			backtrace = backtrace != null ? backtrace : "";
			return ["fail",{"message":message, "exception":exception, "backtrace":backtrace}];
		}

        public static function successMessage():Array
		{
			return [SUCCESS];
		}
		
		public static function dryRunSuccessMessage():Array
		{
			return [SUCCESS,[]];
		}
		
		public static function foundSuccessfulMatchMessage( matchInfo:MatchInfo ):Array
		{
			return [SUCCESS,[
				{
					"id": matchInfo.id,
					"args": matchInfo.args,
					"source": matchInfo.className,
					"regexp": matchInfo.regExp
				}
			]
			];
		}

        public static function pendingMessage( message:String = ""):Array
		{
			return [PENDING,message];
		}
		

	}
}