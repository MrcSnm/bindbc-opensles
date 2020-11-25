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

void sliCreateContext()
{
    string[] errorMessages;
    SLResult res = slCreateEngine(&engineObject,0,null,0,null,null);
    if(res != SL_RESULT_SUCCESS)
        errorMessages~="Could not create OpenSL ES Engine";
}