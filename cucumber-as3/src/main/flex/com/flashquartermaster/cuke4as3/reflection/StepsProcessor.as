/**
 * User: miguel
 * Date: 17/09/2013
 */
package com.flashquartermaster.cuke4as3.reflection
{
import flash.utils.describeType;

public class StepsProcessor
{

    public function getMatchableSteps (stepDefinitions : Array) : XMLList
    {
        var result : XMLList = new XMLList();

        for each(var stepDefinition : Class in stepDefinitions)
        {
            const classDescription : XML = describeType(stepDefinition);

            result += classDescription..method.( hasOwnProperty( "metadata" ) );
        }

        return result;
    }

    public function getMatchableStepsArray (stepDefinitions : Array) : Vector.<MatchableStep>
    {
        const result : Vector.<MatchableStep> = new Vector.<MatchableStep>();

        for each(var stepDefinition : XML in getMatchableSteps(stepDefinitions))
        {
            result.push(new MatchableStep(stepDefinition));
        }

        return result;
    }

}
}
