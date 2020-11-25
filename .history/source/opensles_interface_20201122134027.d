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


/**
*   Output mix interfaces
*/
static SLObjectItf outputMixObject = null;

private bool wasSuccess(ref SLResult res)
{
    return res == SL_RESULT_SUCCESS;
}
private string getSLESErr(string msg)
{
    return "OpenSL ES Error:\n\t"~msg;.
}

void sliCreateOutputContext()
{
    string[] errorMessages;
    SLResult res = slCreateEngine(&engineObject,0,null,0,null,null);
    if(!wasSuccess(res))
        errorMessages~="Could not create OpenSL ES Engine";

    //Initialize|Realize the engine
    res = engineObject.Realize(engineObject, SL_BOOLEAN_FALSE);
    if(!wasSuccess(res))
        errorMessages~="Could not realize OpenSL ES Engine";

    //Get the interface for being able to create child objects from the engine
    res = engineObject.GetInterface(engineObject, SL_IID_ENGINE, &engine);
    if(!wasSuccess(res))
        errorMessages~="OpenSL ES Could not get an interface for creating objects";
    
    //Set environmental reverb as a non required interface
    SLInterfaceID[1] ids = [SL_IID_ENVIRONMENTALREVERB];
    SLBoolean[1] req = [SL_BOOLEAN_FALSE];

    res = engine.CreateOutputMix(engine, &outputMixObject, 1, ids, req);
    if(!wasSuccess(res))
        errorMessages~="OpenSL ES could not create an output mix";

    res = outputMixObject.Realize(outputMixObject, SL_BOOLEAN_FALSE);
    if(!wasSuccess(res))



}

