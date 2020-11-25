module bindbc.OpenSLES.android;
/*
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "OpenSLES.h"
#include "OpenSLES_AndroidConfiguration.h"
#include "OpenSLES_AndroidMetadata.h"
#include <jni.h>

/*---------------------------------------------------------------------------*/
/* Android common types                                                      */
/*---------------------------------------------------------------------------*/

alias SLAint64 = sl_int64_t;          /* 64 bit signed integer   */

alias SLAuint64 = sl_uint64_t;         /* 64 bit unsigned integer */

/*---------------------------------------------------------------------------*/
/* Android PCM Data Format                                                   */
/*---------------------------------------------------------------------------*/

/* The following pcm representations and data formats map to those in OpenSLES 1.1 */
enum SL_ANDROID_PCM_REPRESENTATION_SIGNED_INT   =      (cast(SLuint32) 0x00000001);
enum SL_ANDROID_PCM_REPRESENTATION_UNSIGNED_INT =      (cast(SLuint32) 0x00000002);
enum SL_ANDROID_PCM_REPRESENTATION_FLOAT        =      (cast(SLuint32) 0x00000003);

enum SL_ANDROID_DATAFORMAT_PCM_EX               =     (cast(SLuint32) 0x00000004);

struct SLAndroidDataFormat_PCM_EX {
    SLuint32         formatType;
    SLuint32         numChannels;
    SLuint32         sampleRate;
    SLuint32         bitsPerSample;
    SLuint32         containerSize;
    SLuint32         channelMask;
    SLuint32         endianness;
    SLuint32         representation;
}

enum SL_ANDROID_SPEAKER_NON_POSITIONAL =       (cast(SLuint32) 0x80000000);

// Make an indexed channel mask from a bitfield.
//
// Each bit in the bitfield corresponds to a channel index,
// from least-significant bit (channel 0) up to the bit
// corresponding to the maximum channel count (currently FCC_8).
// A '1' in the bitfield indicates that the channel should be
// included in the stream, while a '0' indicates that it
// should be excluded. For instance, a bitfield of 0x0A (binary 00001010)
// would define a stream that contains channels 1 and 3. (The corresponding
// indexed mask, after setting the SL_ANDROID_NON_POSITIONAL bit,
// would be 0x8000000A.)
enum SL_ANDROID_MAKE_INDEXED_CHANNEL_MASK(bitfield)
{
    return ((bitfield) | SL_ANDROID_SPEAKER_NON_POSITIONAL);
}

// Specifying SL_ANDROID_SPEAKER_USE_DEFAULT as a channel mask in
// SLAndroidDataFormat_PCM_EX causes OpenSL ES to assign a default
// channel mask based on the number of channels requested. This
// value cannot be combined with SL_ANDROID_SPEAKER_NON_POSITIONAL.
enum SL_ANDROID_SPEAKER_USE_DEFAULT =  (cast(SLuint32)0);

/*---------------------------------------------------------------------------*/
/* Android Effect interface                                                  */
/*---------------------------------------------------------------------------*/

const SLInterfaceID SL_IID_ANDROIDEFFECT;

/** Android Effect interface methods */

struct SLAndroidEffectItf_;
alias SLAndroidEffectItf = SLAndroidEffectItf_*;

struct SLAndroidEffectItf_ {

    SLresult function(SLAndroidEffectItf self, SLInterfaceID effectImplementationId) CreateEffect;
    SLresult function (SLAndroidEffectItf self,SLInterfaceID effectImplementationId) ReleaseEffect;
    SLresult function (SLAndroidEffectItf self, SLInterfaceID effectImplementationId, SLboolean enabled) SetEnabled;

    SLresult function (SLAndroidEffectItf self,
            SLInterfaceID effectImplementationId,
            SLboolean *pEnabled) IsEnabled;

    SLresult function (SLAndroidEffectItf self,
            SLInterfaceID effectImplementationId,
            SLuint32 command,
            SLuint32 commandSize,
            void *pCommandData,
            SLuint32 *replySize,
            void *pReplyData) SendCommand;
};


/*---------------------------------------------------------------------------*/
/* Android Effect Send interface                                             */
/*---------------------------------------------------------------------------*/

const SLInterfaceID SL_IID_ANDROIDEFFECTSEND;

/** Android Effect Send interface methods */

struct SLAndroidEffectSendItf_;
alias SLAndroidEffectSendItf = SLAndroidEffectSendItf_*;

struct SLAndroidEffectSendItf_ {
    SLresult function(
        SLAndroidEffectSendItf self,
        SLInterfaceID effectImplementationId,
        SLboolean enable,
        SLmillibel initialLevel
    ) EnableEffectSend;
    SLresult function (
        SLAndroidEffectSendItf self,
        SLInterfaceID effectImplementationId,
        SLboolean *pEnable
    ) IsEnabled;
    SLresult function (
        SLAndroidEffectSendItf self,
        SLmillibel directLevel
    ) SetDirectLevel;
    SLresult function (
        SLAndroidEffectSendItf self,
        SLmillibel *pDirectLevel
    ) GetDirectLevel;
    SLresult function (
        SLAndroidEffectSendItf self,
        SLInterfaceID effectImplementationId,
        SLmillibel sendLevel
    ) SetSendLevel;
    SLresult function (
        SLAndroidEffectSendItf self,
        SLInterfaceID effectImplementationId,
        SLmillibel *pSendLevel
    ) GetSendLevel;
}


/*---------------------------------------------------------------------------*/
/* Android Effect Capabilities interface                                     */
/*---------------------------------------------------------------------------*/

const SLInterfaceID SL_IID_ANDROIDEFFECTCAPABILITIES;

/** Android Effect Capabilities interface methods */

struct SLAndroidEffectCapabilitiesItf_;
alias SLAndroidEffectCapabilitiesItf = SLAndroidEffectCapabilitiesItf_*;

struct SLAndroidEffectCapabilitiesItf_ {

    SLresult function (SLAndroidEffectCapabilitiesItf self,
            SLuint32 *pNumSupportedEffects) QueryNumEffects;


    SLresult function (SLAndroidEffectCapabilitiesItf self,
            SLuint32 index,
            SLInterfaceID *pEffectType,
            SLInterfaceID *pEffectImplementation,
            SLchar *pName,
            SLuint16 *pNameSize) QueryEffect;
}


/*---------------------------------------------------------------------------*/
/* Android Configuration interface                                           */
/*---------------------------------------------------------------------------*/
const SLInterfaceID SL_IID_ANDROIDCONFIGURATION;

/** Android Configuration interface methods */

struct SLAndroidConfigurationItf_;
alias SLAndroidConfigurationItf = SLAndroidConfigurationItf_*;

/*
 * Java Proxy Type IDs
 */
enum SL_ANDROID_JAVA_PROXY_ROUTING = 0x0001;

struct SLAndroidConfigurationItf_ {

    SLresult function (SLAndroidConfigurationItf self,
            const SLchar *configKey,
            const void *pConfigValue,
            SLuint32 valueSize) SetConfiguration;

    SLresult function (SLAndroidConfigurationItf self,
           const SLchar *configKey,
           SLuint32 *pValueSize,
           void *pConfigValue
       ) GetConfiguration;

    SLresult function (SLAndroidConfigurationItf self,
            SLuint32 proxyType,
            jobject *pProxyObj) AcquireJavaProxy;

    SLresult function (SLAndroidConfigurationItf self,
            SLuint32 proxyType) ReleaseJavaProxy;
}


/*---------------------------------------------------------------------------*/
/* Android Simple Buffer Queue Interface                                     */
/*---------------------------------------------------------------------------*/

const SLInterfaceID SL_IID_ANDROIDSIMPLEBUFFERQUEUE;

struct SLAndroidSimpleBufferQueueItf_;
alias SLAndroidSimpleBufferQueueItf = SLAndroidSimpleBufferQueueItf_*;
alias /*SLAPIENTRY*/slAndroidSimpleBufferQueueCallback = void function(SLAndroidSimpleBufferQueueItf caller, void* pContext);

/** Android simple buffer queue state **/
struct SLAndroidSimpleBufferQueueState {
	SLuint32	count;
	SLuint32	index;
}


struct SLAndroidSimpleBufferQueueItf_ {
	SLresult function (
		SLAndroidSimpleBufferQueueItf self,
		const void *pBuffer,
		SLuint32 size
	) Enqueue;
	SLresult function (
		SLAndroidSimpleBufferQueueItf self
	) Clear;
	SLresult function (
		SLAndroidSimpleBufferQueueItf self,
		SLAndroidSimpleBufferQueueState *pState
	) GetState;
	SLresult function (
		SLAndroidSimpleBufferQueueItf self,
		slAndroidSimpleBufferQueueCallback callback,
		void* pContext
	) RegisterCallback;
}


/*---------------------------------------------------------------------------*/
/* Android Buffer Queue Interface                                            */
/*---------------------------------------------------------------------------*/

const SLInterfaceID SL_IID_ANDROIDBUFFERQUEUESOURCE;

struct SLAndroidBufferQueueItf_;
alias SLAndroidBufferQueueItf = SLAndroidBufferQueueItf_*;

enum SL_ANDROID_ITEMKEY_NONE              = (cast(SLuint32) 0x00000000);
enum SL_ANDROID_ITEMKEY_EOS               = (cast(SLuint32) 0x00000001);
enum SL_ANDROID_ITEMKEY_DISCONTINUITY     = (cast(SLuint32) 0x00000002);
enum SL_ANDROID_ITEMKEY_BUFFERQUEUEEVENT  = (cast(SLuint32) 0x00000003);
enum SL_ANDROID_ITEMKEY_FORMAT_CHANGE     = (cast(SLuint32) 0x00000004);

enum SL_ANDROIDBUFFERQUEUEEVENT_NONE         = (cast(SLuint32) 0x00000000);
enum SL_ANDROIDBUFFERQUEUEEVENT_PROCESSED    = (cast(SLuint32) 0x00000001);
static if(0) // reserved for future use
{
    enum SL_ANDROIDBUFFERQUEUEEVENT_UNREALIZED   = (cast(SLuint32) 0x00000002);
    enum SL_ANDROIDBUFFERQUEUEEVENT_CLEARED      = (cast(SLuint32) 0x00000004);
    enum SL_ANDROIDBUFFERQUEUEEVENT_STOPPED      = (cast(SLuint32) 0x00000008);
    enum SL_ANDROIDBUFFERQUEUEEVENT_ERROR        = (cast(SLuint32) 0x00000010);
    enum SL_ANDROIDBUFFERQUEUEEVENT_CONTENT_END  = (cast(SLuint32) 0x00000020);
}   

struct SLAndroidBufferItem {
    SLuint32 itemKey;  // identifies the item
    SLuint32 itemSize;
    SLuint8  itemData[0];
}

alias /*SLAPIENTRY*/ slAndroidBufferQueueCallback = SLresult function(
    SLAndroidBufferQueueItf caller,/* input */
    void *pCallbackContext,        /* input */
    void *pBufferContext,          /* input */
    void *pBufferData,             /* input */
    SLuint32 dataSize,             /* input */
    SLuint32 dataUsed,             /* input */
    const SLAndroidBufferItem *pItems,/* input */
    SLuint32 itemsLength           /* input */
);

struct SLAndroidBufferQueueState {
    SLuint32    count;
    SLuint32    index;
}

struct SLAndroidBufferQueueItf_ {
    SLresult function (
        SLAndroidBufferQueueItf self,
        slAndroidBufferQueueCallback callback,
        void* pCallbackContext
    ) RegisterCallback;

    SLresult function (
        SLAndroidBufferQueueItf self
    ) Clear;

    SLresult function (
        SLAndroidBufferQueueItf self,
        void *pBufferContext,
        void *pData,
        SLuint32 dataLength,
        const SLAndroidBufferItem *pItems,
        SLuint32 itemsLength
    ) Enqueue;

    SLresult function (
        SLAndroidBufferQueueItf self,
        SLAndroidBufferQueueState *pState
    ) GetState;

    SLresult function (
            SLAndroidBufferQueueItf self,
            SLuint32 eventFlags
    ) SetCallbackEventsMask;

    SLresult function (
            SLAndroidBufferQueueItf self,
            SLuint32 *pEventFlags
    ) GetCallbackEventsMask;
}


/*---------------------------------------------------------------------------*/
/* Android File Descriptor Data Locator                                      */
/*---------------------------------------------------------------------------*/

/** Addendum to Data locator macros  */
enum SL_DATALOCATOR_ANDROIDFD =                (cast(SLuint32) 0x800007BC);

/**long long value*/
enum SL_DATALOCATOR_ANDROIDFD_USE_FILE_SIZE = (cast(SLAint64) 0xFFFFFFFFFFFFFFFF);

/** File Descriptor-based data locator definition, locatorType must be SL_DATALOCATOR_ANDROIDFD */
struct SLDataLocator_AndroidFD {
    SLuint32        locatorType;
    SLint32         fd;
    SLAint64        offset;
    SLAint64        length;
}


/*---------------------------------------------------------------------------*/
/* Android Android Simple Buffer Queue Data Locator                          */
/*---------------------------------------------------------------------------*/

/** Addendum to Data locator macros  */
enum SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE = (cast(SLuint32) 0x800007BD);

/** BufferQueue-based data locator definition where locatorType must
 *  be SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE
 */
struct SLDataLocator_AndroidSimpleBufferQueue {
	SLuint32	locatorType;
	SLuint32	numBuffers;
}


/*---------------------------------------------------------------------------*/
/* Android Buffer Queue Data Locator                                         */
/*---------------------------------------------------------------------------*/

/** Addendum to Data locator macros  */
#define SL_DATALOCATOR_ANDROIDBUFFERQUEUE       ((SLuint32) 0x800007BE)

/** Android Buffer Queue-based data locator definition,
 *  locatorType must be SL_DATALOCATOR_ANDROIDBUFFERQUEUE */
typedef struct SLDataLocator_AndroidBufferQueue_ {
    SLuint32    locatorType;
    SLuint32    numBuffers;
} SLDataLocator_AndroidBufferQueue;

/**
 * MIME types required for data in Android Buffer Queues
 */
#define SL_ANDROID_MIME_AACADTS            ((SLchar *) "audio/vnd.android.aac-adts")

/*---------------------------------------------------------------------------*/
/* Acoustic Echo Cancellation (AEC) Interface                                */
/* --------------------------------------------------------------------------*/
extern SL_API const SLInterfaceID SL_IID_ANDROIDACOUSTICECHOCANCELLATION;

struct SLAndroidAcousticEchoCancellationItf_;
typedef const struct SLAndroidAcousticEchoCancellationItf_ * const *
        SLAndroidAcousticEchoCancellationItf;

struct SLAndroidAcousticEchoCancellationItf_ {
    SLresult (*SetEnabled)(
        SLAndroidAcousticEchoCancellationItf self,
        SLboolean enabled
    );
    SLresult (*IsEnabled)(
        SLAndroidAcousticEchoCancellationItf self,
        SLboolean *pEnabled
    );
};

/*---------------------------------------------------------------------------*/
/* Automatic Gain Control (ACC) Interface                                    */
/* --------------------------------------------------------------------------*/
extern SL_API const SLInterfaceID SL_IID_ANDROIDAUTOMATICGAINCONTROL;

struct SLAndroidAutomaticGainControlItf_;
typedef const struct SLAndroidAutomaticGainControlItf_ * const * SLAndroidAutomaticGainControlItf;

struct SLAndroidAutomaticGainControlItf_ {
    SLresult (*SetEnabled)(
        SLAndroidAutomaticGainControlItf self,
        SLboolean enabled
    );
    SLresult (*IsEnabled)(
        SLAndroidAutomaticGainControlItf self,
        SLboolean *pEnabled
    );
};

/*---------------------------------------------------------------------------*/
/* Noise Suppression Interface                                               */
/* --------------------------------------------------------------------------*/
extern SL_API const SLInterfaceID SL_IID_ANDROIDNOISESUPPRESSION;

struct SLAndroidNoiseSuppressionItf_;
typedef const struct SLAndroidNoiseSuppressionItf_ * const * SLAndroidNoiseSuppressionItf;

struct SLAndroidNoiseSuppressionItf_ {
    SLresult (*SetEnabled)(
        SLAndroidNoiseSuppressionItf self,
        SLboolean enabled
    );
    SLresult (*IsEnabled)(
        SLAndroidNoiseSuppressionItf self,
        SLboolean *pEnabled
    );
};