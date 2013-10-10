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
package com.flashquartermaster.cuke4as3.net
{
import com.flashquartermaster.cuke4as3.events.InvokeMethodEvent;
import com.flashquartermaster.cuke4as3.events.ProcessedCommandEvent;
import com.flashquartermaster.cuke4as3.reflection.IStepInvoker;
import com.flashquartermaster.cuke4as3.reflection.IStepMatcher;
import com.flashquartermaster.cuke4as3.util.CucumberMessageMaker;
import com.flashquartermaster.cuke4as3.util.SnippetGenerator;
import com.flashquartermaster.cuke4as3.vo.InvokeInfo;
import com.flashquartermaster.cuke4as3.vo.MatchInfo;

import cukes.processor.CucumberRequestType;
import cukes.processor.Metadata;

import flash.events.EventDispatcher;

[Event(name="commandSuccessEvent", type="com.flashquartermaster.cuke4as3.events.ProcessedCommandEvent")]
[Event(name="commandErrorEvent", type="com.flashquartermaster.cuke4as3.events.ProcessedCommandEvent")]

public class CommandProcessor extends EventDispatcher implements ICommandProcessor
{

    [Inject]
    public var stepMatcher : IStepMatcher;

    [Inject]
    public var stepInvoker : IStepInvoker;

    public function processCommand (action:String, data:Object):void
    {
        switch (action)
        {
            case CucumberRequestType.BEGIN_SCENARIO:
                beginScenario(data);
                break;
            case CucumberRequestType.STEP_MATCHES:
                stepMatch(data);
                break;
            case CucumberRequestType.INVOKE:
                invoke(data);
                break;
            case CucumberRequestType.END_SCENARIO:
                endScenario(data);
                break;
            case CucumberRequestType.SNIPPET_TEXT:
                snippetText(data);
                break;
            default:
                const msg:String = "Unknown Command : " + action + ", with data : " + data;
                dispatchEvent(new ProcessedCommandEvent(ProcessedCommandEvent.ERROR, [msg]));
                break;
        }
    }

    private function beginScenario (data:Object):void
    {
        //["begin_scenario",{"tags":["dev"]}]
        runStepsByMetadataName(Metadata.BEFORE_SCENARIO);
        dispatchEvent(new ProcessedCommandEvent(ProcessedCommandEvent.SUCCESS, CucumberMessageMaker.successMessage()));
    }

    private function stepMatch (data:Object):void
    {
        //["step_matches",{"name_to_match":"we're all wired"}]
        const processedCommandEvent:ProcessedCommandEvent = new ProcessedCommandEvent(ProcessedCommandEvent.SUCCESS);

        const matchInfo:MatchInfo = stepMatcher.match(data.name_to_match);

        if (matchInfo.isMatch())
        {
            processedCommandEvent.result = CucumberMessageMaker.foundSuccessfulMatchMessage(matchInfo);
        }
        else if (matchInfo.isUndefined())
        {
            processedCommandEvent.result = CucumberMessageMaker.dryRunSuccessMessage();
        }
        else if (matchInfo.isError())
        {
            processedCommandEvent.result = CucumberMessageMaker.failMessage(matchInfo.errorMessage);
        }

        matchInfo.destroy();

        dispatchEvent(processedCommandEvent);
    }

    private function invoke (data:Object):void
    {

        runStepsByMetadataName(Metadata.BEFORE_STEP);

        //["invoke",{"args":["3"],"id":0}]
        stepInvoker.addEventListener(InvokeMethodEvent.RESULT, onInvokeMethodResult);
        stepInvoker.invoke(data);
    }

    private function onInvokeMethodResult (invokeMethodEvent:InvokeMethodEvent):void
    {
        try
        {
            const processedCommandEvent:ProcessedCommandEvent = new ProcessedCommandEvent(ProcessedCommandEvent.SUCCESS);

            stepInvoker.removeEventListener(InvokeMethodEvent.RESULT, onInvokeMethodResult);

            const invokeInfo:InvokeInfo = invokeMethodEvent.result;

            if (invokeInfo.isSuccess())
            {
                processedCommandEvent.result = CucumberMessageMaker.successMessage();
            }
            else if (invokeInfo.isPending())
            {
                processedCommandEvent.result = CucumberMessageMaker.pendingMessage(invokeInfo.pendingMessage);
            }
            else if (invokeInfo.isError())
            {
                processedCommandEvent.result = CucumberMessageMaker.
                        failMessage(invokeInfo.errorMessage, invokeInfo.errorName, invokeInfo.errorTrace);
            }

            invokeInfo.destroy();

            runStepsByMetadataName(Metadata.AFTER_STEP);

            dispatchEvent(processedCommandEvent);
        }
        catch (e:Error)
        {
            dispatchEvent(new ProcessedCommandEvent(
                    ProcessedCommandEvent.ERROR,
                    ["Invoke Method Result Received Out of Sync. Perhaps you have called stop() while a method " +
                            "was still executing"]))
        }
    }

    private function snippetText (data:Object):void
    {
        // ["snippet_text",{"step_keyword":"Then","multiline_arg_class":"","step_name":"the headings will be \"Header A\"
        // and \"Header B\" and \"Header C\""}]
        dispatchEvent(new ProcessedCommandEvent(ProcessedCommandEvent.SUCCESS,
                ["success", SnippetGenerator.generate(data) ]));
    }

    private function endScenario (data:Object):void
    {
        runStepsByMetadataName(Metadata.AFTER_SCENARIO);

        //Cucumber resets state between scenarios so we shall too :)
        stepInvoker.resetState();
        dispatchEvent(new ProcessedCommandEvent(ProcessedCommandEvent.SUCCESS, CucumberMessageMaker.successMessage()));
    }

    private function runStepsByMetadataName (metadataName:String):void
    {
        for each(var step:XML in stepMatcher.matchableSteps)
        {
            for each(var metadata:* in step..metadata)
            {
                var name : String = metadata.@name;
                if(name == metadataName)
                {
                    stepInvoker.invokeXML(step,[]);
                }
            }
        }
    }
}
}
