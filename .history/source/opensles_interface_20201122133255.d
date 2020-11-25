module opensles_interface;
import bindbc.OpenSLES.types;

/**
*   This file is meant to provide a higher level interface OpenAL-alike
* as there is little information about how to use, I'm trying to bring to D this interface following
* the steps from the audioprogramming blog, as it is currently private, I'm bringing it what I could find.
*/

/**
* Engine interface
*/
static SLObjectItf engineObject = null;
static SLEngineItf engine;

void sliCreateOutputContext()
{
    string[] errorMessages;
    SLResult res = slCreateEngine(&engineObject,0,null,0,null,null);
    if(res != SL_RESULT_SUCCESS)
        errorMessages~="Could not create OpenSL ES Engine";

    //Initialize|Realize the engine
    res = engineObject.Realize(engineObject, SL_BOOLEAN_FALSE);
    if(res != SL_RESULT_SUCCESS)
        errorMessages~="Could not realize OpenSL ES Engine";

    //Get the interface for being able to create child objects from the engine
    res = engineObject.GetInterface(engineObject, SL_IID_ENGINE, &engine);
    if(res != SL_RESULT_SUCCESS)
        errorMessages~="OpenSL ES Could not get an interface for creating objects";
    
    
}


