/**
 * User: miguel
 * Date: 06/10/2013
 */
package cukes.processor
{
import com.flashquartermaster.cuke4as3.vo.MatchInfo;

import flash.utils.describeType;

public class StepDefinitionClass
{

    private var description : XML;

    public function StepDefinitionClass (clazz : Class)
    {
        description = describeType(clazz);
    }

    public function matchStep(regexp:String) : MatchInfo
    {
        return null;
    }

    public function getBeforeScenarioMethods() : Vector.<String>
    {
        return getMethodsWithMetadata(Metadata.BEFORE_SCENARIO);
    }

    public function getAfterScenarioMethods() : Vector.<String>
    {
        return getMethodsWithMetadata(Metadata.AFTER_SCENARIO);
    }

    public function getBeforeStepMethods() : Vector.<String>
    {
        return getMethodsWithMetadata(Metadata.BEFORE_STEP);
    }

    public function getAfterStepMethods() : Vector.<String>
    {
        return getMethodsWithMetadata(Metadata.AFTER_STEP);
    }

    private function getMethodsWithMetadata(metadataName:String) : Vector.<String>
    {
        const methodList : XMLList =  description..method.(
                hasOwnProperty( "metadata" ) && metadata == metadataName);
        const result : Vector.<String> = new Vector.<String>();
        for each(var methodXML : XML in methodList)
        {
            var methodName : String = methodXML.@name;
            result.push(methodName);
        }
        return result;
    }

}
}
