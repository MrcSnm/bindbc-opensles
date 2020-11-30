module opensles_interface;
import bindbc.OpenSLES.types;
import bindbc.OpenSLES.android;
import std.algorithm.searching:count;
import core.sys.posix.pthread;
import arsd.jni;
import log;


string join(T)(T[] array, string separator)
{
    string ret;
    bool isFirst = false;
    import std.conv:to;
    foreach (key; array)
    {
        if(!isFirst)
            ret~=separator;
        else
            isFirst = true;
        ret~= to!string(key);
    }
    return ret;
}




/**
*   This file is meant to provide a higher level interface OpenAL-alike
* as there is little information about how to use, I'm trying to bring to D this interface following
* the steps from the audioprogramming blog, as it is currently private, I'm bringing it what I could find.
*/


private bool slError(SLresult res)
{
    return res != SL_RESULT_SUCCESS;
}
private string getSLESErr(string msg, string func = __PRETTY_FUNCTION__, uint line = __LINE__)
{
    import std.conv:to;
    __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "OpenSL ES Error",
    (func~":"~to!string(line)~"\n\t"~msg).ptr);
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
    int   playerBufferSize = 0;
    short* resampleBuf = null;
}

struct SLClip
{
    void* samples; //Raw sample
    uint numSamples; //How many samples it has
    uint samplesPerSec; //Samples in Hz
}



void printErr(string[] err)
{
    foreach(e; err)
    {
        import std.stdio:writeln;
        e.writeln;
    }
}


struct SLIOutputMix
{
    SLEnvironmentalReverbItf environmentReverb;
    SLPresetReverbItf presetReverb;
    SLBassBoostItf bassBoost;
    SLEqualizerItf equalizer;
    SLVirtualizerItf virtualizer;
    SLObjectItf outputMixObj;


    static bool initializeForAndroid(ref SLIOutputMix output, ref SLEngineItf e)
    {
        //All those interfaces are supported on Android, so, require it
        const(SLInterfaceID)* ids = 
        [
            SL_IID_ENVIRONMENTALREVERB,
            SL_IID_PRESETREVERB,
            SL_IID_BASSBOOST,
            SL_IID_EQUALIZER,
            SL_IID_VIRTUALIZER
        ].ptr;
        const(SLboolean)* req = 
        [
            SL_BOOLEAN_TRUE,
            SL_BOOLEAN_TRUE,
            SL_BOOLEAN_TRUE,
            SL_BOOLEAN_TRUE,
            SL_BOOLEAN_TRUE //5
        ].ptr;

        string[] err;
        SLresult r;
        with(output)
        {
            r = (*e).CreateOutputMix(e, &outputMixObj, 5, ids, req);
            if(slError(r))
                err~= getSLESErr("Could not create output mix");
            //Do it assyncly
            r = (*outputMixObj).Realize(outputMixObj, SL_BOOLEAN_FALSE);
            if(slError(r))
                err~= getSLESErr("Could not initialize output mix");

            
            if(slError((*outputMixObj).GetInterface(outputMixObj, SL_IID_ENVIRONMENTALREVERB, &environmentReverb)))
            {
                err~=getSLESErr("Could not get the ENVIRONMENTALREVERB interface");
                environmentReverb = null;
            }
            if(slError((*outputMixObj).GetInterface(outputMixObj, SL_IID_PRESETREVERB, &presetReverb)))
            {
                err~=getSLESErr("Could not get the PRESETREVERB interface");
                presetReverb = null;
            }
            if(slError((*outputMixObj).GetInterface(outputMixObj, SL_IID_BASSBOOST, &bassBoost)))
            {
                err~=getSLESErr("Could not get the BASSBOOST interface");
                bassBoost = null;
            }
            if(slError((*outputMixObj).GetInterface(outputMixObj, SL_IID_EQUALIZER, &equalizer)))
            {
                err~=getSLESErr("Could not get the EQUALIZER interface");
                equalizer = null;
            }
            if(slError((*outputMixObj).GetInterface(outputMixObj, SL_IID_VIRTUALIZER, &virtualizer)))
            {
                err~=getSLESErr("Could not get the VIRTUALIZER interface");
                virtualizer = null;
            }
        }
        return r==SL_RESULT_SUCCESS && err.length==0;
    }
}


float toAttenuation(float gain)
{
    import std.math:log10;
    return (gain < 0.01f) ? -96.0f : 20 * log10(gain);
}

string getAndroidAudioPlayerInterfaces()
{
    string itfs = "SL_IID_VOLUME, SL_IID_EFFECTSEND, SL_IID_METADATAEXTRACTION";
    version(Android)
    {
        itfs~=", SL_IID_ANDROIDSIMPLEBUFFERQUEUE";
    }
    return itfs;
}
string getAndroidAudioPlayerRequirements()
{
    string req;
    bool isFirst = true;
    foreach (i; 0..getAndroidAudioPlayerInterfaces().count(",")+1)
    {
        if(isFirst)isFirst=!isFirst;
        else req~=",";
        req~= "SL_BOOLEAN_TRUE";
    }
    return req;
}

struct SLIAudioPlayer
{
    ///The Audio player
    SLObjectItf playerObj;
    ///Play/stop/pause the audio
    SLPlayItf player;
    ///Controls the volume
    SLVolumeItf playerVol;
    ///Ability to get and set the audio duration
    SLSeekItf playerSeek;
    ///@TODO
    SLEffectSendItf playerEffectSend;
    ///@TODO
    SLMetadataExtractionItf playerMetadata;

    version(Android){SLAndroidSimpleBufferQueueItf playerAndroidSimpleBufferQueue;}
    else  //Those lines will appear just as a documentation, right now, we don't have any implementation using it
    {
        ///@NO_SUPPORT
        SL3DSourceItf source3D;
        SL3DDopplerItf doppler3D;
        SL3DLocationItf location3D;
    }
    bool isPlaying, hasFinishedTrack;

    float volume;

    static void setVolume(ref SLIAudioPlayer audioPlayer, float gain)
    {
        with(audioPlayer)
        {
            (*playerVol).SetVolumeLevel(playerVol, cast(SLmillibel)(toAttenuation(gain)*100));
            volume = gain;
        }
    }

    static void destroyAudioPlayer(ref SLIAudioPlayer audioPlayer)
    {
        with(audioPlayer)
        {
            (*playerObj).Destroy(playerObj);
            playerObj = null;
            player = null;
            playerVol = null;
            playerSeek = null;
            playerEffectSend = null;
            version(Android){playerAndroidSimpleBufferQueue = null;}

        }
    }

    extern(C) static void checkClipEnd_Callback(SLPlayItf player, void* context, SLuint32 event)
    {
        if(event & SL_PLAYEVENT_HEADATEND)
        {
            SLIAudioPlayer p = *(cast(SLIAudioPlayer*)context);
            p.hasFinishedTrack = true;
        }
    }
    static void play(ref SLIAudioPlayer audioPlayer, void* samples, uint sampleSize)
    {
        with(audioPlayer)
        {
            version(Android){(*playerAndroidSimpleBufferQueue).Enqueue(playerAndroidSimpleBufferQueue, samples, sampleSize);}
            isPlaying = true;
            hasFinishedTrack = false;

            (*player).SetPlayState(player, SL_PLAYSTATE_PLAYING);
        }
    }
    static void stop(ref SLIAudioPlayer audioPlayer)
    {
        with(audioPlayer)
        {
            (*player).SetPlayState(player, SL_PLAYSTATE_STOPPED);
            version(Android){(*playerAndroidSimpleBufferQueue).Clear(playerAndroidSimpleBufferQueue);}
            isPlaying = false;
        }
    }

    static void checkFinishedPlaying(ref SLIAudioPlayer audioPlayer)
    {
        if(audioPlayer.isPlaying && audioPlayer.hasFinishedTrack)
        {
            SLIAudioPlayer.stop(audioPlayer);
        }
    }



    static bool initializeForAndroid(ref SLIAudioPlayer output, ref SLEngineItf engine, ref SLDataSource src, ref SLDataSink dest, bool autoRegisterCallback = true)
    {
        string[] errs;
        with(output)
        {
            mixin("const(SLInterfaceID)* ids = ["~getAndroidAudioPlayerInterfaces()~"].ptr;");
            mixin("const(SLboolean)* req = ["~getAndroidAudioPlayerRequirements()~"].ptr;");

            if(slError((*engine).CreateAudioPlayer(engine, &playerObj, &src, &dest,
            cast(uint)(getAndroidAudioPlayerInterfaces().count(",")+1), ids, req)))
                errs~= getSLESErr("Could not create AudioPlayer");
            if(slError((*playerObj).Realize(playerObj, SL_BOOLEAN_FALSE)))
                errs~= getSLESErr("Could not initialize AudioPlayer");

            __android_log_print(android_LogPriority.ANDROID_LOG_DEBUG, "SLES", "Created audio player");
            

            if(slError((*playerObj).GetInterface(playerObj, SL_IID_PLAY, &player)))
                errs~= getSLESErr("Could not get play interface for AudioPlayer");
            if(slError((*playerObj).GetInterface(playerObj, SL_IID_VOLUME, &playerVol)))
                errs~= getSLESErr("Could not get volume interface for AudioPlayer");
            
            // if(slError((*playerObj).GetInterface(playerObj, SL_IID_SEEK, &playerSeek)))
                // errs~= getSLESErr("Could not get Seek interface for AudioPlayer");
            if(slError((*playerObj).GetInterface(playerObj, SL_IID_EFFECTSEND, &playerEffectSend)))
                errs~= getSLESErr("Could not get EffectSend interface for AudioPlayer");
            if(slError((*playerObj).GetInterface(playerObj, SL_IID_METADATAEXTRACTION, &playerMetadata)))
                errs~= getSLESErr("Could not get MetadataExtraction interface for AudioPlayer");
            
            version(Android)
            {
                if(slError((*playerObj).GetInterface(playerObj, 
                SL_IID_ANDROIDSIMPLEBUFFERQUEUE, &playerAndroidSimpleBufferQueue)))
                    errs~= getSLESErr("Could not get AndroidSimpleBufferQueue for AudioPlayer");
            }
            __android_log_print(android_LogPriority.ANDROID_LOG_DEBUG, "SLES", "Got interfaces");

            if(autoRegisterCallback)
            {
                (*player).RegisterCallback(player, &SLIAudioPlayer.checkClipEnd_Callback, cast(void*)&output);
                (*player).SetCallbackEventsMask(player, SL_PLAYEVENT_HEADATEND);
            }
            return errs.length == 0;
        }
    }
}

/**
* Engine interface
*/
static SLObjectItf engineObject = null;
static SLEngineItf engine;

static SLIOutputMix outputMix;
static SLIAudioPlayer gAudioPlayer;
static short[8000] sawtoothBuffer;

static void loadSawtooth()
{
    for(uint i =0; i < 8000; ++i)
        sawtoothBuffer[i] = cast(short)(40_000 - ((i%100) * 220));
        
}

version(Android){alias SLIDataLocator_Address = SLDataLocator_AndroidSimpleBufferQueue;}
else{alias SLIDataLocator_Address = SLDataLocator_Address;}


// SLIDataLocator_Address sliGetAddressDataLocator()
// {
//     SLIDataLocator_Address ret;
//     version(Android)
//     {
//         ret.locatorType = SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE;
//         ret.numBuffers = 1;
//     }
//     else
//     {
//         ret.locatorType = SL_DATALOCATOR_ADDRESS;
//         ret.pAddress = 
//     }
// }

static BufferQueuePlayer bq;

string sliCreateOutputContext()
{
    string[] errorMessages = [];
    SLresult res = slCreateEngine(&engineObject,0,null,0,null,null);
    if(slError(res))
        errorMessages~= getSLESErr("Could not create engine");

    //Initialize|Realize the engine
    res = (*engineObject).Realize(engineObject, SL_BOOLEAN_FALSE);
    if(slError(res))
        errorMessages~= getSLESErr("Could not realize|initialize engine");
    

    //Get the interface for being able to create child objects from the engine
    res = (*engineObject).GetInterface(engineObject, SL_IID_ENGINE, &engine);
    if(slError(res))
        errorMessages~= getSLESErr("Could not get an interface for creating objects");

    
    __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Initialized engine");
    SLIOutputMix.initializeForAndroid(outputMix, engine);
    loadSawtooth();

    version(Android)
    {
        SLDataLocator_AndroidSimpleBufferQueue locator;
        locator.locatorType = SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE;
        locator.numBuffers = 1;
    }
    else
    {
        SLDataLocator_Address locator;
        locator.locatorType = SL_DATALOCATOR_ADDRESS;
        locator.pAddress = sawtoothBuffer.ptr;
        locator.length = 8000*2;
    }
    //Okay
    SLDataFormat_PCM format;
    format.formatType = SL_DATAFORMAT_PCM;
    format.numChannels = 1;
    format.samplesPerSec =  SL_SAMPLINGRATE_8;
    format.bitsPerSample = SL_PCMSAMPLEFORMAT_FIXED_16;
    format.containerSize = SL_PCMSAMPLEFORMAT_FIXED_16;
    format.channelMask = SL_SPEAKER_FRONT_CENTER;
    format.endianness = SL_BYTEORDER_LITTLEENDIAN;

    

    //Okay
    SLDataSource src;
    src.pLocator = &locator;
    src.pFormat = &format;

    //Okay
    SLDataLocator_OutputMix locatorMix;
    locatorMix.locatorType = SL_DATALOCATOR_OUTPUTMIX;
    locatorMix.outputMix = outputMix.outputMixObj;

    __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Created locators");
    //Okay
    SLDataSink destination;
    destination.pLocator = &locatorMix;
    destination.pFormat = null;

     SLIAudioPlayer.initializeForAndroid(gAudioPlayer, engine, src, destination);
    __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Okay here");

    __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Playing sound");
     SLIAudioPlayer.play(gAudioPlayer, sawtoothBuffer.ptr, 8000);



    
    
    return errorMessages.join("\n");
}


// pointer and size of the next player buffer to enqueue, and number of remaining buffers
static short *nextBuffer;
static uint nextSize;
static int nextCount;
// this callback handler is called every time a buffer finishes playing
extern(C)void bqPlayerCallback(SLAndroidSimpleBufferQueueItf bq, void *context)
{
    // for streaming playback, replace this test by logic to find and fill the next buffer
    if (--nextCount > 0 && null != nextBuffer && 0 != nextSize) {
        SLresult result;
        // enqueue another buffer
        result = (*bq).Enqueue(bq, nextBuffer, nextSize);
        // the most likely other result is SL_RESULT_BUFFER_INSUFFICIENT,
        // which for this code example would indicate a programming error
        // if (SL_RESULT_SUCCESS != result) {
        //     pthread_mutex_unlock(&audioEngineLock);
        // }
    } 
    // else {
    //     releaseResampleBuf();
    //     pthread_mutex_unlock(&audioEngineLock);
    // }
}


final class MainActivity : JavaClass!("com.hipreme.zenambience", MainActivity)
{
    @Export string tryInit()
    {
        import core.runtime:rt_init;
        rt_init();
        return sliCreateOutputContext();
    }
}