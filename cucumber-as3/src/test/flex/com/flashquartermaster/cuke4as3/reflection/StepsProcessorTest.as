/**
 * Created by miguel on 14/01/2014.
 */
package com.flashquartermaster.cuke4as3.reflection
{
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.fail;

public class StepsProcessorTest
{

    private var stepsProcessor : StepsProcessor;

    [Before]
    public function setup()
    {
        stepsProcessor = new StepsProcessor();
    }

    [After]
    public function teardown()
    {
        stepsProcessor = null;
    }

    [Test]
    public function steps_by_array_are_resolved() : void
    {
        var list : Vector.<MatchableStep> = stepsProcessor.getMatchableStepsArray([
                    StepDefinitionsClassTest1, StepDefinitionsClassTest2]);
        checkStepsXMLList(list)

    }

    private function checkStepsXMLList(list : Vector.<MatchableStep>) : void
    {
        assertEquals(4, list.length);

        assertHasNodeWithName("checkSomething", list);
        assertHasNodeWithName("doSomething", list);
        assertHasNodeWithName("checkSomething2", list);
        assertHasNodeWithName("doSomething2", list);
    }

    private function assertHasNodeWithName(name : String, list : Vector.<MatchableStep>) : void
    {
        for each(var xml : MatchableStep in list)
        {
            var nodeName : String = xml.xmlDef.@name;
            if(nodeName == name)
            {
                return;
            }
        }
        fail("step with name " + name + " wasn't found in steps XMLList");
    }
}
}

internal class StepDefinitionsClassTest1 {

    [Given(/^I do something$/g)]
    public function doSomething( n:Number ):void
    {
    }

    [Then(/^Something happens$/g)]
    public function checkSomething( n:Number ):void
    {
    }
}

internal class StepDefinitionsClassTest2 {

    [Given(/^I do something again$/g)]
    public function doSomething2( n:Number ):void
    {
    }

    [Then(/^Something happens again$/g)]
    public function checkSomething2( n:Number ):void
    {
    }
}