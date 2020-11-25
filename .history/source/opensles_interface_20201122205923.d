module opensles_interface;
import bindbc.OpenSLES.types;
import bindbc.OpenSLES.android;

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
static SLEnvironmentalReverbItf outputMixEnviromentalReverb = null;

/** Reverb effect*/
static const SLEnvironmentalReverbSettings reverbSettings = 
    SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR;

private bool wasSuccess(ref SLResult res)
{
    return res == SL_RESULT_SUCCESS;
}
private string getSLESErr(string msg)
{
    return "OpenSL ES Error:\n\t"~msg;
}

struct BufferQueuePlayer
{
    SLObjectItf playerObject;
    SLPlayItf playerPlay;
    SLAndroidSimpleBufferQueueItf playerBufferQueue;
    SLEffectSendItf playerEffectSend;
    SLMuteSoloItf playerMuteSolo;
    SLVolumeItf playerVolume;
    SLmilliHertz playerSampleRate = 0;
    /**
    * device native buffer size is another factor to minimize audio latency, not used in this
    * sample: we only play one giant buffer here
    */
    jint   playerBufferSize = 0;
    short *resampleBuf = NULL;
}

static BufferQueuePlayer bq;

void sliCreateOutputContext()
{
    string[] errorMessages;
    SLResult res = slCreateEngine(&engineObject,0,null,0,null,null);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not create engine");

    //Initialize|Realize the engine
    res = engineObject.Realize(engineObject, SL_BOOLEAN_FALSE);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not realize|initialize engine");

    //Get the interface for being able to create child objects from the engine
    res = engineObject.GetInterface(engineObject, SL_IID_ENGINE, &engine);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not get an interface for creating objects";
    
    //Set environmental reverb as a non required interface
    SLInterfaceID[1] ids = [SL_IID_ENVIRONMENTALREVERB];
    SLBoolean[1] req = [SL_BOOLEAN_FALSE];

    res = engine.CreateOutputMix(engine, &outputMixObject, 1, ids, req);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not create an output mix");

    res = outputMixObject.Realize(outputMixObject, SL_BOOLEAN_FALSE);
    if(!wasSuccess(res))
        errroMessages~= getSLESErr("Could not realize|initialize output mix");
    
    res = outputMixObject.GetInterface(outputMixObject, 
          SL_IID_ENVIRONMENTALREVERB, &outputMixEnviromentalReverb);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not get any Reverb support");
    else
    {
        res = outputMixEnviromentalReverb.SetEnvironmentalReverbProperties(
            outputMixEnviromentalReverb, &reverbSettings
        );
    }
}


void bqPlayerCallback(SLAndroidSimpleBufferQueueItf bufferQueue, void* context)
{
    assert(bufferQueue == bq.playerBufferQueue);
    assert(context == null);
    // for streaming playback, replace this test by logic to find and fill the next buffer
    if (--nextCount > 0 && null != nextBuffer && 0 != nextSize) 
    {
        SLresult result;
        // enqueue another buffer
        result = bqPlayerBufferQueue->Enqueue(bqPlayerBufferQueue, nextBuffer, nextSize);
        // the most likely other result is SL_RESULT_BUFFER_INSUFFICIENT,
        // which for this code example would indicate a programming error
        if (SL_RESULT_SUCCESS != result) {
            pthread_mutex_unlock(&audioEngineLock);
        }
    }
    else 
    {
        releaseResampleBuf();
        pthread_mutex_unlock(&audioEngineLock);
    }
}


void createBufferQueueAudioPlayer(int sampleRate, int bufferSize)
{
    SLResult res;

    if(sampleRate >= 0 && bufferSize >= 0)
    {
        bq.playerSampleRate = sampleRate*1000;
        bq.playerBufferSize = bufferSize;
    }
    SLDataLocator_AndroidSimpleBufferQueue buffQ = [SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2];
    SLDataFormat_PCM formatPCM = [
        SL_DATAFORMAT_PCM, 1, SL_SAMPLINGRATE_8,
        SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
        SL_SPEAKER_FRONT_CENTER, SL_BYTEORDER_LITTLEENDIAN
    ];

    if(bq.playerSampleRate)
        formatPCM.samplesPerSec = bq.playerSampleRate;
    
    SLDataSource audioSource = [&buffQ, &formatPCM];

    //Configure audio sink
    SLDataLocator_OutputMix outMix = [SL_DATALOCATOR_OUTPUTMIX, outputMixObject];
    SLDataSink audioSink = [&outMix, null];

    /**
    *   Create audio player:
    *       fast audio does not support when SL_IID_EFFECTSEND is required
    *       skip it for fast audio case
    */

    const SLInterfaceID[3] ids = [SL_IID_BUFFERQUEUE, SL_IID_VOLUME, SL_IID_EFFECTSEND /*,SL_IID_MUTESOLO*/];
    const SLboolean[3] req = [SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE /*, SL_BOOLEAN_TRUE*/];

    res = engine.CreateAudioPlayer(engine, &bq.playerObject, &audioSource, &audioSink,
         bq.playerSampleRate ? 2 : 3, ids, req);

    string[] errorMessages;
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not create audioPlayer");
    
    //Initialize audio player
    res = bq.playerObject.Realize(bq.playerObject, SL_BOOLEAN_FALSE);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not realize audioPlayer");
    
    //Get buffer queue interface
    res = bq.playerObject.GetInterface(bq.playerObject, SL_IID_BUFFERQUEUE, &bq.playerBufferQueue);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not get buffer queue");

    //Register callback on the b queue
    res = bq.playerBufferQueue.RegisterCallback(bq.playerBufferQueue, bqPlayerCallback, null);
    if(!wasSuccess(res))
        errorMessages~= getSLESErr("Could not register onBufferFinish callback(bqPlayerCallback) on buffer queue");



}