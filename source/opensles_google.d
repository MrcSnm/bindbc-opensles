/**
*   This file is intended to clone the behavior from googles native-audio repo,
*   although there is a bit more of things.
*/
module opensles_google;
import bindbc.OpenSLES.types;
import bindbc.OpenSLES.android;
import arsd.jni;

import core.sys.posix.pthread;
static SLObjectItf engineObject = null;
static SLEngineItf engineEngine;

// output mix interfaces
static SLObjectItf outputMixObject = null;
static SLEnvironmentalReverbItf outputMixEnvironmentalReverb = null;

// buffer queue player interfaces
static SLObjectItf bqPlayerObject = null;
static SLPlayItf bqPlayerPlay;
static SLAndroidSimpleBufferQueueItf bqPlayerBufferQueue;
static SLEffectSendItf bqPlayerEffectSend;
static SLMuteSoloItf bqPlayerMuteSolo;
static SLVolumeItf bqPlayerVolume;
static SLmilliHertz bqPlayerSampleRate = 0;
static jint   bqPlayerBufSize = 0;
static short *resampleBuf = null;
// a mutext to guard against re-entrance to record & playback
// as well as make recording and playing back to be mutually exclusive
// this is to avoid crash at situations like:
//    recording is in session [not finished]
//    user presses record button and another recording coming in
// The action: when recording/playing back is not finished, ignore the new request
static pthread_mutex_t  audioEngineLock = PTHREAD_MUTEX_INITIALIZER;

// aux effect on the output mix, used by the buffer queue player
static const SLEnvironmentalReverbSettings reverbSettings =
    { - 1000 , - 237 , 2700 , 790 , - 1214 , 13 , 395 , 20 , 1000 , 1000 };

// URI player interfaces
static SLObjectItf uriPlayerObject = null;
static SLPlayItf uriPlayerPlay;
static SLSeekItf uriPlayerSeek;
static SLMuteSoloItf uriPlayerMuteSolo;
static SLVolumeItf uriPlayerVolume;

// file descriptor player interfaces
static SLObjectItf fdPlayerObject = null;
static SLPlayItf fdPlayerPlay;
static SLSeekItf fdPlayerSeek;
static SLMuteSoloItf fdPlayerMuteSolo;
static SLVolumeItf fdPlayerVolume;

// recorder interfaces
static SLObjectItf recorderObject = null;
static SLRecordItf recorderRecord;
static SLAndroidSimpleBufferQueueItf recorderBufferQueue;

// synthesized sawtooth clip
enum SAWTOOTH_FRAMES = 8000;
static short[8000] sawtoothBuffer;

static void loadSawtooth()
{
    for(uint i =0; i < 8000; ++i)
        sawtoothBuffer[i] = cast(short)(15_000 - ((i%100) * 50));
}


// 5 seconds of recorded audio at 16 kHz mono, 16-bit signed little endian
enum RECORDER_FRAMES = (16000 * 5);
static short* recorderBuffer;
static uint recorderSize = 0;

// pointer and size of the next player buffer to enqueue, and number of remaining buffers
static short *nextBuffer;
static uint nextSize;
static int nextCount;

import core.stdc.stdlib;

void releaseResampleBuf() {
    if( 0 == bqPlayerSampleRate) {
        /*
         * we are not using fast path, so we were not creating buffers, nothing to do
         */
        return;
    }

    free(resampleBuf);
    resampleBuf = null;
}


// this callback handler is called every time a buffer finishes playing
extern(C)void bqPlayerCallback(SLAndroidSimpleBufferQueueItf bq, void *context)
{
    assert(bq == bqPlayerBufferQueue);
    // for streaming playback, replace this test by logic to find and fill the next buffer
    if (--nextCount > 0 && null != nextBuffer && 0 != nextSize) {
        SLresult result;
        // enqueue another buffer
        result = (*bqPlayerBufferQueue).Enqueue(bqPlayerBufferQueue, nextBuffer, nextSize);
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

bool isFinished = false;
extern(C) void playCallback(SLPlayItf p, void* context, SLuint32 events)
{
    if(events & SL_PLAYEVENT_HEADATEND)
    {
        isFinished = true;
    }
}

final class MainActivity : JavaClass!("com.hipreme.zenambience", MainActivity)
{
    @Export void createEngine()
    {
        SLresult result;

        // create engine
        result = slCreateEngine(&engineObject, 0, null, 0, null, null);
        assert(SL_RESULT_SUCCESS == result);
        

        // realize the engine
        result = (*engineObject).Realize(engineObject, SL_BOOLEAN_FALSE);
        assert(SL_RESULT_SUCCESS == result);
        

        // get the engine interface, which is needed in order to create other objects
        result = (*engineObject).GetInterface(engineObject, SL_IID_ENGINE, &engineEngine);
        assert(SL_RESULT_SUCCESS == result);
        

        // create output mix, with environmental reverb specified as a non-required interface
        const(SLInterfaceID)* ids = [SL_IID_ENVIRONMENTALREVERB].ptr;
        const(SLboolean)* req = [SL_BOOLEAN_FALSE].ptr;
        result = (*engineEngine).CreateOutputMix(engineEngine, &outputMixObject, 1, ids, req);
        assert(SL_RESULT_SUCCESS == result);
        

        // realize the output mix
        result = (*outputMixObject).Realize(outputMixObject, SL_BOOLEAN_FALSE);
        assert(SL_RESULT_SUCCESS == result);
        

        // get the environmental reverb interface
        // this could fail if the environmental reverb effect is not available,
        // either because the feature is not present, excessive CPU load, or
        // the required MODIFY_AUDIO_SETTINGS permission was not requested and granted
        result = (*outputMixObject).GetInterface(outputMixObject, SL_IID_ENVIRONMENTALREVERB,
                &outputMixEnvironmentalReverb);
        if (SL_RESULT_SUCCESS == result) {
            result = (*outputMixEnvironmentalReverb).SetEnvironmentalReverbProperties(
                    outputMixEnvironmentalReverb, &reverbSettings);
            
        }
        // ignore unsuccessful result codes for environmental reverb, as it is optional for this example

    }


    @Export void createBufferQueueAudioPlayer(int sampleRate, int bufSize)
    {
        SLresult result;
        if (sampleRate >= 0 && bufSize >= 0 ) {
            bqPlayerSampleRate = sampleRate * 1000;
            /*
            * device native buffer size is another factor to minimize audio latency, not used in this
            * sample: we only play one giant buffer here
            */
            bqPlayerBufSize = bufSize;
        }

        // configure audio source
        SLDataLocator_AndroidSimpleBufferQueue loc_bufq = {SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2};
        SLDataFormat_PCM format_pcm = {SL_DATAFORMAT_PCM, 1, SL_SAMPLINGRATE_8,
            SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
            SL_SPEAKER_FRONT_CENTER, SL_BYTEORDER_LITTLEENDIAN};
        /*
        * Enable Fast Audio when possible:  once we set the same rate to be the native, fast audio path
        * will be triggered
        */
        if(bqPlayerSampleRate) {
            format_pcm.samplesPerSec = bqPlayerSampleRate;       //sample rate in mili second
        }
        SLDataSource audioSrc = {&loc_bufq, &format_pcm};

        // configure audio sink
        SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, outputMixObject};
        SLDataSink audioSnk = {&loc_outmix, null};
        import log;
        import std.conv:to;
        /*
        * create audio player:
        *     fast audio does not support when SL_IID_EFFECTSEND is required, skip it
        *     for fast audio case
        */
        const SLInterfaceID* ids = [SL_IID_ANDROIDSIMPLEBUFFERQUEUE, SL_IID_VOLUME, SL_IID_EFFECTSEND,
                                        /*SL_IID_MUTESOLO,*/].ptr;
        const SLboolean* req = [SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE,
                                    /*SL_BOOLEAN_TRUE,*/ ].ptr;

        result = (*engineEngine).CreateAudioPlayer(engineEngine, &bqPlayerObject, &audioSrc, &audioSnk,
                3, ids, req);
        import opensles_utils;
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", slResultToString(result).ptr);
        assert(SL_RESULT_SUCCESS == result);


        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Created AudioPlayer".ptr);

        // realize the player
        result = (*bqPlayerObject).Realize(bqPlayerObject, SL_BOOLEAN_FALSE);
        assert(SL_RESULT_SUCCESS == result);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Initialize AudioPlayer".ptr);

        // get the play interface
        result = (*bqPlayerObject).GetInterface(bqPlayerObject, SL_IID_PLAY, &bqPlayerPlay);
        assert(SL_RESULT_SUCCESS == result);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Got Play interface".ptr);

        (*bqPlayerPlay).SetCallbackEventsMask(bqPlayerPlay,  SL_PLAYEVENT_HEADATEND);
        (*bqPlayerPlay).RegisterCallback(bqPlayerPlay, &playCallback, null);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "     callback on play".ptr);

        // get the buffer queue interface
        result = (*bqPlayerObject).GetInterface(bqPlayerObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
                &bqPlayerBufferQueue);
        assert(SL_RESULT_SUCCESS == result);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Got Android Simple BufferQueue Interface".ptr);

        // register callback on the buffer queue

        // result = (*bqPlayerPlay).RegisterCallback(bqPlayerBufferQueue, &bqPlayerCallback, null);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Registered callback on buffer queue".ptr);
        assert(SL_RESULT_SUCCESS == result);

        // get the effect send interface
        bqPlayerEffectSend = null;
        if( 0 == bqPlayerSampleRate) {
            result = (*bqPlayerObject).GetInterface(bqPlayerObject, SL_IID_EFFECTSEND,
                                                    &bqPlayerEffectSend);
            assert(SL_RESULT_SUCCESS == result);
        }
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Got effect send interface".ptr);

        static if(0)
        {
            // mute/solo is not supported for sources that are known to be mono, as this is
            // get the mute/solo interface
            result = (*bqPlayerObject).GetInterface(bqPlayerObject, SL_IID_MUTESOLO, &bqPlayerMuteSolo);
            assert(SL_RESULT_SUCCESS == result);
        }

        // get the volume interface
        result = (*bqPlayerObject).GetInterface(bqPlayerObject, SL_IID_VOLUME, &bqPlayerVolume);
        assert(SL_RESULT_SUCCESS == result);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Got the volume interface".ptr);

        // set the player's state to playing

        loadSawtooth();
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", to!string(sawtoothBuffer[7999]).ptr);
        (*bqPlayerBufferQueue).Enqueue(bqPlayerBufferQueue, sawtoothBuffer.ptr, SAWTOOTH_FRAMES);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Enqueued sound".ptr);
        result = (*bqPlayerPlay).SetPlayState(bqPlayerPlay, SL_PLAYSTATE_PLAYING);
        __android_log_print(android_LogPriority.ANDROID_LOG_ERROR, "SLES", "Playing sound".ptr);
        assert(SL_RESULT_SUCCESS == result);
    }

}