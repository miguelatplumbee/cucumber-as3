/**
 * User: miguel
 * Date: 19/09/2013
 */
package cukes.processor
{
public class CucumberRequestType
{

    /**
     * Used to find out whether the wire server has a definition for a given step
     */
    public static const STEP_MATCHES : String = "step_matches";

    /**
     * Used to ask for a step definition to be invoked
     */
    public static const INVOKE : String = "invoke";

    /**
     * Signals that cucumber is about to execute a scenario
     */
    public static const BEGIN_SCENARIO : String = "begin_scenario";

    /**
     * Signals that cucumber has finished executing a scenario
     */
    public static const END_SCENARIO : String = "end_scenario";

    /**
     * Requests a snippet for an undefined step
     */
    public static const SNIPPET_TEXT : String = "snippet_text";

}
}
