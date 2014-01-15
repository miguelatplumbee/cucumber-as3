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
    private var _regexpString : String;
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
            _regexpString = xmlDef.metadata.arg[0].@value;
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

    public function get regexp() : String
    {
        return _regexpString;
    }

    public function createInstance() : Object
    {
        const clazz : Class = getDefinitionByName(className) as Class;
        return new clazz();
    }

    public function match(matchString:String ):Object
    {
        if(!_regexpString)
        {
            return null;
        }

        var a:Array = _regexpString.split( "/" );

        var regex:String = a[1];
        var flags:String = a[2];

        var pattern:RegExp = new RegExp( regex, flags );

        return pattern.exec( matchString );
    }

}
}
