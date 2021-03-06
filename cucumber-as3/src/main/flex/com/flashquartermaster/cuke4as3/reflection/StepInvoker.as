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
import avmplus.getQualifiedClassName;

import com.flashquartermaster.cuke4as3.events.InvokeMethodEvent;
import com.flashquartermaster.cuke4as3.support.flexunit.MethodInvokationAsyncStatement;
import com.flashquartermaster.cuke4as3.util.StringUtilities;
import com.flashquartermaster.cuke4as3.utilities.Pending;
import com.flashquartermaster.cuke4as3.vo.InvokeInfo;

import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.system.System;
import flash.utils.getDefinitionByName;

import org.flexunit.internals.runners.statements.ExpectAsync;
import org.flexunit.token.AsyncTestToken;
import org.flexunit.token.ChildResult;
import org.flexunit.utils.ClassNameUtil;

public class StepInvoker extends EventDispatcher implements IStepInvoker
    {
        private var _methodsToInvoke:Vector.<XML>;
        private var _stepsObject:*;
        private var _applicationDomain:ApplicationDomain;
        private var _invokeInfo:InvokeInfo;

        public function StepInvoker()
        {
            _methodsToInvoke = new Vector.<XML>();
            _invokeInfo = new InvokeInfo();
            _stepsObject = {};
        }

        public function invoke(data:Object):void
        {
            //data e.g. {"args":["3"],"id":0}
            _invokeInfo.destroy();

            try
            {
                var methodToRun:XML = _methodsToInvoke[ data.id ];
            }
            catch( e:Error )
            {

                _invokeInfo.errorMessage = "No invokable method found, " + e.message;
                _invokeInfo.errorName = e.name;
                _invokeInfo.errorTrace = e.getStackTrace();

                dispatchResult();
                return;
            }

            invokeXML(methodToRun, data.args);
        }

        public function invokeXML( methodToRun:XML, args:Array ):void
        {
            if( !_stepsObject[methodToRun.@declaredBy] )
            {
                makeStepsObject( methodToRun );
            }

            //TODO: Support static methods
            var method:Function = _stepsObject[methodToRun.@declaredBy][ methodToRun.@name ];

            var returnVal:Object;
            var args:Array = args;

            try
            {
                //TODO: This should be more robust
                // It relies on the "async' string being the second arg
                // prepare for pilot error
                var async:Boolean = isAsync( methodToRun );

                if( async )
                {
                    createFlexUnitSupportFor( _stepsObject[methodToRun.@declaredBy], method, args );
                    return;
                }
                else
                {
                    if( args.length > 0 )
                    {
                        returnVal = method.apply( _stepsObject[methodToRun.@declaredBy], args );
                    }
                    else
                    {
                        returnVal = method.apply( _stepsObject[methodToRun.@declaredBy] );
                    }
                }
            }
            catch( pe:Pending )
            {
                _invokeInfo.pendingMessage = pe.message;
            }
            catch( e:Error )
            {
                _invokeInfo.errorMessage = e.message;
                _invokeInfo.errorName = e.name;
                _invokeInfo.errorTrace = e.getStackTrace();
            }

            dispatchResult();
        }

        private function dispatchResult():void
        {
            dispatchEvent( new InvokeMethodEvent( InvokeMethodEvent.RESULT, _invokeInfo ) );
        }

        public function saveMethodDefinitionForInvokation( methodXml:XML ):uint
        {
            return ( _methodsToInvoke.push( methodXml ) - 1 ); //return position in array rather than length
        }

        public function destroy():void
        {
//            com.furusystems.logging.slf4as.global.info( "StepInvoker : destroy" );

            if( _methodsToInvoke != null )
            {
                var i:uint = _methodsToInvoke.length;

                while( --i > -1 )
                {
                    System.disposeXML( _methodsToInvoke[i] );
                }

                _methodsToInvoke = null;
            }

            resetState();

            _applicationDomain = null;
        }

        //CommandProcessor uses this to nullify the object to reset state between
        //Scenario runs because we do not want to destroy
        public function resetState():void
        {


            _stepsObject = {};
        }

        //Support functions

        private function makeStepsObject( methodToRun:XML ):void
        {
            var classObject:Class = getClassObject( methodToRun.@declaredBy );

            _stepsObject[methodToRun.@declaredBy] = new classObject();
        }

        private function isAsync( methodToRun:XML ):Boolean
        {
            return methodToRun.metadata.arg[1] ? methodToRun.metadata.arg[1].@value == "async" : false;
        }

        private function createFlexUnitSupportFor( stepsObject:*, method:Function, args:Array ):void
        {
            var parentAsyncTestToken:AsyncTestToken = new AsyncTestToken( ClassNameUtil.getLoggerFriendlyClassName( stepsObject ) );
            parentAsyncTestToken.addNotificationMethod( handleNotificationFromFlexUnitAsyncSupport );

            var statement:MethodInvokationAsyncStatement = new MethodInvokationAsyncStatement();
            statement.method = method;
            statement.args = args;
            statement.stepsObject = _stepsObject[getQualifiedClassName(stepsObject)];

            var expectAsync:ExpectAsync = new ExpectAsync( _stepsObject[getQualifiedClassName(stepsObject)], statement );
            expectAsync.evaluate( parentAsyncTestToken );
        }

        private function handleNotificationFromFlexUnitAsyncSupport( result:ChildResult ):void
        {
            if( result.error != null )
            {
                var e:Error = result.error as Error;

                if( e is Pending )
                {
                    _invokeInfo.pendingMessage = e.message;
                }
                else
                {
                    _invokeInfo.errorMessage = e.message;
                    _invokeInfo.errorName = e.name;
                    _invokeInfo.errorTrace = e.getStackTrace();
                }
            }
            dispatchResult();
        }

        private function getClassObject( declaredBy:String ):Class
        {
            var className:String = StringUtilities.getClassNameFromDeclaredBy( declaredBy );

            return getDefinitionByName(className) as Class;
        }

        //Accessors

        public function set applicationDomain( applicationDomain:ApplicationDomain ):void
        {
            _applicationDomain = applicationDomain;
        }

        public function get stepsObject():*
        {
            return _stepsObject;
        }
    }
}