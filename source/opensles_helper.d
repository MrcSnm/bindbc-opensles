module opensles_helper;

/** Current OpenSL ES Version*/
immutable SLESVersion = "1.0.1";

/**
* Is feature compatible with...
*/
struct SLESCompatibility
{
    ///Feature compatible with AudioPlayer
    immutable bool AudioPlayer;
    ///Feature compatible with AudioRecorder
    immutable bool AudioRecorder;
    ///Feature compatible with Engine
    immutable bool Engine;
    ///Feature compatible with OutputMix
    immutable bool OutputMix;
}

/**
*   Documentation for permissions needed on android side when using SLES
*/
enum SLESAndroidRequiredPermissions
{
    ///When using any kind of output mix effect
    MODIFY_AUDIO_SETTINGS = `<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>`,
    ///When messing with AudioRecorder
    RECORD_AUDIO = `<uses-permission android:name="android.permission.RECORD_AUDIO"/>`
}

/**
*   Immutable table on how is compatibility at Android, keeping that only as a reference.
*/
enum Android_NDK_Compatibility : SLESCompatibility
{
    //                                            Player  Rec   Engine Output
    BassBoost                  = SLESCompatibility(true, false, false, true),
    BufferQueue                = SLESCompatibility(true, false, false, false),
    BufferQueueDataLocator     = SLESCompatibility(true, false, false, false), //Source
    DynamicInterfaceManagement = SLESCompatibility(true, true, true, true),
    EffectSend                 = SLESCompatibility(true, false, false, false),
    Engine                     = SLESCompatibility(false, false, true, false),
    EnvironmentalReverb        = SLESCompatibility(false, false, false, true),
    Equalize                   = SLESCompatibility(true, false, false, true),
    IODeviceDataLocator        = SLESCompatibility(false, true, false, false),
    MetadataExtraction         = SLESCompatibility(true, false, false, false),
    MuteSolo                   = SLESCompatibility(true, false, false, false),
    OObject                    = SLESCompatibility(true, true, true, true),
    OutputMixLocator           = SLESCompatibility(true, false, false, false), //Sink
    Play                       = SLESCompatibility(true, false, false, false),
    PlaybackRate               = SLESCompatibility(true, false, false, false),
    PrefetchStatus             = SLESCompatibility(true, false, false, false),
    PresetReverb               = SLESCompatibility(false, false, false, true),
    Record                     = SLESCompatibility(false, true, false, false),
    Seek                       = SLESCompatibility(true, false, false, false),
    URIDataLocator             = SLESCompatibility(true, false, false, false), //Source
    Virtualizer                = SLESCompatibility(true, false, false, true),
    Volume                     = SLESCompatibility(true, false, false, false)
    //                                            Player  Rec   Engine Output
}
