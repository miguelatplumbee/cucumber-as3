/**
 * Created by miguel on 14/01/2014.
 */
package com.flashquartermaster.cuke4as3.reflection
{
import flash.utils.getDefinitionByName;

public class MatchableStep
{

    private var _className : String;
    private var _regexp : RegExp;
    private var _methodName : String;
    private var _xmlDef : XML;
    private var _isAsync : Boolean;

    public function MatchableStep(xmlDef : XML)
    {
        _xmlDef = xmlDef;

        _methodName = xmlDef.@name;

        const colonReplace:RegExp = /::/g;
        _className = xmlDef.@declaredBy;
        _className = _className.replace(colonReplace, ".");

        _isAsync = xmlDef.metadata.arg[1] ? xmlDef.metadata.arg[1].@value == "async" : false;

        try
        {
            const regExpValue : String = xmlDef.metadata.arg[0].@value;
            const split : Array = regExpValue.split("/");
            const regex : String = split[1];
            const flags : String = split[2];
            _regexp = new RegExp(regex, flags);
        }
        catch(error:Error)
        {
            // no regexp in metadata
        }
    }

    public function get isAsync() : Boolean
    {
        return _isAsync;
    }

    public function get xmlDef() : XML
    {
        return _xmlDef;
    }

    public function get className() : String
    {
        return _className;
    }

    public function get methodName() : String
    {
        return _methodName;
    }

    public function createInstance() : Object
    {
        const clazz : Class = getDefinitionByName(className) as Class;
        return new clazz();
    }

    public function match(matchString:String ):Object
    {
        if(!_regexp)
        {
            return null;
        }

        return _regexp.exec(matchString);
    }
}
}
