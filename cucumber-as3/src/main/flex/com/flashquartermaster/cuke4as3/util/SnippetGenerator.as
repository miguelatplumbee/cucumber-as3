/**
 * User: miguel
 * Date: 19/09/2013
 */
package com.flashquartermaster.cuke4as3.util
{
public class SnippetGenerator
{
    public static function generate (snippetData:Object):String
    {
        //Format {"step_keyword":"When","multiline_arg_class":"","step_name":"I have clicked the button"}

        var multiline_arg_class:String = snippetData.multiline_arg_class;
        var step_name:String = snippetData.step_name;

        var regExp:String = StringUtilities.createCapturingGroups(step_name);

        var return_string:String =
                makeMetaData(snippetData.step_keyword, regExp) +
                        makeFunctionSignature(step_name, makeArgs(regExp, multiline_arg_class)) +
                        makeFunctionBody(multiline_arg_class);

        resetCounters();

        return return_string;
    }

    private static function makeMetaData (step_keyword:String, regExp:String):String
    {
        return "[" + step_keyword + " (/^" + regExp + "$/)]\n"
    }

    private static function makeFunctionSignature (step_name:String, args:String):String
    {
        return "public function should_" + StringUtilities.formatStepToFunctionName(step_name) + "(" + args + "):void\n";
    }

    private static function makeFunctionBody (multiline_arg_class:String):String
    {
        return "{\n" + multilineArgsCode(multiline_arg_class) + "\tthrow new Pending(\"Awaiting implementation\");\n}";
    }

    private static function makeArgs (regExp:String, multiline_arg_class:String):String
    {
        var args:String = "";

        var dataTypes:Array = StringUtilities.getCapturingGroupDataTypes(regExp);

        var numArgs:uint = dataTypes.length + ( multiline_arg_class == "" ? 0 : 1 );

        for (var i:uint = 0; i < numArgs; i++)
        {
            args += addFirstSpace(i) +
                    makeArg(dataTypes[i]) +
                    addComma(i, numArgs) +
                    endArgString(i, numArgs, multiline_arg_class);
        }

        return args;
    }

    private static var _stringCount:int;
    private static var _numberCount:int;

    private static function resetCounters ():void
    {
        _numberCount = 0;
        _stringCount = 0;
    }

    private static function makeNumberArg ():String
    {
        return "n" + ( ++_numberCount ) + ":Number";
    }

    private static function makeStringArg ():String
    {
        return "s" + ( ++_stringCount ) + ":String";
    }

    private static function multilineArgsCode (multiline_arg_class:String):String
    {
        if (multiline_arg_class == "Cucumber::Ast::Table")
        {
            return "\tvar table:Table = new Table( array );\n";
        }
        return "";
    }

    private static function makeArg (argType:String):String
    {
        var s:String = "";

        switch (argType)
        {
            case "String":
                s = makeStringArg();
                break;
            case "Number":
                s = makeNumberArg();
                break;
            default:
                s = "";
                break;
        }

        return s;
    }

    private static function addFirstSpace (i:uint):String
    {
        if (isFirstArg(i))
        {
            return " ";
        }
        return "";
    }

    private static function endArgString (i:uint, n:uint, multiline_arg_class:String):String
    {
        var s:String = "";

        if (isLastArg(i, n))
        {
            if (multiline_arg_class != "")
            {
                switch (multiline_arg_class)
                {
                    case "Cucumber::Ast::Table":
                        s += "array:Array";
                        break;
                    case "Cucumber::Ast::DocString":
                        s += "docString:String";
                        break;
                }
            }

            s += " ";
        }

        return s;
    }

    private static function addComma (i:uint, numArgs:uint):String
    {
        if (isMultipleArgs(i, numArgs))
        {
            return ", ";
        }
        return "";
    }

    private static function isLastArg (i:uint, n:uint):Boolean
    {
        return ( i == (n - 1) );
    }

    private static function isMultipleArgs (i:uint, n:uint):Boolean
    {
        return ( n > 0 && i != n - 1 );
    }

    private static function isFirstArg (i:uint):Boolean
    {
        return i == 0;
    }


}
}
