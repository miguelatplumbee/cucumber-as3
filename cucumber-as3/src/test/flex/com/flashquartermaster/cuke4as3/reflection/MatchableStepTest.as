package com.flashquartermaster.cuke4as3.reflection
{
import cukes.processor.support.ClassExample;

import flash.utils.describeType;

import org.flexunit.assertThat;

import org.flexunit.asserts.assertEquals;

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;

import org.flexunit.asserts.assertTrue;
import org.hamcrest.core.isA;

public class MatchableStepTest
{
    private var step : MatchableStep;

    [After]
    public function teardown()
    {
        step = null;
    }

    [Test]
    public function method_is_async() : void
    {
        var def : XML = describeType(ClassExample);

        step = new MatchableStep(asyncMethod);
        assertTrue(step.isAsync);
    }

    [Test]
    public function method_is_not_async() : void
    {
        step = new MatchableStep(nonAsyncMethod);
        assertFalse(step.isAsync);
    }

    [Test]
    public function className_is_resolved() : void
    {
        step = new MatchableStep(asyncMethod);
        assertEquals("cukes.processor.support.ClassExample", step.className);
    }

    [Test]
    public function methodName_is_resolved() : void
    {
        step = new MatchableStep(asyncMethod);
        assertEquals("checkValue", step.methodName);
    }

    [Test]
    public function createInstance_returns_correct_value() : void
    {
        step = new MatchableStep(asyncMethod);
        assertThat(step.createInstance(), isA(ClassExample));
    }

    [Test]
    public function test_match_with_no_parameters() : void
    {
        const candidateMatch : String = "I have entered data";
        step = new MatchableStep(nonAsyncMethod);
        const match : Object = step.match(candidateMatch);
        assertNotNull(match);
        assertEquals(candidateMatch, match[0])
    }

    [Test]
    public function test_match_with_parameters() : void
    {
        const candidateMatch : String = "the current value should be 56";
        step = new MatchableStep(asyncMethod);
        const match : Object = step.match(candidateMatch);
        assertNotNull(match);
        assertEquals(candidateMatch, match[0]);
        assertEquals("56", match[1])
    }

    [Test]
    public function test_does_not_match_with_wrong_parameters() : void
    {
        const candidateMatch : String = "the current value should be xyz";
        step = new MatchableStep(asyncMethod);
        const match : Object = step.match(candidateMatch);
        assertNull(match);
    }

    [Test]
    public function method_with_no_metadata_matches_null() : void
    {
        const candidateMatch : String = "some matchable";
        step = new MatchableStep(noMetadataMethod);
        const match : Object = step.match(candidateMatch);
        assertNull(match);
    }

    private static const nonAsyncMethod : XML =
            <method name="pushNumber" declaredBy="cukes.processor.support::ClassExample" returnType="void">
                <metadata name="Given">
                    <arg key="" value="/^I have entered data$/g"/>
                </metadata>
                <metadata name="__go_to_definition_help">
                    <arg key="pos" value="349"/>
                </metadata>
            </method>;

    private static const asyncMethod : XML =
            <method name="checkValue" declaredBy="cukes.processor.support::ClassExample" returnType="void">
                <parameter index="1" type="Number" optional="false"/>
                <metadata name="Then">
                    <arg key="" value="/^the current value should be (\\d+)$/"/>
                    <arg key="" value="async"/>
                </metadata>
                <metadata name="__go_to_definition_help">
                    <arg key="pos" value="577"/>
                </metadata>
            </method>;

    private static const noMetadataMethod : XML =
            <method name="noMetadataMethod" declaredBy="cukes.processor.support::ClassExample" returnType="void">
                <metadata name="__go_to_definition_help">
                    <arg key="pos" value="349"/>
                </metadata>
            </method>;
}
}
