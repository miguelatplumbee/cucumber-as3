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
package com.flashquartermaster.cuke4as3.reflection
{
import com.flashquartermaster.cuke4as3.util.StringUtilities;
import com.flashquartermaster.cuke4as3.vo.MatchInfo;

public class StepMatcher implements IStepMatcher
    {
        private var _matchableSteps:Vector.<MatchableStep>;
        private var _stepInvoker:IStepInvoker;

        public function StepMatcher( stepInvoker:IStepInvoker )
        {
            _stepInvoker = stepInvoker;
        }

        public function match( matchString:String ):MatchInfo
        {

            if(!matchString)
            {
                throw new Error("step definition to match is empty or null");
            }

            const matchInfo:MatchInfo = new MatchInfo();

            for each ( var step:MatchableStep in _matchableSteps )
            {

                var methodXml : XML = step.xmlDef;
                try
                {
                    var regExInMetadata:String = methodXml.metadata.arg[0].@value;

                    var result:Object = matchStringWithRegExFromMetadata( regExInMetadata, matchString );

                    if( result != null)
                    {
                        matchInfo.className = StringUtilities.getClassNameFromDeclaredBy( methodXml.@declaredBy );
                        matchInfo.args = getArgsFromResult( result, matchString );
                        matchInfo.id = _stepInvoker.saveMethodDefinitionForInvokation( methodXml );
                        matchInfo.regExp = regExInMetadata;
                        break;
                    }
                }catch(error:Error)
                {
                    trace("no regexp in this metadata");
                }
            }

            return matchInfo;
        }

        //Refactor Note: Result object contains the index and the input string
        /*
         var result:Object = pattern.exec( s );
         while( result != null )
         {
         trace (result.length, result.input, "\t", result.index, "\t", result);
         result = pattern.exec( s );
         }
         */

        private function matchStringWithRegExFromMetadata( regExInMetadata:String, matchString:String ):Object
        {
            var a:Array = regExInMetadata.split( "/" );//These are the slashes that wrap the regexp

            var regex:String = a[1];
            var flags:String = a[2];

            var pattern:RegExp = new RegExp( regex, flags );

            return pattern.exec( matchString );
        }


        private function getArgsFromResult( result:Object, matchString:String ):Array
        {
            var args:Array = [];
            var position:int;
            var index:int;
            //Note: result[0] == matchString

            for( var i:uint = 1; i < result.length; i++ )
            {
                var value:String = manageConditionalCapturingGroups( result[i] );

                position = matchString.indexOf( value );

                index = (i - 1);
                args[ index ] = { val:value, pos:position };
            }

            return args;
        }

        private function manageConditionalCapturingGroups( s:* ):String
        {
            return ( s == undefined ? "" : s.toString() );
        }

        public function destroy():void
        {
            _matchableSteps = null;
            _stepInvoker = null
        }

        public function get matchableSteps():Vector.<MatchableStep>
        {
            return _matchableSteps;
        }

        public function set matchableSteps( value:Vector.<MatchableStep> ):void
        {
            _matchableSteps = value;
        }
    }
}