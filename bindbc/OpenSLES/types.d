module bindbc.OpenSLES.types;



        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    alias sl_uint64_t = ulong;
    alias sl_int64_t = long;
    alias sl_int32_t = int;
    alias sl_uint32_t = uint;
    alias sl_int16_t = short;
    alias sl_uint16_t = ushort;
    alias sl_int8_t = byte;
    alias sl_uint8_t = ubyte;
    uint slQuerySupportedEngineInterfaces(uint, const(SLInterfaceID_)**) @nogc nothrow;
    uint slQueryNumSupportedEngineInterfaces(uint*) @nogc nothrow;
    uint slCreateEngine(const(const(SLObjectItf_)*)**, uint, const(SLEngineOption_)*, uint, const(const(SLInterfaceID_)*)*, const(uint)*) @nogc nothrow;
    struct SLEngineOption_
    {
        uint feature;
        uint data;
    }
    alias SLEngineOption = SLEngineOption_;
    alias SLThreadSyncItf = const(const(SLThreadSyncItf_)*)*;
    struct SLThreadSyncItf_
    {
        uint function(const(const(SLThreadSyncItf_)*)*) EnterCriticalSection;
        uint function(const(const(SLThreadSyncItf_)*)*) ExitCriticalSection;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_THREADSYNC;
    alias SLEngineCapabilitiesItf = const(const(SLEngineCapabilitiesItf_)*)*;
    struct SLEngineCapabilitiesItf_
    {
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, ushort*) QuerySupportedProfiles;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, ushort, short*, uint*, short*) QueryAvailableVoices;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, short*) QueryNumberOfMIDISynthesizers;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, short*, short*, short*) QueryAPIVersion;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, uint*, uint*, SLLEDDescriptor_*) QueryLEDCapabilities;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, uint*, uint*, SLVibraDescriptor_*) QueryVibraCapabilities;
        uint function(const(const(SLEngineCapabilitiesItf_)*)*, uint*) IsThreadSafe;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_ENGINECAPABILITIES;
    alias SLEngineItf = const(const(SLEngineItf_)*)*;
    struct SLEngineItf_
    {
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, uint, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateLEDDevice;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, uint, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateVibraDevice;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, SLDataSource_*, SLDataSink_*, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateAudioPlayer;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, SLDataSource_*, SLDataSink_*, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateAudioRecorder;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, SLDataSource_*, SLDataSource_*, SLDataSink_*, SLDataSink_*, SLDataSink_*, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateMidiPlayer;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateListener;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, uint, const(const(SLInterfaceID_)*)*, const(uint)*) Create3DGroup;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateOutputMix;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, SLDataSource_*, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateMetadataExtractor;
        uint function(const(const(SLEngineItf_)*)*, const(const(SLObjectItf_)*)**, void*, uint, uint, const(const(SLInterfaceID_)*)*, const(uint)*) CreateExtensionObject;
        uint function(const(const(SLEngineItf_)*)*, uint, uint*) QueryNumSupportedInterfaces;
        uint function(const(const(SLEngineItf_)*)*, uint, uint, const(SLInterfaceID_)**) QuerySupportedInterfaces;
        uint function(const(const(SLEngineItf_)*)*, uint*) QueryNumSupportedExtensions;
        uint function(const(const(SLEngineItf_)*)*, uint, ubyte*, short*) QuerySupportedExtension;
        uint function(const(const(SLEngineItf_)*)*, const(ubyte)*, uint*) IsExtensionSupported;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_ENGINE;
    alias slVisualizationCallback = void function(void*, const(ubyte)*, const(ubyte)*, uint);
    alias SLVisualizationItf = const(const(SLVisualizationItf_)*)*;
    struct SLVisualizationItf_
    {
        uint function(const(const(SLVisualizationItf_)*)*, void function(void*, const(ubyte)[0], const(ubyte)[0], uint), void*, uint) RegisterVisualizationCallback;
        uint function(const(const(SLVisualizationItf_)*)*, uint*) GetMaxRate;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_VISUALIZATION;
    alias SLVirtualizerItf = const(const(SLVirtualizerItf_)*)*;
    struct SLVirtualizerItf_
    {
        uint function(const(const(SLVirtualizerItf_)*)*, uint) SetEnabled;
        uint function(const(const(SLVirtualizerItf_)*)*, uint*) IsEnabled;
        uint function(const(const(SLVirtualizerItf_)*)*, short) SetStrength;
        uint function(const(const(SLVirtualizerItf_)*)*, short*) GetRoundedStrength;
        uint function(const(const(SLVirtualizerItf_)*)*, uint*) IsStrengthSupported;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_VIRTUALIZER;
    alias SLRatePitchItf = const(const(SLRatePitchItf_)*)*;
    struct SLRatePitchItf_
    {
        uint function(const(const(SLRatePitchItf_)*)*, short) SetRate;
        uint function(const(const(SLRatePitchItf_)*)*, short*) GetRate;
        uint function(const(const(SLRatePitchItf_)*)*, short*, short*) GetRatePitchCapabilities;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_RATEPITCH;
    alias SLPitchItf = const(const(SLPitchItf_)*)*;
    struct SLPitchItf_
    {
        uint function(const(const(SLPitchItf_)*)*, short) SetPitch;
        uint function(const(const(SLPitchItf_)*)*, short*) GetPitch;
        uint function(const(const(SLPitchItf_)*)*, short*, short*) GetPitchCapabilities;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_PITCH;
    alias SLBassBoostItf = const(const(SLBassBoostItf_)*)*;
    struct SLBassBoostItf_
    {
        uint function(const(const(SLBassBoostItf_)*)*, uint) SetEnabled;
        uint function(const(const(SLBassBoostItf_)*)*, uint*) IsEnabled;
        uint function(const(const(SLBassBoostItf_)*)*, short) SetStrength;
        uint function(const(const(SLBassBoostItf_)*)*, short*) GetRoundedStrength;
        uint function(const(const(SLBassBoostItf_)*)*, uint*) IsStrengthSupported;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_BASSBOOST;
    alias SLAudioEncoderItf = const(const(SLAudioEncoderItf_)*)*;
    struct SLAudioEncoderItf_
    {
        uint function(const(const(SLAudioEncoderItf_)*)*, SLAudioEncoderSettings_*) SetEncoderSettings;
        uint function(const(const(SLAudioEncoderItf_)*)*, SLAudioEncoderSettings_*) GetEncoderSettings;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_AUDIOENCODER;
    alias SLAudioEncoderCapabilitiesItf = const(const(SLAudioEncoderCapabilitiesItf_)*)*;
    struct SLAudioEncoderCapabilitiesItf_
    {
        uint function(const(const(SLAudioEncoderCapabilitiesItf_)*)*, uint*, uint*) GetAudioEncoders;
        uint function(const(const(SLAudioEncoderCapabilitiesItf_)*)*, uint, uint*, SLAudioCodecDescriptor_*) GetAudioEncoderCapabilities;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_AUDIOENCODERCAPABILITIES;
    struct SLAudioEncoderSettings_
    {
        uint encoderId;
        uint channelsIn;
        uint channelsOut;
        uint sampleRate;
        uint bitRate;
        uint bitsPerSample;
        uint rateControl;
        uint profileSetting;
        uint levelSetting;
        uint channelMode;
        uint streamFormat;
        uint encodeOptions;
        uint blockAlignment;
    }
    alias SLAudioEncoderSettings = SLAudioEncoderSettings_;
    alias SLAudioDecoderCapabilitiesItf = const(const(SLAudioDecoderCapabilitiesItf_)*)*;
    struct SLAudioDecoderCapabilitiesItf_
    {
        uint function(const(const(SLAudioDecoderCapabilitiesItf_)*)*, uint*, uint*) GetAudioDecoders;
        uint function(const(const(SLAudioDecoderCapabilitiesItf_)*)*, uint, uint*, SLAudioCodecDescriptor_*) GetAudioDecoderCapabilities;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_AUDIODECODERCAPABILITIES;
    struct SLAudioCodecProfileMode_
    {
        uint profileSetting;
        uint modeSetting;
    }
    alias SLAudioCodecProfileMode = SLAudioCodecProfileMode_;
    struct SLAudioCodecDescriptor_
    {
        uint maxChannels;
        uint minBitsPerSample;
        uint maxBitsPerSample;
        uint minSampleRate;
        uint maxSampleRate;
        uint isFreqRangeContinuous;
        uint* pSampleRatesSupported;
        uint numSampleRatesSupported;
        uint minBitRate;
        uint maxBitRate;
        uint isBitrateRangeContinuous;
        uint* pBitratesSupported;
        uint numBitratesSupported;
        uint profileSetting;
        uint modeSetting;
    }
    alias SLAudioCodecDescriptor = SLAudioCodecDescriptor_;
    alias SLMIDITimeItf = const(const(SLMIDITimeItf_)*)*;
    struct SLMIDITimeItf_
    {
        uint function(const(const(SLMIDITimeItf_)*)*, uint*) GetDuration;
        uint function(const(const(SLMIDITimeItf_)*)*, uint) SetPosition;
        uint function(const(const(SLMIDITimeItf_)*)*, uint*) GetPosition;
        uint function(const(const(SLMIDITimeItf_)*)*, uint, uint) SetLoopPoints;
        uint function(const(const(SLMIDITimeItf_)*)*, uint*, uint*) GetLoopPoints;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_MIDITIME;
    alias SLMIDITempoItf = const(const(SLMIDITempoItf_)*)*;
    struct SLMIDITempoItf_
    {
        uint function(const(const(SLMIDITempoItf_)*)*, uint) SetTicksPerQuarterNote;
        uint function(const(const(SLMIDITempoItf_)*)*, uint*) GetTicksPerQuarterNote;
        uint function(const(const(SLMIDITempoItf_)*)*, uint) SetMicrosecondsPerQuarterNote;
        uint function(const(const(SLMIDITempoItf_)*)*, uint*) GetMicrosecondsPerQuarterNote;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_MIDITEMPO;
    alias SLMIDIMuteSoloItf = const(const(SLMIDIMuteSoloItf_)*)*;
    struct SLMIDIMuteSoloItf_
    {
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ubyte, uint) SetChannelMute;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ubyte, uint*) GetChannelMute;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ubyte, uint) SetChannelSolo;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ubyte, uint*) GetChannelSolo;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ushort*) GetTrackCount;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ushort, uint) SetTrackMute;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ushort, uint*) GetTrackMute;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ushort, uint) SetTrackSolo;
        uint function(const(const(SLMIDIMuteSoloItf_)*)*, ushort, uint*) GetTrackSolo;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_MIDIMUTESOLO;
    alias slMIDIMessageCallback = void function(const(const(SLMIDIMessageItf_)*)*, void*, ubyte, uint, const(ubyte)*, uint, ushort);
    alias slMetaEventCallback = void function(const(const(SLMIDIMessageItf_)*)*, void*, ubyte, uint, const(ubyte)*, uint, ushort);
    alias SLMIDIMessageItf = const(const(SLMIDIMessageItf_)*)*;
    struct SLMIDIMessageItf_
    {
        uint function(const(const(SLMIDIMessageItf_)*)*, const(ubyte)*, uint) SendMessage;
        uint function(const(const(SLMIDIMessageItf_)*)*, void function(const(const(SLMIDIMessageItf_)*)*, void*, ubyte, uint, const(ubyte)*, uint, ushort), void*) RegisterMetaEventCallback;
        uint function(const(const(SLMIDIMessageItf_)*)*, void function(const(const(SLMIDIMessageItf_)*)*, void*, ubyte, uint, const(ubyte)*, uint, ushort), void*) RegisterMIDIMessageCallback;
        uint function(const(const(SLMIDIMessageItf_)*)*, uint) AddMIDIMessageCallbackFilter;
        uint function(const(const(SLMIDIMessageItf_)*)*) ClearMIDIMessageCallbackFilter;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_MIDIMESSAGE;
    alias slDynamicInterfaceManagementCallback = void function(const(const(SLDynamicInterfaceManagementItf_)*)*, void*, uint, uint, const(SLInterfaceID_)*);
    alias SLDynamicInterfaceManagementItf = const(const(SLDynamicInterfaceManagementItf_)*)*;
    struct SLDynamicInterfaceManagementItf_
    {
        uint function(const(const(SLDynamicInterfaceManagementItf_)*)*, const(const(SLInterfaceID_)*), uint) AddInterface;
        uint function(const(const(SLDynamicInterfaceManagementItf_)*)*, const(const(SLInterfaceID_)*)) RemoveInterface;
        uint function(const(const(SLDynamicInterfaceManagementItf_)*)*, const(const(SLInterfaceID_)*), uint) ResumeInterface;
        uint function(const(const(SLDynamicInterfaceManagementItf_)*)*, void function(const(const(SLDynamicInterfaceManagementItf_)*)*, void*, uint, uint, const(const(SLInterfaceID_)*)), void*) RegisterCallback;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_DYNAMICINTERFACEMANAGEMENT;
    alias SLMuteSoloItf = const(const(SLMuteSoloItf_)*)*;
    struct SLMuteSoloItf_
    {
        uint function(const(const(SLMuteSoloItf_)*)*, ubyte, uint) SetChannelMute;
        uint function(const(const(SLMuteSoloItf_)*)*, ubyte, uint*) GetChannelMute;
        uint function(const(const(SLMuteSoloItf_)*)*, ubyte, uint) SetChannelSolo;
        uint function(const(const(SLMuteSoloItf_)*)*, ubyte, uint*) GetChannelSolo;
        uint function(const(const(SLMuteSoloItf_)*)*, ubyte*) GetNumChannels;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_MUTESOLO;
    alias SL3DMacroscopicItf = const(const(SL3DMacroscopicItf_)*)*;
    struct SL3DMacroscopicItf_
    {
        uint function(const(const(SL3DMacroscopicItf_)*)*, int, int, int) SetSize;
        uint function(const(const(SL3DMacroscopicItf_)*)*, int*, int*, int*) GetSize;
        uint function(const(const(SL3DMacroscopicItf_)*)*, int, int, int) SetOrientationAngles;
        uint function(const(const(SL3DMacroscopicItf_)*)*, const(SLVec3D_)*, const(SLVec3D_)*) SetOrientationVectors;
        uint function(const(const(SL3DMacroscopicItf_)*)*, int, const(SLVec3D_)*) Rotate;
        uint function(const(const(SL3DMacroscopicItf_)*)*, SLVec3D_*, SLVec3D_*) GetOrientationVectors;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DMACROSCOPIC;
    alias SL3DSourceItf = const(const(SL3DSourceItf_)*)*;
    struct SL3DSourceItf_
    {
        uint function(const(const(SL3DSourceItf_)*)*, uint) SetHeadRelative;
        uint function(const(const(SL3DSourceItf_)*)*, uint*) GetHeadRelative;
        uint function(const(const(SL3DSourceItf_)*)*, int, int) SetRolloffDistances;
        uint function(const(const(SL3DSourceItf_)*)*, int*, int*) GetRolloffDistances;
        uint function(const(const(SL3DSourceItf_)*)*, uint) SetRolloffMaxDistanceMute;
        uint function(const(const(SL3DSourceItf_)*)*, uint*) GetRolloffMaxDistanceMute;
        uint function(const(const(SL3DSourceItf_)*)*, short) SetRolloffFactor;
        uint function(const(const(SL3DSourceItf_)*)*, short*) GetRolloffFactor;
        uint function(const(const(SL3DSourceItf_)*)*, short) SetRoomRolloffFactor;
        uint function(const(const(SL3DSourceItf_)*)*, short*) GetRoomRolloffFactor;
        uint function(const(const(SL3DSourceItf_)*)*, ubyte) SetRolloffModel;
        uint function(const(const(SL3DSourceItf_)*)*, ubyte*) GetRolloffModel;
        uint function(const(const(SL3DSourceItf_)*)*, int, int, short) SetCone;
        uint function(const(const(SL3DSourceItf_)*)*, int*, int*, short*) GetCone;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DSOURCE;
    alias SL3DDopplerItf = const(const(SL3DDopplerItf_)*)*;
    struct SL3DDopplerItf_
    {
        uint function(const(const(SL3DDopplerItf_)*)*, const(SLVec3D_)*) SetVelocityCartesian;
        uint function(const(const(SL3DDopplerItf_)*)*, int, int, int) SetVelocitySpherical;
        uint function(const(const(SL3DDopplerItf_)*)*, SLVec3D_*) GetVelocityCartesian;
        uint function(const(const(SL3DDopplerItf_)*)*, short) SetDopplerFactor;
        uint function(const(const(SL3DDopplerItf_)*)*, short*) GetDopplerFactor;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DDOPPLER;
    alias SL3DLocationItf = const(const(SL3DLocationItf_)*)*;
    struct SL3DLocationItf_
    {
        uint function(const(const(SL3DLocationItf_)*)*, const(SLVec3D_)*) SetLocationCartesian;
        uint function(const(const(SL3DLocationItf_)*)*, int, int, int) SetLocationSpherical;
        uint function(const(const(SL3DLocationItf_)*)*, const(SLVec3D_)*) Move;
        uint function(const(const(SL3DLocationItf_)*)*, SLVec3D_*) GetLocationCartesian;
        uint function(const(const(SL3DLocationItf_)*)*, const(SLVec3D_)*, const(SLVec3D_)*) SetOrientationVectors;
        uint function(const(const(SL3DLocationItf_)*)*, int, int, int) SetOrientationAngles;
        uint function(const(const(SL3DLocationItf_)*)*, int, const(SLVec3D_)*) Rotate;
        uint function(const(const(SL3DLocationItf_)*)*, SLVec3D_*, SLVec3D_*) GetOrientationVectors;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DLOCATION;
    struct SLVec3D_
    {
        int x;
        int y;
        int z;
    }
    alias SLVec3D = SLVec3D_;
    alias SL3DCommitItf = const(const(SL3DCommitItf_)*)*;
    struct SL3DCommitItf_
    {
        uint function(const(const(SL3DCommitItf_)*)*) Commit;
        uint function(const(const(SL3DCommitItf_)*)*, uint) SetDeferred;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DCOMMIT;
    alias SL3DGroupingItf = const(const(SL3DGroupingItf_)*)*;
    struct SL3DGroupingItf_
    {
        uint function(const(const(SL3DGroupingItf_)*)*, const(const(SLObjectItf_)*)*) Set3DGroup;
        uint function(const(const(SL3DGroupingItf_)*)*, const(const(SLObjectItf_)*)**) Get3DGroup;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_3DGROUPING;
    alias SLEffectSendItf = const(const(SLEffectSendItf_)*)*;
    struct SLEffectSendItf_
    {
        uint function(const(const(SLEffectSendItf_)*)*, const(void)*, uint, short) EnableEffectSend;
        uint function(const(const(SLEffectSendItf_)*)*, const(void)*, uint*) IsEnabled;
        uint function(const(const(SLEffectSendItf_)*)*, short) SetDirectLevel;
        uint function(const(const(SLEffectSendItf_)*)*, short*) GetDirectLevel;
        uint function(const(const(SLEffectSendItf_)*)*, const(void)*, short) SetSendLevel;
        uint function(const(const(SLEffectSendItf_)*)*, const(void)*, short*) GetSendLevel;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_EFFECTSEND;
    alias SLEnvironmentalReverbItf = const(const(SLEnvironmentalReverbItf_)*)*;
    struct SLEnvironmentalReverbItf_
    {
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetRoomLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetRoomLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetRoomHFLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetRoomHFLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint) SetDecayTime;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint*) GetDecayTime;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetDecayHFRatio;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetDecayHFRatio;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetReflectionsLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetReflectionsLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint) SetReflectionsDelay;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint*) GetReflectionsDelay;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetReverbLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetReverbLevel;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint) SetReverbDelay;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, uint*) GetReverbDelay;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetDiffusion;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetDiffusion;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short) SetDensity;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, short*) GetDensity;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, const(SLEnvironmentalReverbSettings_)*) SetEnvironmentalReverbProperties;
        uint function(const(const(SLEnvironmentalReverbItf_)*)*, SLEnvironmentalReverbSettings_*) GetEnvironmentalReverbProperties;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_ENVIRONMENTALREVERB;
    struct SLEnvironmentalReverbSettings_
    {
        short roomLevel;
        short roomHFLevel;
        uint decayTime;
        short decayHFRatio;
        short reflectionsLevel;
        uint reflectionsDelay;
        short reverbLevel;
        uint reverbDelay;
        short diffusion;
        short density;
    }
    alias SLEnvironmentalReverbSettings = SLEnvironmentalReverbSettings_;
    alias SLPresetReverbItf = const(const(SLPresetReverbItf_)*)*;
    struct SLPresetReverbItf_
    {
        uint function(const(const(SLPresetReverbItf_)*)*, ushort) SetPreset;
        uint function(const(const(SLPresetReverbItf_)*)*, ushort*) GetPreset;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_PRESETREVERB;
    struct SLBufferQueueState_
    {
        uint count;
        uint playIndex;
    }
    alias SLBufferQueueState = SLBufferQueueState_;
    alias slBufferQueueCallback = void function(const(const(SLBufferQueueItf_)*)*, void*);
    alias SLBufferQueueItf = const(const(SLBufferQueueItf_)*)*;
    struct SLBufferQueueItf_
    {
        uint function(const(const(SLBufferQueueItf_)*)*, const(void)*, uint) Enqueue;
        uint function(const(const(SLBufferQueueItf_)*)*) Clear;
        uint function(const(const(SLBufferQueueItf_)*)*, SLBufferQueueState_*) GetState;
        uint function(const(const(SLBufferQueueItf_)*)*, void function(const(const(SLBufferQueueItf_)*)*, void*), void*) RegisterCallback;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_BUFFERQUEUE;
    alias SLDeviceVolumeItf = const(const(SLDeviceVolumeItf_)*)*;
    struct SLDeviceVolumeItf_
    {
        uint function(const(const(SLDeviceVolumeItf_)*)*, uint, int*, int*, uint*) GetVolumeScale;
        uint function(const(const(SLDeviceVolumeItf_)*)*, uint, int) SetVolume;
        uint function(const(const(SLDeviceVolumeItf_)*)*, uint, int*) GetVolume;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_DEVICEVOLUME;
    alias SLVolumeItf = const(const(SLVolumeItf_)*)*;
    struct SLVolumeItf_
    {
        uint function(const(const(SLVolumeItf_)*)*, short) SetVolumeLevel;
        uint function(const(const(SLVolumeItf_)*)*, short*) GetVolumeLevel;
        uint function(const(const(SLVolumeItf_)*)*, short*) GetMaxVolumeLevel;
        uint function(const(const(SLVolumeItf_)*)*, uint) SetMute;
        uint function(const(const(SLVolumeItf_)*)*, uint*) GetMute;
        uint function(const(const(SLVolumeItf_)*)*, uint) EnableStereoPosition;
        uint function(const(const(SLVolumeItf_)*)*, uint*) IsEnabledStereoPosition;
        uint function(const(const(SLVolumeItf_)*)*, short) SetStereoPosition;
        uint function(const(const(SLVolumeItf_)*)*, short*) GetStereoPosition;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_VOLUME;
    alias SLEqualizerItf = const(const(SLEqualizerItf_)*)*;
    struct SLEqualizerItf_
    {
        uint function(const(const(SLEqualizerItf_)*)*, uint) SetEnabled;
        uint function(const(const(SLEqualizerItf_)*)*, uint*) IsEnabled;
        uint function(const(const(SLEqualizerItf_)*)*, ushort*) GetNumberOfBands;
        uint function(const(const(SLEqualizerItf_)*)*, short*, short*) GetBandLevelRange;
        uint function(const(const(SLEqualizerItf_)*)*, ushort, short) SetBandLevel;
        uint function(const(const(SLEqualizerItf_)*)*, ushort, short*) GetBandLevel;
        uint function(const(const(SLEqualizerItf_)*)*, ushort, uint*) GetCenterFreq;
        uint function(const(const(SLEqualizerItf_)*)*, ushort, uint*, uint*) GetBandFreqRange;
        uint function(const(const(SLEqualizerItf_)*)*, uint, ushort*) GetBand;
        uint function(const(const(SLEqualizerItf_)*)*, ushort*) GetCurrentPreset;
        uint function(const(const(SLEqualizerItf_)*)*, ushort) UsePreset;
        uint function(const(const(SLEqualizerItf_)*)*, ushort*) GetNumberOfPresets;
        uint function(const(const(SLEqualizerItf_)*)*, ushort, const(ubyte)**) GetPresetName;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_EQUALIZER;
    alias slRecordCallback = void function(const(const(SLRecordItf_)*)*, void*, uint);
    alias SLRecordItf = const(const(SLRecordItf_)*)*;
    struct SLRecordItf_
    {
        uint function(const(const(SLRecordItf_)*)*, uint) SetRecordState;
        uint function(const(const(SLRecordItf_)*)*, uint*) GetRecordState;
        uint function(const(const(SLRecordItf_)*)*, uint) SetDurationLimit;
        uint function(const(const(SLRecordItf_)*)*, uint*) GetPosition;
        uint function(const(const(SLRecordItf_)*)*, void function(const(const(SLRecordItf_)*)*, void*, uint), void*) RegisterCallback;
        uint function(const(const(SLRecordItf_)*)*, uint) SetCallbackEventsMask;
        uint function(const(const(SLRecordItf_)*)*, uint*) GetCallbackEventsMask;
        uint function(const(const(SLRecordItf_)*)*, uint) SetMarkerPosition;
        uint function(const(const(SLRecordItf_)*)*) ClearMarkerPosition;
        uint function(const(const(SLRecordItf_)*)*, uint*) GetMarkerPosition;
        uint function(const(const(SLRecordItf_)*)*, uint) SetPositionUpdatePeriod;
        uint function(const(const(SLRecordItf_)*)*, uint*) GetPositionUpdatePeriod;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_RECORD;
    alias SLSeekItf = const(const(SLSeekItf_)*)*;
    struct SLSeekItf_
    {
        uint function(const(const(SLSeekItf_)*)*, uint, uint) SetPosition;
        uint function(const(const(SLSeekItf_)*)*, uint, uint, uint) SetLoop;
        uint function(const(const(SLSeekItf_)*)*, uint*, uint*, uint*) GetLoop;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_SEEK;
    alias SLPlaybackRateItf = const(const(SLPlaybackRateItf_)*)*;
    struct SLPlaybackRateItf_
    {
        uint function(const(const(SLPlaybackRateItf_)*)*, short) SetRate;
        uint function(const(const(SLPlaybackRateItf_)*)*, short*) GetRate;
        uint function(const(const(SLPlaybackRateItf_)*)*, uint) SetPropertyConstraints;
        uint function(const(const(SLPlaybackRateItf_)*)*, uint*) GetProperties;
        uint function(const(const(SLPlaybackRateItf_)*)*, short, uint*) GetCapabilitiesOfRate;
        uint function(const(const(SLPlaybackRateItf_)*)*, ubyte, short*, short*, short*, uint*) GetRateRange;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_PLAYBACKRATE;
    alias slPrefetchCallback = void function(const(const(SLPrefetchStatusItf_)*)*, void*, uint);
    alias SLPrefetchStatusItf = const(const(SLPrefetchStatusItf_)*)*;
    struct SLPrefetchStatusItf_
    {
        uint function(const(const(SLPrefetchStatusItf_)*)*, uint*) GetPrefetchStatus;
        uint function(const(const(SLPrefetchStatusItf_)*)*, short*) GetFillLevel;
        uint function(const(const(SLPrefetchStatusItf_)*)*, void function(const(const(SLPrefetchStatusItf_)*)*, void*, uint), void*) RegisterCallback;
        uint function(const(const(SLPrefetchStatusItf_)*)*, uint) SetCallbackEventsMask;
        uint function(const(const(SLPrefetchStatusItf_)*)*, uint*) GetCallbackEventsMask;
        uint function(const(const(SLPrefetchStatusItf_)*)*, short) SetFillUpdatePeriod;
        uint function(const(const(SLPrefetchStatusItf_)*)*, short*) GetFillUpdatePeriod;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_PREFETCHSTATUS;
    alias slPlayCallback = void function(const(const(SLPlayItf_)*)*, void*, uint);
    alias SLPlayItf = const(const(SLPlayItf_)*)*;
    struct SLPlayItf_
    {
        uint function(const(const(SLPlayItf_)*)*, uint) SetPlayState;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetPlayState;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetDuration;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetPosition;
        uint function(const(const(SLPlayItf_)*)*, void function(const(const(SLPlayItf_)*)*, void*, uint), void*) RegisterCallback;
        uint function(const(const(SLPlayItf_)*)*, uint) SetCallbackEventsMask;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetCallbackEventsMask;
        uint function(const(const(SLPlayItf_)*)*, uint) SetMarkerPosition;
        uint function(const(const(SLPlayItf_)*)*) ClearMarkerPosition;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetMarkerPosition;
        uint function(const(const(SLPlayItf_)*)*, uint) SetPositionUpdatePeriod;
        uint function(const(const(SLPlayItf_)*)*, uint*) GetPositionUpdatePeriod;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_PLAY;
    alias slMixDeviceChangeCallback = void function(const(const(SLOutputMixItf_)*)*, void*);
    alias SLOutputMixItf = const(const(SLOutputMixItf_)*)*;
    struct SLOutputMixItf_
    {
        uint function(const(const(SLOutputMixItf_)*)*, int*, uint*) GetDestinationOutputDeviceIDs;
        uint function(const(const(SLOutputMixItf_)*)*, void function(const(const(SLOutputMixItf_)*)*, void*), void*) RegisterDeviceChangeCallback;
        uint function(const(const(SLOutputMixItf_)*)*, int, uint*) ReRoute;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_OUTPUTMIX;
    alias SLDynamicSourceItf = const(const(SLDynamicSourceItf_)*)*;
    struct SLDynamicSourceItf_
    {
        uint function(const(const(SLDynamicSourceItf_)*)*, SLDataSource_*) SetSource;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_DYNAMICSOURCE;
    alias SLMetadataTraversalItf = const(const(SLMetadataTraversalItf_)*)*;
    struct SLMetadataTraversalItf_
    {
        uint function(const(const(SLMetadataTraversalItf_)*)*, uint) SetMode;
        uint function(const(const(SLMetadataTraversalItf_)*)*, uint*) GetChildCount;
        uint function(const(const(SLMetadataTraversalItf_)*)*, uint, uint*) GetChildMIMETypeSize;
        uint function(const(const(SLMetadataTraversalItf_)*)*, uint, int*, uint*, uint, ubyte*) GetChildInfo;
        uint function(const(const(SLMetadataTraversalItf_)*)*, uint) SetActiveNode;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_METADATATRAVERSAL;
    alias SLMetadataExtractionItf = const(const(SLMetadataExtractionItf_)*)*;
    struct SLMetadataExtractionItf_
    {
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint*) GetItemCount;
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint, uint*) GetKeySize;
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint, uint, SLMetadataInfo_*) GetKey;
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint, uint*) GetValueSize;
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint, uint, SLMetadataInfo_*) GetValue;
        uint function(const(const(SLMetadataExtractionItf_)*)*, uint, const(void)*, uint, const(ubyte)*, uint, ubyte) AddKeyFilter;
        uint function(const(const(SLMetadataExtractionItf_)*)*) ClearKeyFilter;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_METADATAEXTRACTION;
    struct SLMetadataInfo_
    {
        uint size;
        uint encoding;
        ubyte[16] langCountry;
        ubyte[1] data;
    }
    alias SLMetadataInfo = SLMetadataInfo_;
    alias SLVibraItf = const(const(SLVibraItf_)*)*;
    struct SLVibraItf_
    {
        uint function(const(const(SLVibraItf_)*)*, uint) Vibrate;
        uint function(const(const(SLVibraItf_)*)*, uint*) IsVibrating;
        uint function(const(const(SLVibraItf_)*)*, uint) SetFrequency;
        uint function(const(const(SLVibraItf_)*)*, uint*) GetFrequency;
        uint function(const(const(SLVibraItf_)*)*, short) SetIntensity;
        uint function(const(const(SLVibraItf_)*)*, short*) GetIntensity;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_VIBRA;
    struct SLVibraDescriptor_
    {
        uint supportsFrequency;
        uint supportsIntensity;
        uint minFrequency;
        uint maxFrequency;
    }
    alias SLVibraDescriptor = SLVibraDescriptor_;
    alias SLLEDArrayItf = const(const(SLLEDArrayItf_)*)*;
    struct SLLEDArrayItf_
    {
        uint function(const(const(SLLEDArrayItf_)*)*, uint) ActivateLEDArray;
        uint function(const(const(SLLEDArrayItf_)*)*, uint*) IsLEDArrayActivated;
        uint function(const(const(SLLEDArrayItf_)*)*, ubyte, const(SLHSL_)*) SetColor;
        uint function(const(const(SLLEDArrayItf_)*)*, ubyte, SLHSL_*) GetColor;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_LED;
    struct SLHSL_
    {
        int hue;
        short saturation;
        short lightness;
    }
    alias SLHSL = SLHSL_;
    struct SLLEDDescriptor_
    {
        ubyte ledCount;
        ubyte primaryLED;
        uint colorMask;
    }
    alias SLLEDDescriptor = SLLEDDescriptor_;
    alias slDefaultDeviceIDMapChangedCallback = void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int);
    alias slAvailableAudioOutputsChangedCallback = void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int, uint);
    alias slAvailableAudioInputsChangedCallback = void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int, uint);
    alias SLAudioIODeviceCapabilitiesItf = const(const(SLAudioIODeviceCapabilitiesItf_)*)*;
    struct SLAudioIODeviceCapabilitiesItf_
    {
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, int*, uint*) GetAvailableAudioInputs;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, SLAudioInputDescriptor_*) QueryAudioInputCapabilities;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int, uint), void*) RegisterAvailableAudioInputsChangedCallback;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, int*, uint*) GetAvailableAudioOutputs;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, SLAudioOutputDescriptor_*) QueryAudioOutputCapabilities;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int, uint), void*) RegisterAvailableAudioOutputsChangedCallback;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, void*, uint, int), void*) RegisterDefaultDeviceIDMapChangedCallback;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, int*, uint*) GetAssociatedAudioInputs;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, int*, uint*) GetAssociatedAudioOutputs;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, int*, uint*) GetDefaultAudioDevices;
        uint function(const(const(SLAudioIODeviceCapabilitiesItf_)*)*, uint, uint, int*, int*) QuerySampleFormatsSupported;
    }
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_AUDIOIODEVICECAPABILITIES;
    struct SLAudioOutputDescriptor_
    {
        ubyte* pDeviceName;
        short deviceConnection;
        short deviceScope;
        short deviceLocation;
        uint isForTelephony;
        uint minSampleRate;
        uint maxSampleRate;
        uint isFreqRangeContinuous;
        uint* samplingRatesSupported;
        short numOfSamplingRatesSupported;
        short maxChannels;
    }
    alias SLAudioOutputDescriptor = SLAudioOutputDescriptor_;
    struct SLAudioInputDescriptor_
    {
        ubyte* deviceName;
        short deviceConnection;
        short deviceScope;
        short deviceLocation;
        uint isForTelephony;
        uint minSampleRate;
        uint maxSampleRate;
        uint isFreqRangeContinuous;
        uint* samplingRatesSupported;
        short numOfSamplingRatesSupported;
        short maxChannels;
    }
    alias SLAudioInputDescriptor = SLAudioInputDescriptor_;
    alias slObjectCallback = void function(const(const(SLObjectItf_)*)*, const(void)*, uint, uint, uint, void*);
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_OBJECT;
    struct SLDataSink_
    {
        void* pLocator;
        void* pFormat;
    }
    alias SLDataSink = SLDataSink_;
    struct SLDataSource_
    {
        void* pLocator;
        void* pFormat;
    }
    alias SLDataSource = SLDataSource_;
    struct SLDataFormat_PCM_
    {
        uint formatType;
        uint numChannels;
        uint samplesPerSec;
        uint bitsPerSample;
        uint containerSize;
        uint channelMask;
        uint endianness;
    }
    alias SLDataFormat_PCM = SLDataFormat_PCM_;
    struct SLDataFormat_MIME_
    {
        uint formatType;
        ubyte* mimeType;
        uint containerType;
    }
    alias SLDataFormat_MIME = SLDataFormat_MIME_;
    struct SLDataLocator_MIDIBufferQueue
    {
        uint locatorType;
        uint tpqn;
        uint numBuffers;
    }
    struct SLDataLocator_BufferQueue
    {
        uint locatorType;
        uint numBuffers;
    }
    struct SLDataLocator_OutputMix
    {
        uint locatorType;
        const(const(SLObjectItf_)*)* outputMix;
    }
    struct SLDataLocator_IODevice_
    {
        uint locatorType;
        uint deviceType;
        uint deviceID;
        const(const(SLObjectItf_)*)* device;
    }
    alias SLDataLocator_IODevice = SLDataLocator_IODevice_;
    struct SLDataLocator_Address_
    {
        uint locatorType;
        void* pAddress;
        uint length;
    }
    alias SLDataLocator_Address = SLDataLocator_Address_;
    struct SLDataLocator_URI_
    {
        uint locatorType;
        ubyte* URI;
    }
    alias SLDataLocator_URI = SLDataLocator_URI_;
    extern __gshared const(const(SLInterfaceID_)*) SL_IID_NULL;
    alias SLObjectItf = const(const(SLObjectItf_)*)*;
    struct SLObjectItf_
    {
        uint function(const(const(SLObjectItf_)*)*, uint) Realize;
        uint function(const(const(SLObjectItf_)*)*, uint) Resume;
        uint function(const(const(SLObjectItf_)*)*, uint*) GetState;
        uint function(const(const(SLObjectItf_)*)*, const(const(SLInterfaceID_)*), void*) GetInterface;
        uint function(const(const(SLObjectItf_)*)*, void function(const(const(SLObjectItf_)*)*, const(void)*, uint, uint, uint, void*), void*) RegisterCallback;
        void function(const(const(SLObjectItf_)*)*) AbortAsyncOperation;
        void function(const(const(SLObjectItf_)*)*) Destroy;
        uint function(const(const(SLObjectItf_)*)*, int, uint) SetPriority;
        uint function(const(const(SLObjectItf_)*)*, int*, uint*) GetPriority;
        uint function(const(const(SLObjectItf_)*)*, short, const(SLInterfaceID_)**, uint) SetLossOfControlInterfaces;
    }
    struct SLInterfaceID_
    {
        uint time_low;
        ushort time_mid;
        ushort time_hi_and_version;
        ushort clock_seq;
        ubyte[6] node;
    }
    alias SLInterfaceID = const(SLInterfaceID_)*;
    alias SLresult = uint;
    alias SLmicrosecond = uint;
    alias SLpermille = short;
    alias SLmillidegree = int;
    alias SLmillimeter = int;
    alias SLmilliHertz = uint;
    alias SLmillisecond = uint;
    alias SLmillibel = short;
    alias SLchar = ubyte;
    alias SLboolean = uint;
    alias SLuint32 = uint;
    alias SLint32 = int;
    alias SLuint16 = ushort;
    alias SLint16 = short;
    alias SLuint8 = ubyte;
    alias SLint8 = byte;







    static if(!is(typeof(KHRONOS_TITLE))) {
        private enum enumMixinStr_KHRONOS_TITLE = `enum KHRONOS_TITLE = "KhronosTitle";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_TITLE); }))) {
            mixin(enumMixinStr_KHRONOS_TITLE);
        }
    }




    static if(!is(typeof(KHRONOS_ALBUM))) {
        private enum enumMixinStr_KHRONOS_ALBUM = `enum KHRONOS_ALBUM = "KhronosAlbum";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_ALBUM); }))) {
            mixin(enumMixinStr_KHRONOS_ALBUM);
        }
    }




    static if(!is(typeof(KHRONOS_TRACK_NUMBER))) {
        private enum enumMixinStr_KHRONOS_TRACK_NUMBER = `enum KHRONOS_TRACK_NUMBER = "KhronosTrackNumber";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_TRACK_NUMBER); }))) {
            mixin(enumMixinStr_KHRONOS_TRACK_NUMBER);
        }
    }




    static if(!is(typeof(KHRONOS_ARTIST))) {
        private enum enumMixinStr_KHRONOS_ARTIST = `enum KHRONOS_ARTIST = "KhronosArtist";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_ARTIST); }))) {
            mixin(enumMixinStr_KHRONOS_ARTIST);
        }
    }




    static if(!is(typeof(KHRONOS_GENRE))) {
        private enum enumMixinStr_KHRONOS_GENRE = `enum KHRONOS_GENRE = "KhronosGenre";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_GENRE); }))) {
            mixin(enumMixinStr_KHRONOS_GENRE);
        }
    }




    static if(!is(typeof(KHRONOS_YEAR))) {
        private enum enumMixinStr_KHRONOS_YEAR = `enum KHRONOS_YEAR = "KhronosYear";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_YEAR); }))) {
            mixin(enumMixinStr_KHRONOS_YEAR);
        }
    }




    static if(!is(typeof(KHRONOS_COMMENT))) {
        private enum enumMixinStr_KHRONOS_COMMENT = `enum KHRONOS_COMMENT = "KhronosComment";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_COMMENT); }))) {
            mixin(enumMixinStr_KHRONOS_COMMENT);
        }
    }




    static if(!is(typeof(KHRONOS_ARTIST_URL))) {
        private enum enumMixinStr_KHRONOS_ARTIST_URL = `enum KHRONOS_ARTIST_URL = "KhronosArtistURL";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_ARTIST_URL); }))) {
            mixin(enumMixinStr_KHRONOS_ARTIST_URL);
        }
    }




    static if(!is(typeof(KHRONOS_CONTENT_URL))) {
        private enum enumMixinStr_KHRONOS_CONTENT_URL = `enum KHRONOS_CONTENT_URL = "KhronosContentURL";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_CONTENT_URL); }))) {
            mixin(enumMixinStr_KHRONOS_CONTENT_URL);
        }
    }




    static if(!is(typeof(KHRONOS_RATING))) {
        private enum enumMixinStr_KHRONOS_RATING = `enum KHRONOS_RATING = "KhronosRating";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_RATING); }))) {
            mixin(enumMixinStr_KHRONOS_RATING);
        }
    }




    static if(!is(typeof(KHRONOS_ALBUM_ART))) {
        private enum enumMixinStr_KHRONOS_ALBUM_ART = `enum KHRONOS_ALBUM_ART = "KhronosAlbumArt";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_ALBUM_ART); }))) {
            mixin(enumMixinStr_KHRONOS_ALBUM_ART);
        }
    }




    static if(!is(typeof(KHRONOS_COPYRIGHT))) {
        private enum enumMixinStr_KHRONOS_COPYRIGHT = `enum KHRONOS_COPYRIGHT = "KhronosCopyright";`;
        static if(is(typeof({ mixin(enumMixinStr_KHRONOS_COPYRIGHT); }))) {
            mixin(enumMixinStr_KHRONOS_COPYRIGHT);
        }
    }




    static if(!is(typeof(SL_BOOLEAN_FALSE))) {
        private enum enumMixinStr_SL_BOOLEAN_FALSE = `enum SL_BOOLEAN_FALSE = ( cast( SLboolean ) 0x00000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_BOOLEAN_FALSE); }))) {
            mixin(enumMixinStr_SL_BOOLEAN_FALSE);
        }
    }




    static if(!is(typeof(SL_BOOLEAN_TRUE))) {
        private enum enumMixinStr_SL_BOOLEAN_TRUE = `enum SL_BOOLEAN_TRUE = ( cast( SLboolean ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_BOOLEAN_TRUE); }))) {
            mixin(enumMixinStr_SL_BOOLEAN_TRUE);
        }
    }




    static if(!is(typeof(SL_MILLIBEL_MAX))) {
        private enum enumMixinStr_SL_MILLIBEL_MAX = `enum SL_MILLIBEL_MAX = ( cast( SLmillibel ) 0x7FFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MILLIBEL_MAX); }))) {
            mixin(enumMixinStr_SL_MILLIBEL_MAX);
        }
    }




    static if(!is(typeof(SL_MILLIBEL_MIN))) {
        private enum enumMixinStr_SL_MILLIBEL_MIN = `enum SL_MILLIBEL_MIN = ( cast( SLmillibel ) ( - ( cast( SLmillibel ) 0x7FFF ) - 1 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MILLIBEL_MIN); }))) {
            mixin(enumMixinStr_SL_MILLIBEL_MIN);
        }
    }




    static if(!is(typeof(SL_MILLIHERTZ_MAX))) {
        private enum enumMixinStr_SL_MILLIHERTZ_MAX = `enum SL_MILLIHERTZ_MAX = ( cast( SLmilliHertz ) 0xFFFFFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MILLIHERTZ_MAX); }))) {
            mixin(enumMixinStr_SL_MILLIHERTZ_MAX);
        }
    }




    static if(!is(typeof(SL_MILLIMETER_MAX))) {
        private enum enumMixinStr_SL_MILLIMETER_MAX = `enum SL_MILLIMETER_MAX = ( cast( SLmillimeter ) 0x7FFFFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MILLIMETER_MAX); }))) {
            mixin(enumMixinStr_SL_MILLIMETER_MAX);
        }
    }




    static if(!is(typeof(SL_OBJECTID_ENGINE))) {
        private enum enumMixinStr_SL_OBJECTID_ENGINE = `enum SL_OBJECTID_ENGINE = ( cast( SLuint32 ) 0x00001001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_ENGINE); }))) {
            mixin(enumMixinStr_SL_OBJECTID_ENGINE);
        }
    }




    static if(!is(typeof(SL_OBJECTID_LEDDEVICE))) {
        private enum enumMixinStr_SL_OBJECTID_LEDDEVICE = `enum SL_OBJECTID_LEDDEVICE = ( cast( SLuint32 ) 0x00001002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_LEDDEVICE); }))) {
            mixin(enumMixinStr_SL_OBJECTID_LEDDEVICE);
        }
    }




    static if(!is(typeof(SL_OBJECTID_VIBRADEVICE))) {
        private enum enumMixinStr_SL_OBJECTID_VIBRADEVICE = `enum SL_OBJECTID_VIBRADEVICE = ( cast( SLuint32 ) 0x00001003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_VIBRADEVICE); }))) {
            mixin(enumMixinStr_SL_OBJECTID_VIBRADEVICE);
        }
    }




    static if(!is(typeof(SL_OBJECTID_AUDIOPLAYER))) {
        private enum enumMixinStr_SL_OBJECTID_AUDIOPLAYER = `enum SL_OBJECTID_AUDIOPLAYER = ( cast( SLuint32 ) 0x00001004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_AUDIOPLAYER); }))) {
            mixin(enumMixinStr_SL_OBJECTID_AUDIOPLAYER);
        }
    }




    static if(!is(typeof(SL_OBJECTID_AUDIORECORDER))) {
        private enum enumMixinStr_SL_OBJECTID_AUDIORECORDER = `enum SL_OBJECTID_AUDIORECORDER = ( cast( SLuint32 ) 0x00001005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_AUDIORECORDER); }))) {
            mixin(enumMixinStr_SL_OBJECTID_AUDIORECORDER);
        }
    }




    static if(!is(typeof(SL_OBJECTID_MIDIPLAYER))) {
        private enum enumMixinStr_SL_OBJECTID_MIDIPLAYER = `enum SL_OBJECTID_MIDIPLAYER = ( cast( SLuint32 ) 0x00001006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_MIDIPLAYER); }))) {
            mixin(enumMixinStr_SL_OBJECTID_MIDIPLAYER);
        }
    }




    static if(!is(typeof(SL_OBJECTID_LISTENER))) {
        private enum enumMixinStr_SL_OBJECTID_LISTENER = `enum SL_OBJECTID_LISTENER = ( cast( SLuint32 ) 0x00001007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_LISTENER); }))) {
            mixin(enumMixinStr_SL_OBJECTID_LISTENER);
        }
    }




    static if(!is(typeof(SL_OBJECTID_3DGROUP))) {
        private enum enumMixinStr_SL_OBJECTID_3DGROUP = `enum SL_OBJECTID_3DGROUP = ( cast( SLuint32 ) 0x00001008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_3DGROUP); }))) {
            mixin(enumMixinStr_SL_OBJECTID_3DGROUP);
        }
    }




    static if(!is(typeof(SL_OBJECTID_OUTPUTMIX))) {
        private enum enumMixinStr_SL_OBJECTID_OUTPUTMIX = `enum SL_OBJECTID_OUTPUTMIX = ( cast( SLuint32 ) 0x00001009 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_OUTPUTMIX); }))) {
            mixin(enumMixinStr_SL_OBJECTID_OUTPUTMIX);
        }
    }




    static if(!is(typeof(SL_OBJECTID_METADATAEXTRACTOR))) {
        private enum enumMixinStr_SL_OBJECTID_METADATAEXTRACTOR = `enum SL_OBJECTID_METADATAEXTRACTOR = ( cast( SLuint32 ) 0x0000100A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECTID_METADATAEXTRACTOR); }))) {
            mixin(enumMixinStr_SL_OBJECTID_METADATAEXTRACTOR);
        }
    }




    static if(!is(typeof(SL_PROFILES_PHONE))) {
        private enum enumMixinStr_SL_PROFILES_PHONE = `enum SL_PROFILES_PHONE = ( cast( SLuint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PROFILES_PHONE); }))) {
            mixin(enumMixinStr_SL_PROFILES_PHONE);
        }
    }




    static if(!is(typeof(SL_PROFILES_MUSIC))) {
        private enum enumMixinStr_SL_PROFILES_MUSIC = `enum SL_PROFILES_MUSIC = ( cast( SLuint16 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PROFILES_MUSIC); }))) {
            mixin(enumMixinStr_SL_PROFILES_MUSIC);
        }
    }




    static if(!is(typeof(SL_PROFILES_GAME))) {
        private enum enumMixinStr_SL_PROFILES_GAME = `enum SL_PROFILES_GAME = ( cast( SLuint16 ) 0x0004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PROFILES_GAME); }))) {
            mixin(enumMixinStr_SL_PROFILES_GAME);
        }
    }




    static if(!is(typeof(SL_VOICETYPE_2D_AUDIO))) {
        private enum enumMixinStr_SL_VOICETYPE_2D_AUDIO = `enum SL_VOICETYPE_2D_AUDIO = ( cast( SLuint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_VOICETYPE_2D_AUDIO); }))) {
            mixin(enumMixinStr_SL_VOICETYPE_2D_AUDIO);
        }
    }




    static if(!is(typeof(SL_VOICETYPE_MIDI))) {
        private enum enumMixinStr_SL_VOICETYPE_MIDI = `enum SL_VOICETYPE_MIDI = ( cast( SLuint16 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_VOICETYPE_MIDI); }))) {
            mixin(enumMixinStr_SL_VOICETYPE_MIDI);
        }
    }




    static if(!is(typeof(SL_VOICETYPE_3D_AUDIO))) {
        private enum enumMixinStr_SL_VOICETYPE_3D_AUDIO = `enum SL_VOICETYPE_3D_AUDIO = ( cast( SLuint16 ) 0x0004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_VOICETYPE_3D_AUDIO); }))) {
            mixin(enumMixinStr_SL_VOICETYPE_3D_AUDIO);
        }
    }




    static if(!is(typeof(SL_VOICETYPE_3D_MIDIOUTPUT))) {
        private enum enumMixinStr_SL_VOICETYPE_3D_MIDIOUTPUT = `enum SL_VOICETYPE_3D_MIDIOUTPUT = ( cast( SLuint16 ) 0x0008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_VOICETYPE_3D_MIDIOUTPUT); }))) {
            mixin(enumMixinStr_SL_VOICETYPE_3D_MIDIOUTPUT);
        }
    }




    static if(!is(typeof(SL_PRIORITY_LOWEST))) {
        private enum enumMixinStr_SL_PRIORITY_LOWEST = `enum SL_PRIORITY_LOWEST = ( cast( SLint32 ) ( - 0x7FFFFFFF - 1 ) );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_LOWEST); }))) {
            mixin(enumMixinStr_SL_PRIORITY_LOWEST);
        }
    }




    static if(!is(typeof(SL_PRIORITY_VERYLOW))) {
        private enum enumMixinStr_SL_PRIORITY_VERYLOW = `enum SL_PRIORITY_VERYLOW = ( cast( SLint32 ) - 0x60000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_VERYLOW); }))) {
            mixin(enumMixinStr_SL_PRIORITY_VERYLOW);
        }
    }




    static if(!is(typeof(SL_PRIORITY_LOW))) {
        private enum enumMixinStr_SL_PRIORITY_LOW = `enum SL_PRIORITY_LOW = ( cast( SLint32 ) - 0x40000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_LOW); }))) {
            mixin(enumMixinStr_SL_PRIORITY_LOW);
        }
    }




    static if(!is(typeof(SL_PRIORITY_BELOWNORMAL))) {
        private enum enumMixinStr_SL_PRIORITY_BELOWNORMAL = `enum SL_PRIORITY_BELOWNORMAL = ( cast( SLint32 ) - 0x20000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_BELOWNORMAL); }))) {
            mixin(enumMixinStr_SL_PRIORITY_BELOWNORMAL);
        }
    }




    static if(!is(typeof(SL_PRIORITY_NORMAL))) {
        private enum enumMixinStr_SL_PRIORITY_NORMAL = `enum SL_PRIORITY_NORMAL = ( cast( SLint32 ) 0x00000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_NORMAL); }))) {
            mixin(enumMixinStr_SL_PRIORITY_NORMAL);
        }
    }




    static if(!is(typeof(SL_PRIORITY_ABOVENORMAL))) {
        private enum enumMixinStr_SL_PRIORITY_ABOVENORMAL = `enum SL_PRIORITY_ABOVENORMAL = ( cast( SLint32 ) 0x20000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_ABOVENORMAL); }))) {
            mixin(enumMixinStr_SL_PRIORITY_ABOVENORMAL);
        }
    }




    static if(!is(typeof(SL_PRIORITY_HIGH))) {
        private enum enumMixinStr_SL_PRIORITY_HIGH = `enum SL_PRIORITY_HIGH = ( cast( SLint32 ) 0x40000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_HIGH); }))) {
            mixin(enumMixinStr_SL_PRIORITY_HIGH);
        }
    }




    static if(!is(typeof(SL_PRIORITY_VERYHIGH))) {
        private enum enumMixinStr_SL_PRIORITY_VERYHIGH = `enum SL_PRIORITY_VERYHIGH = ( cast( SLint32 ) 0x60000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_VERYHIGH); }))) {
            mixin(enumMixinStr_SL_PRIORITY_VERYHIGH);
        }
    }




    static if(!is(typeof(SL_PRIORITY_HIGHEST))) {
        private enum enumMixinStr_SL_PRIORITY_HIGHEST = `enum SL_PRIORITY_HIGHEST = ( cast( SLint32 ) 0x7FFFFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PRIORITY_HIGHEST); }))) {
            mixin(enumMixinStr_SL_PRIORITY_HIGHEST);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_8))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_8 = `enum SL_PCMSAMPLEFORMAT_FIXED_8 = ( cast( SLuint16 ) 0x0008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_8); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_8);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_16))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_16 = `enum SL_PCMSAMPLEFORMAT_FIXED_16 = ( cast( SLuint16 ) 0x0010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_16); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_16);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_20))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_20 = `enum SL_PCMSAMPLEFORMAT_FIXED_20 = ( cast( SLuint16 ) 0x0014 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_20); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_20);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_24))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_24 = `enum SL_PCMSAMPLEFORMAT_FIXED_24 = ( cast( SLuint16 ) 0x0018 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_24); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_24);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_28))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_28 = `enum SL_PCMSAMPLEFORMAT_FIXED_28 = ( cast( SLuint16 ) 0x001C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_28); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_28);
        }
    }




    static if(!is(typeof(SL_PCMSAMPLEFORMAT_FIXED_32))) {
        private enum enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_32 = `enum SL_PCMSAMPLEFORMAT_FIXED_32 = ( cast( SLuint16 ) 0x0020 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_32); }))) {
            mixin(enumMixinStr_SL_PCMSAMPLEFORMAT_FIXED_32);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_8))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_8 = `enum SL_SAMPLINGRATE_8 = ( cast( SLuint32 ) 8000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_8); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_8);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_11_025))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_11_025 = `enum SL_SAMPLINGRATE_11_025 = ( cast( SLuint32 ) 11025000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_11_025); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_11_025);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_12))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_12 = `enum SL_SAMPLINGRATE_12 = ( cast( SLuint32 ) 12000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_12); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_12);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_16))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_16 = `enum SL_SAMPLINGRATE_16 = ( cast( SLuint32 ) 16000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_16); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_16);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_22_05))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_22_05 = `enum SL_SAMPLINGRATE_22_05 = ( cast( SLuint32 ) 22050000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_22_05); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_22_05);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_24))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_24 = `enum SL_SAMPLINGRATE_24 = ( cast( SLuint32 ) 24000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_24); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_24);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_32))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_32 = `enum SL_SAMPLINGRATE_32 = ( cast( SLuint32 ) 32000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_32); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_32);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_44_1))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_44_1 = `enum SL_SAMPLINGRATE_44_1 = ( cast( SLuint32 ) 44100000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_44_1); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_44_1);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_48))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_48 = `enum SL_SAMPLINGRATE_48 = ( cast( SLuint32 ) 48000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_48); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_48);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_64))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_64 = `enum SL_SAMPLINGRATE_64 = ( cast( SLuint32 ) 64000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_64); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_64);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_88_2))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_88_2 = `enum SL_SAMPLINGRATE_88_2 = ( cast( SLuint32 ) 88200000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_88_2); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_88_2);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_96))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_96 = `enum SL_SAMPLINGRATE_96 = ( cast( SLuint32 ) 96000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_96); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_96);
        }
    }




    static if(!is(typeof(SL_SAMPLINGRATE_192))) {
        private enum enumMixinStr_SL_SAMPLINGRATE_192 = `enum SL_SAMPLINGRATE_192 = ( cast( SLuint32 ) 192000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SAMPLINGRATE_192); }))) {
            mixin(enumMixinStr_SL_SAMPLINGRATE_192);
        }
    }




    static if(!is(typeof(SL_SPEAKER_FRONT_LEFT))) {
        private enum enumMixinStr_SL_SPEAKER_FRONT_LEFT = `enum SL_SPEAKER_FRONT_LEFT = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_FRONT_LEFT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_FRONT_LEFT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_FRONT_RIGHT))) {
        private enum enumMixinStr_SL_SPEAKER_FRONT_RIGHT = `enum SL_SPEAKER_FRONT_RIGHT = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_FRONT_RIGHT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_FRONT_RIGHT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_FRONT_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_FRONT_CENTER = `enum SL_SPEAKER_FRONT_CENTER = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_FRONT_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_FRONT_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_LOW_FREQUENCY))) {
        private enum enumMixinStr_SL_SPEAKER_LOW_FREQUENCY = `enum SL_SPEAKER_LOW_FREQUENCY = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_LOW_FREQUENCY); }))) {
            mixin(enumMixinStr_SL_SPEAKER_LOW_FREQUENCY);
        }
    }




    static if(!is(typeof(SL_SPEAKER_BACK_LEFT))) {
        private enum enumMixinStr_SL_SPEAKER_BACK_LEFT = `enum SL_SPEAKER_BACK_LEFT = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_BACK_LEFT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_BACK_LEFT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_BACK_RIGHT))) {
        private enum enumMixinStr_SL_SPEAKER_BACK_RIGHT = `enum SL_SPEAKER_BACK_RIGHT = ( cast( SLuint32 ) 0x00000020 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_BACK_RIGHT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_BACK_RIGHT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_FRONT_LEFT_OF_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_FRONT_LEFT_OF_CENTER = `enum SL_SPEAKER_FRONT_LEFT_OF_CENTER = ( cast( SLuint32 ) 0x00000040 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_FRONT_LEFT_OF_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_FRONT_LEFT_OF_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_FRONT_RIGHT_OF_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_FRONT_RIGHT_OF_CENTER = `enum SL_SPEAKER_FRONT_RIGHT_OF_CENTER = ( cast( SLuint32 ) 0x00000080 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_FRONT_RIGHT_OF_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_FRONT_RIGHT_OF_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_BACK_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_BACK_CENTER = `enum SL_SPEAKER_BACK_CENTER = ( cast( SLuint32 ) 0x00000100 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_BACK_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_BACK_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_SIDE_LEFT))) {
        private enum enumMixinStr_SL_SPEAKER_SIDE_LEFT = `enum SL_SPEAKER_SIDE_LEFT = ( cast( SLuint32 ) 0x00000200 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_SIDE_LEFT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_SIDE_LEFT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_SIDE_RIGHT))) {
        private enum enumMixinStr_SL_SPEAKER_SIDE_RIGHT = `enum SL_SPEAKER_SIDE_RIGHT = ( cast( SLuint32 ) 0x00000400 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_SIDE_RIGHT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_SIDE_RIGHT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_CENTER = `enum SL_SPEAKER_TOP_CENTER = ( cast( SLuint32 ) 0x00000800 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_FRONT_LEFT))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_FRONT_LEFT = `enum SL_SPEAKER_TOP_FRONT_LEFT = ( cast( SLuint32 ) 0x00001000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_LEFT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_LEFT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_FRONT_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_FRONT_CENTER = `enum SL_SPEAKER_TOP_FRONT_CENTER = ( cast( SLuint32 ) 0x00002000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_FRONT_RIGHT))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_FRONT_RIGHT = `enum SL_SPEAKER_TOP_FRONT_RIGHT = ( cast( SLuint32 ) 0x00004000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_RIGHT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_FRONT_RIGHT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_BACK_LEFT))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_BACK_LEFT = `enum SL_SPEAKER_TOP_BACK_LEFT = ( cast( SLuint32 ) 0x00008000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_LEFT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_LEFT);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_BACK_CENTER))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_BACK_CENTER = `enum SL_SPEAKER_TOP_BACK_CENTER = ( cast( SLuint32 ) 0x00010000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_CENTER); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_CENTER);
        }
    }




    static if(!is(typeof(SL_SPEAKER_TOP_BACK_RIGHT))) {
        private enum enumMixinStr_SL_SPEAKER_TOP_BACK_RIGHT = `enum SL_SPEAKER_TOP_BACK_RIGHT = ( cast( SLuint32 ) 0x00020000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_RIGHT); }))) {
            mixin(enumMixinStr_SL_SPEAKER_TOP_BACK_RIGHT);
        }
    }




    static if(!is(typeof(SL_RESULT_SUCCESS))) {
        private enum enumMixinStr_SL_RESULT_SUCCESS = `enum SL_RESULT_SUCCESS = ( cast( SLuint32 ) 0x00000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_SUCCESS); }))) {
            mixin(enumMixinStr_SL_RESULT_SUCCESS);
        }
    }




    static if(!is(typeof(SL_RESULT_PRECONDITIONS_VIOLATED))) {
        private enum enumMixinStr_SL_RESULT_PRECONDITIONS_VIOLATED = `enum SL_RESULT_PRECONDITIONS_VIOLATED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_PRECONDITIONS_VIOLATED); }))) {
            mixin(enumMixinStr_SL_RESULT_PRECONDITIONS_VIOLATED);
        }
    }




    static if(!is(typeof(SL_RESULT_PARAMETER_INVALID))) {
        private enum enumMixinStr_SL_RESULT_PARAMETER_INVALID = `enum SL_RESULT_PARAMETER_INVALID = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_PARAMETER_INVALID); }))) {
            mixin(enumMixinStr_SL_RESULT_PARAMETER_INVALID);
        }
    }




    static if(!is(typeof(SL_RESULT_MEMORY_FAILURE))) {
        private enum enumMixinStr_SL_RESULT_MEMORY_FAILURE = `enum SL_RESULT_MEMORY_FAILURE = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_MEMORY_FAILURE); }))) {
            mixin(enumMixinStr_SL_RESULT_MEMORY_FAILURE);
        }
    }




    static if(!is(typeof(SL_RESULT_RESOURCE_ERROR))) {
        private enum enumMixinStr_SL_RESULT_RESOURCE_ERROR = `enum SL_RESULT_RESOURCE_ERROR = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_RESOURCE_ERROR); }))) {
            mixin(enumMixinStr_SL_RESULT_RESOURCE_ERROR);
        }
    }




    static if(!is(typeof(SL_RESULT_RESOURCE_LOST))) {
        private enum enumMixinStr_SL_RESULT_RESOURCE_LOST = `enum SL_RESULT_RESOURCE_LOST = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_RESOURCE_LOST); }))) {
            mixin(enumMixinStr_SL_RESULT_RESOURCE_LOST);
        }
    }




    static if(!is(typeof(SL_RESULT_IO_ERROR))) {
        private enum enumMixinStr_SL_RESULT_IO_ERROR = `enum SL_RESULT_IO_ERROR = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_IO_ERROR); }))) {
            mixin(enumMixinStr_SL_RESULT_IO_ERROR);
        }
    }




    static if(!is(typeof(SL_RESULT_BUFFER_INSUFFICIENT))) {
        private enum enumMixinStr_SL_RESULT_BUFFER_INSUFFICIENT = `enum SL_RESULT_BUFFER_INSUFFICIENT = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_BUFFER_INSUFFICIENT); }))) {
            mixin(enumMixinStr_SL_RESULT_BUFFER_INSUFFICIENT);
        }
    }




    static if(!is(typeof(SL_RESULT_CONTENT_CORRUPTED))) {
        private enum enumMixinStr_SL_RESULT_CONTENT_CORRUPTED = `enum SL_RESULT_CONTENT_CORRUPTED = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_CONTENT_CORRUPTED); }))) {
            mixin(enumMixinStr_SL_RESULT_CONTENT_CORRUPTED);
        }
    }




    static if(!is(typeof(SL_RESULT_CONTENT_UNSUPPORTED))) {
        private enum enumMixinStr_SL_RESULT_CONTENT_UNSUPPORTED = `enum SL_RESULT_CONTENT_UNSUPPORTED = ( cast( SLuint32 ) 0x00000009 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_CONTENT_UNSUPPORTED); }))) {
            mixin(enumMixinStr_SL_RESULT_CONTENT_UNSUPPORTED);
        }
    }




    static if(!is(typeof(SL_RESULT_CONTENT_NOT_FOUND))) {
        private enum enumMixinStr_SL_RESULT_CONTENT_NOT_FOUND = `enum SL_RESULT_CONTENT_NOT_FOUND = ( cast( SLuint32 ) 0x0000000A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_CONTENT_NOT_FOUND); }))) {
            mixin(enumMixinStr_SL_RESULT_CONTENT_NOT_FOUND);
        }
    }




    static if(!is(typeof(SL_RESULT_PERMISSION_DENIED))) {
        private enum enumMixinStr_SL_RESULT_PERMISSION_DENIED = `enum SL_RESULT_PERMISSION_DENIED = ( cast( SLuint32 ) 0x0000000B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_PERMISSION_DENIED); }))) {
            mixin(enumMixinStr_SL_RESULT_PERMISSION_DENIED);
        }
    }




    static if(!is(typeof(SL_RESULT_FEATURE_UNSUPPORTED))) {
        private enum enumMixinStr_SL_RESULT_FEATURE_UNSUPPORTED = `enum SL_RESULT_FEATURE_UNSUPPORTED = ( cast( SLuint32 ) 0x0000000C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_FEATURE_UNSUPPORTED); }))) {
            mixin(enumMixinStr_SL_RESULT_FEATURE_UNSUPPORTED);
        }
    }




    static if(!is(typeof(SL_RESULT_INTERNAL_ERROR))) {
        private enum enumMixinStr_SL_RESULT_INTERNAL_ERROR = `enum SL_RESULT_INTERNAL_ERROR = ( cast( SLuint32 ) 0x0000000D );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_INTERNAL_ERROR); }))) {
            mixin(enumMixinStr_SL_RESULT_INTERNAL_ERROR);
        }
    }




    static if(!is(typeof(SL_RESULT_UNKNOWN_ERROR))) {
        private enum enumMixinStr_SL_RESULT_UNKNOWN_ERROR = `enum SL_RESULT_UNKNOWN_ERROR = ( cast( SLuint32 ) 0x0000000E );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_UNKNOWN_ERROR); }))) {
            mixin(enumMixinStr_SL_RESULT_UNKNOWN_ERROR);
        }
    }




    static if(!is(typeof(SL_RESULT_OPERATION_ABORTED))) {
        private enum enumMixinStr_SL_RESULT_OPERATION_ABORTED = `enum SL_RESULT_OPERATION_ABORTED = ( cast( SLuint32 ) 0x0000000F );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_OPERATION_ABORTED); }))) {
            mixin(enumMixinStr_SL_RESULT_OPERATION_ABORTED);
        }
    }




    static if(!is(typeof(SL_RESULT_CONTROL_LOST))) {
        private enum enumMixinStr_SL_RESULT_CONTROL_LOST = `enum SL_RESULT_CONTROL_LOST = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RESULT_CONTROL_LOST); }))) {
            mixin(enumMixinStr_SL_RESULT_CONTROL_LOST);
        }
    }




    static if(!is(typeof(SL_OBJECT_STATE_UNREALIZED))) {
        private enum enumMixinStr_SL_OBJECT_STATE_UNREALIZED = `enum SL_OBJECT_STATE_UNREALIZED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_STATE_UNREALIZED); }))) {
            mixin(enumMixinStr_SL_OBJECT_STATE_UNREALIZED);
        }
    }




    static if(!is(typeof(SL_OBJECT_STATE_REALIZED))) {
        private enum enumMixinStr_SL_OBJECT_STATE_REALIZED = `enum SL_OBJECT_STATE_REALIZED = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_STATE_REALIZED); }))) {
            mixin(enumMixinStr_SL_OBJECT_STATE_REALIZED);
        }
    }




    static if(!is(typeof(SL_OBJECT_STATE_SUSPENDED))) {
        private enum enumMixinStr_SL_OBJECT_STATE_SUSPENDED = `enum SL_OBJECT_STATE_SUSPENDED = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_STATE_SUSPENDED); }))) {
            mixin(enumMixinStr_SL_OBJECT_STATE_SUSPENDED);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_RUNTIME_ERROR))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_RUNTIME_ERROR = `enum SL_OBJECT_EVENT_RUNTIME_ERROR = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_RUNTIME_ERROR); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_RUNTIME_ERROR);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_ASYNC_TERMINATION))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_ASYNC_TERMINATION = `enum SL_OBJECT_EVENT_ASYNC_TERMINATION = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_ASYNC_TERMINATION); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_ASYNC_TERMINATION);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_RESOURCES_LOST))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_RESOURCES_LOST = `enum SL_OBJECT_EVENT_RESOURCES_LOST = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_RESOURCES_LOST); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_RESOURCES_LOST);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_RESOURCES_AVAILABLE))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_RESOURCES_AVAILABLE = `enum SL_OBJECT_EVENT_RESOURCES_AVAILABLE = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_RESOURCES_AVAILABLE); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_RESOURCES_AVAILABLE);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_ITF_CONTROL_TAKEN))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_TAKEN = `enum SL_OBJECT_EVENT_ITF_CONTROL_TAKEN = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_TAKEN); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_TAKEN);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_ITF_CONTROL_RETURNED))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_RETURNED = `enum SL_OBJECT_EVENT_ITF_CONTROL_RETURNED = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_RETURNED); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_CONTROL_RETURNED);
        }
    }




    static if(!is(typeof(SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED))) {
        private enum enumMixinStr_SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED = `enum SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED); }))) {
            mixin(enumMixinStr_SL_OBJECT_EVENT_ITF_PARAMETERS_CHANGED);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_URI))) {
        private enum enumMixinStr_SL_DATALOCATOR_URI = `enum SL_DATALOCATOR_URI = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_URI); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_URI);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_ADDRESS))) {
        private enum enumMixinStr_SL_DATALOCATOR_ADDRESS = `enum SL_DATALOCATOR_ADDRESS = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_ADDRESS); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_ADDRESS);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_IODEVICE))) {
        private enum enumMixinStr_SL_DATALOCATOR_IODEVICE = `enum SL_DATALOCATOR_IODEVICE = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_IODEVICE); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_IODEVICE);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_OUTPUTMIX))) {
        private enum enumMixinStr_SL_DATALOCATOR_OUTPUTMIX = `enum SL_DATALOCATOR_OUTPUTMIX = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_OUTPUTMIX); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_OUTPUTMIX);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_RESERVED5))) {
        private enum enumMixinStr_SL_DATALOCATOR_RESERVED5 = `enum SL_DATALOCATOR_RESERVED5 = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_RESERVED5); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_RESERVED5);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_BUFFERQUEUE))) {
        private enum enumMixinStr_SL_DATALOCATOR_BUFFERQUEUE = `enum SL_DATALOCATOR_BUFFERQUEUE = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_BUFFERQUEUE); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_BUFFERQUEUE);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_MIDIBUFFERQUEUE))) {
        private enum enumMixinStr_SL_DATALOCATOR_MIDIBUFFERQUEUE = `enum SL_DATALOCATOR_MIDIBUFFERQUEUE = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_MIDIBUFFERQUEUE); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_MIDIBUFFERQUEUE);
        }
    }




    static if(!is(typeof(SL_DATALOCATOR_RESERVED8))) {
        private enum enumMixinStr_SL_DATALOCATOR_RESERVED8 = `enum SL_DATALOCATOR_RESERVED8 = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATALOCATOR_RESERVED8); }))) {
            mixin(enumMixinStr_SL_DATALOCATOR_RESERVED8);
        }
    }




    static if(!is(typeof(SL_IODEVICE_AUDIOINPUT))) {
        private enum enumMixinStr_SL_IODEVICE_AUDIOINPUT = `enum SL_IODEVICE_AUDIOINPUT = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_IODEVICE_AUDIOINPUT); }))) {
            mixin(enumMixinStr_SL_IODEVICE_AUDIOINPUT);
        }
    }




    static if(!is(typeof(SL_IODEVICE_LEDARRAY))) {
        private enum enumMixinStr_SL_IODEVICE_LEDARRAY = `enum SL_IODEVICE_LEDARRAY = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_IODEVICE_LEDARRAY); }))) {
            mixin(enumMixinStr_SL_IODEVICE_LEDARRAY);
        }
    }




    static if(!is(typeof(SL_IODEVICE_VIBRA))) {
        private enum enumMixinStr_SL_IODEVICE_VIBRA = `enum SL_IODEVICE_VIBRA = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_IODEVICE_VIBRA); }))) {
            mixin(enumMixinStr_SL_IODEVICE_VIBRA);
        }
    }




    static if(!is(typeof(SL_IODEVICE_RESERVED4))) {
        private enum enumMixinStr_SL_IODEVICE_RESERVED4 = `enum SL_IODEVICE_RESERVED4 = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_IODEVICE_RESERVED4); }))) {
            mixin(enumMixinStr_SL_IODEVICE_RESERVED4);
        }
    }




    static if(!is(typeof(SL_IODEVICE_RESERVED5))) {
        private enum enumMixinStr_SL_IODEVICE_RESERVED5 = `enum SL_IODEVICE_RESERVED5 = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_IODEVICE_RESERVED5); }))) {
            mixin(enumMixinStr_SL_IODEVICE_RESERVED5);
        }
    }




    static if(!is(typeof(SL_DATAFORMAT_MIME))) {
        private enum enumMixinStr_SL_DATAFORMAT_MIME = `enum SL_DATAFORMAT_MIME = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATAFORMAT_MIME); }))) {
            mixin(enumMixinStr_SL_DATAFORMAT_MIME);
        }
    }




    static if(!is(typeof(SL_DATAFORMAT_PCM))) {
        private enum enumMixinStr_SL_DATAFORMAT_PCM = `enum SL_DATAFORMAT_PCM = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATAFORMAT_PCM); }))) {
            mixin(enumMixinStr_SL_DATAFORMAT_PCM);
        }
    }




    static if(!is(typeof(SL_DATAFORMAT_RESERVED3))) {
        private enum enumMixinStr_SL_DATAFORMAT_RESERVED3 = `enum SL_DATAFORMAT_RESERVED3 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DATAFORMAT_RESERVED3); }))) {
            mixin(enumMixinStr_SL_DATAFORMAT_RESERVED3);
        }
    }




    static if(!is(typeof(SL_BYTEORDER_BIGENDIAN))) {
        private enum enumMixinStr_SL_BYTEORDER_BIGENDIAN = `enum SL_BYTEORDER_BIGENDIAN = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_BYTEORDER_BIGENDIAN); }))) {
            mixin(enumMixinStr_SL_BYTEORDER_BIGENDIAN);
        }
    }




    static if(!is(typeof(SL_BYTEORDER_LITTLEENDIAN))) {
        private enum enumMixinStr_SL_BYTEORDER_LITTLEENDIAN = `enum SL_BYTEORDER_LITTLEENDIAN = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_BYTEORDER_LITTLEENDIAN); }))) {
            mixin(enumMixinStr_SL_BYTEORDER_LITTLEENDIAN);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_UNSPECIFIED))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_UNSPECIFIED = `enum SL_CONTAINERTYPE_UNSPECIFIED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_UNSPECIFIED); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_UNSPECIFIED);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_RAW))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_RAW = `enum SL_CONTAINERTYPE_RAW = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_RAW); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_RAW);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_ASF))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_ASF = `enum SL_CONTAINERTYPE_ASF = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_ASF); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_ASF);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_AVI))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_AVI = `enum SL_CONTAINERTYPE_AVI = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_AVI); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_AVI);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_BMP))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_BMP = `enum SL_CONTAINERTYPE_BMP = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_BMP); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_BMP);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_JPG))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_JPG = `enum SL_CONTAINERTYPE_JPG = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_JPG); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_JPG);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_JPG2000))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_JPG2000 = `enum SL_CONTAINERTYPE_JPG2000 = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_JPG2000); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_JPG2000);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_M4A))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_M4A = `enum SL_CONTAINERTYPE_M4A = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_M4A); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_M4A);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MP3))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MP3 = `enum SL_CONTAINERTYPE_MP3 = ( cast( SLuint32 ) 0x00000009 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MP3); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MP3);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MP4))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MP4 = `enum SL_CONTAINERTYPE_MP4 = ( cast( SLuint32 ) 0x0000000A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MP4); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MP4);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MPEG_ES))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MPEG_ES = `enum SL_CONTAINERTYPE_MPEG_ES = ( cast( SLuint32 ) 0x0000000B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_ES); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_ES);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MPEG_PS))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MPEG_PS = `enum SL_CONTAINERTYPE_MPEG_PS = ( cast( SLuint32 ) 0x0000000C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_PS); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_PS);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MPEG_TS))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MPEG_TS = `enum SL_CONTAINERTYPE_MPEG_TS = ( cast( SLuint32 ) 0x0000000D );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_TS); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MPEG_TS);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_QT))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_QT = `enum SL_CONTAINERTYPE_QT = ( cast( SLuint32 ) 0x0000000E );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_QT); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_QT);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_WAV))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_WAV = `enum SL_CONTAINERTYPE_WAV = ( cast( SLuint32 ) 0x0000000F );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_WAV); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_WAV);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_XMF_0))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_XMF_0 = `enum SL_CONTAINERTYPE_XMF_0 = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_0); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_0);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_XMF_1))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_XMF_1 = `enum SL_CONTAINERTYPE_XMF_1 = ( cast( SLuint32 ) 0x00000011 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_1); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_1);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_XMF_2))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_XMF_2 = `enum SL_CONTAINERTYPE_XMF_2 = ( cast( SLuint32 ) 0x00000012 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_2); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_2);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_XMF_3))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_XMF_3 = `enum SL_CONTAINERTYPE_XMF_3 = ( cast( SLuint32 ) 0x00000013 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_3); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_3);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_XMF_GENERIC))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_XMF_GENERIC = `enum SL_CONTAINERTYPE_XMF_GENERIC = ( cast( SLuint32 ) 0x00000014 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_GENERIC); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_XMF_GENERIC);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_AMR))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_AMR = `enum SL_CONTAINERTYPE_AMR = ( cast( SLuint32 ) 0x00000015 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_AMR); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_AMR);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_AAC))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_AAC = `enum SL_CONTAINERTYPE_AAC = ( cast( SLuint32 ) 0x00000016 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_AAC); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_AAC);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_3GPP))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_3GPP = `enum SL_CONTAINERTYPE_3GPP = ( cast( SLuint32 ) 0x00000017 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_3GPP); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_3GPP);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_3GA))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_3GA = `enum SL_CONTAINERTYPE_3GA = ( cast( SLuint32 ) 0x00000018 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_3GA); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_3GA);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_RM))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_RM = `enum SL_CONTAINERTYPE_RM = ( cast( SLuint32 ) 0x00000019 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_RM); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_RM);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_DMF))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_DMF = `enum SL_CONTAINERTYPE_DMF = ( cast( SLuint32 ) 0x0000001A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_DMF); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_DMF);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_SMF))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_SMF = `enum SL_CONTAINERTYPE_SMF = ( cast( SLuint32 ) 0x0000001B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_SMF); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_SMF);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_MOBILE_DLS))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_MOBILE_DLS = `enum SL_CONTAINERTYPE_MOBILE_DLS = ( cast( SLuint32 ) 0x0000001C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_MOBILE_DLS); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_MOBILE_DLS);
        }
    }




    static if(!is(typeof(SL_CONTAINERTYPE_OGG))) {
        private enum enumMixinStr_SL_CONTAINERTYPE_OGG = `enum SL_CONTAINERTYPE_OGG = ( cast( SLuint32 ) 0x0000001D );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CONTAINERTYPE_OGG); }))) {
            mixin(enumMixinStr_SL_CONTAINERTYPE_OGG);
        }
    }




    static if(!is(typeof(SL_DEFAULTDEVICEID_AUDIOINPUT))) {
        private enum enumMixinStr_SL_DEFAULTDEVICEID_AUDIOINPUT = `enum SL_DEFAULTDEVICEID_AUDIOINPUT = ( cast( SLuint32 ) 0xFFFFFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEFAULTDEVICEID_AUDIOINPUT); }))) {
            mixin(enumMixinStr_SL_DEFAULTDEVICEID_AUDIOINPUT);
        }
    }




    static if(!is(typeof(SL_DEFAULTDEVICEID_AUDIOOUTPUT))) {
        private enum enumMixinStr_SL_DEFAULTDEVICEID_AUDIOOUTPUT = `enum SL_DEFAULTDEVICEID_AUDIOOUTPUT = ( cast( SLuint32 ) 0xFFFFFFFE );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEFAULTDEVICEID_AUDIOOUTPUT); }))) {
            mixin(enumMixinStr_SL_DEFAULTDEVICEID_AUDIOOUTPUT);
        }
    }




    static if(!is(typeof(SL_DEFAULTDEVICEID_LED))) {
        private enum enumMixinStr_SL_DEFAULTDEVICEID_LED = `enum SL_DEFAULTDEVICEID_LED = ( cast( SLuint32 ) 0xFFFFFFFD );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEFAULTDEVICEID_LED); }))) {
            mixin(enumMixinStr_SL_DEFAULTDEVICEID_LED);
        }
    }




    static if(!is(typeof(SL_DEFAULTDEVICEID_VIBRA))) {
        private enum enumMixinStr_SL_DEFAULTDEVICEID_VIBRA = `enum SL_DEFAULTDEVICEID_VIBRA = ( cast( SLuint32 ) 0xFFFFFFFC );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEFAULTDEVICEID_VIBRA); }))) {
            mixin(enumMixinStr_SL_DEFAULTDEVICEID_VIBRA);
        }
    }




    static if(!is(typeof(SL_DEFAULTDEVICEID_RESERVED1))) {
        private enum enumMixinStr_SL_DEFAULTDEVICEID_RESERVED1 = `enum SL_DEFAULTDEVICEID_RESERVED1 = ( cast( SLuint32 ) 0xFFFFFFFB );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEFAULTDEVICEID_RESERVED1); }))) {
            mixin(enumMixinStr_SL_DEFAULTDEVICEID_RESERVED1);
        }
    }




    static if(!is(typeof(SL_DEVCONNECTION_INTEGRATED))) {
        private enum enumMixinStr_SL_DEVCONNECTION_INTEGRATED = `enum SL_DEVCONNECTION_INTEGRATED = ( cast( SLint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVCONNECTION_INTEGRATED); }))) {
            mixin(enumMixinStr_SL_DEVCONNECTION_INTEGRATED);
        }
    }




    static if(!is(typeof(SL_DEVCONNECTION_ATTACHED_WIRED))) {
        private enum enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRED = `enum SL_DEVCONNECTION_ATTACHED_WIRED = ( cast( SLint16 ) 0x0100 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRED); }))) {
            mixin(enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRED);
        }
    }




    static if(!is(typeof(SL_DEVCONNECTION_ATTACHED_WIRELESS))) {
        private enum enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRELESS = `enum SL_DEVCONNECTION_ATTACHED_WIRELESS = ( cast( SLint16 ) 0x0200 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRELESS); }))) {
            mixin(enumMixinStr_SL_DEVCONNECTION_ATTACHED_WIRELESS);
        }
    }




    static if(!is(typeof(SL_DEVCONNECTION_NETWORK))) {
        private enum enumMixinStr_SL_DEVCONNECTION_NETWORK = `enum SL_DEVCONNECTION_NETWORK = ( cast( SLint16 ) 0x0400 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVCONNECTION_NETWORK); }))) {
            mixin(enumMixinStr_SL_DEVCONNECTION_NETWORK);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_HANDSET))) {
        private enum enumMixinStr_SL_DEVLOCATION_HANDSET = `enum SL_DEVLOCATION_HANDSET = ( cast( SLuint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_HANDSET); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_HANDSET);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_HEADSET))) {
        private enum enumMixinStr_SL_DEVLOCATION_HEADSET = `enum SL_DEVLOCATION_HEADSET = ( cast( SLuint16 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_HEADSET); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_HEADSET);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_CARKIT))) {
        private enum enumMixinStr_SL_DEVLOCATION_CARKIT = `enum SL_DEVLOCATION_CARKIT = ( cast( SLuint16 ) 0x0003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_CARKIT); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_CARKIT);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_DOCK))) {
        private enum enumMixinStr_SL_DEVLOCATION_DOCK = `enum SL_DEVLOCATION_DOCK = ( cast( SLuint16 ) 0x0004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_DOCK); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_DOCK);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_REMOTE))) {
        private enum enumMixinStr_SL_DEVLOCATION_REMOTE = `enum SL_DEVLOCATION_REMOTE = ( cast( SLuint16 ) 0x0005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_REMOTE); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_REMOTE);
        }
    }




    static if(!is(typeof(SL_DEVLOCATION_RESLTE))) {
        private enum enumMixinStr_SL_DEVLOCATION_RESLTE = `enum SL_DEVLOCATION_RESLTE = ( cast( SLuint16 ) 0x0005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVLOCATION_RESLTE); }))) {
            mixin(enumMixinStr_SL_DEVLOCATION_RESLTE);
        }
    }




    static if(!is(typeof(SL_DEVSCOPE_UNKNOWN))) {
        private enum enumMixinStr_SL_DEVSCOPE_UNKNOWN = `enum SL_DEVSCOPE_UNKNOWN = ( cast( SLuint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVSCOPE_UNKNOWN); }))) {
            mixin(enumMixinStr_SL_DEVSCOPE_UNKNOWN);
        }
    }




    static if(!is(typeof(SL_DEVSCOPE_ENVIRONMENT))) {
        private enum enumMixinStr_SL_DEVSCOPE_ENVIRONMENT = `enum SL_DEVSCOPE_ENVIRONMENT = ( cast( SLuint16 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVSCOPE_ENVIRONMENT); }))) {
            mixin(enumMixinStr_SL_DEVSCOPE_ENVIRONMENT);
        }
    }




    static if(!is(typeof(SL_DEVSCOPE_USER))) {
        private enum enumMixinStr_SL_DEVSCOPE_USER = `enum SL_DEVSCOPE_USER = ( cast( SLuint16 ) 0x0003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DEVSCOPE_USER); }))) {
            mixin(enumMixinStr_SL_DEVSCOPE_USER);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_UNKNOWN))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_UNKNOWN = `enum SL_CHARACTERENCODING_UNKNOWN = ( cast( SLuint32 ) 0x00000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_UNKNOWN); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_UNKNOWN);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_BINARY))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_BINARY = `enum SL_CHARACTERENCODING_BINARY = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_BINARY); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_BINARY);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ASCII))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ASCII = `enum SL_CHARACTERENCODING_ASCII = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ASCII); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ASCII);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_BIG5))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_BIG5 = `enum SL_CHARACTERENCODING_BIG5 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_BIG5); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_BIG5);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_CODEPAGE1252))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_CODEPAGE1252 = `enum SL_CHARACTERENCODING_CODEPAGE1252 = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_CODEPAGE1252); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_CODEPAGE1252);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_GB2312))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_GB2312 = `enum SL_CHARACTERENCODING_GB2312 = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_GB2312); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_GB2312);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_HZGB2312))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_HZGB2312 = `enum SL_CHARACTERENCODING_HZGB2312 = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_HZGB2312); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_HZGB2312);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_GB12345))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_GB12345 = `enum SL_CHARACTERENCODING_GB12345 = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_GB12345); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_GB12345);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_GB18030))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_GB18030 = `enum SL_CHARACTERENCODING_GB18030 = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_GB18030); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_GB18030);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_GBK))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_GBK = `enum SL_CHARACTERENCODING_GBK = ( cast( SLuint32 ) 0x00000009 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_GBK); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_GBK);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_IMAPUTF7))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_IMAPUTF7 = `enum SL_CHARACTERENCODING_IMAPUTF7 = ( cast( SLuint32 ) 0x0000000A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_IMAPUTF7); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_IMAPUTF7);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO2022JP))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO2022JP = `enum SL_CHARACTERENCODING_ISO2022JP = ( cast( SLuint32 ) 0x0000000B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO2022JP); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO2022JP);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO2022JP1))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO2022JP1 = `enum SL_CHARACTERENCODING_ISO2022JP1 = ( cast( SLuint32 ) 0x0000000B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO2022JP1); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO2022JP1);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88591))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88591 = `enum SL_CHARACTERENCODING_ISO88591 = ( cast( SLuint32 ) 0x0000000C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88591); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88591);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO885910))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO885910 = `enum SL_CHARACTERENCODING_ISO885910 = ( cast( SLuint32 ) 0x0000000D );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885910); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885910);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO885913))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO885913 = `enum SL_CHARACTERENCODING_ISO885913 = ( cast( SLuint32 ) 0x0000000E );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885913); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885913);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO885914))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO885914 = `enum SL_CHARACTERENCODING_ISO885914 = ( cast( SLuint32 ) 0x0000000F );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885914); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885914);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO885915))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO885915 = `enum SL_CHARACTERENCODING_ISO885915 = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885915); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO885915);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88592))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88592 = `enum SL_CHARACTERENCODING_ISO88592 = ( cast( SLuint32 ) 0x00000011 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88592); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88592);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88593))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88593 = `enum SL_CHARACTERENCODING_ISO88593 = ( cast( SLuint32 ) 0x00000012 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88593); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88593);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88594))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88594 = `enum SL_CHARACTERENCODING_ISO88594 = ( cast( SLuint32 ) 0x00000013 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88594); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88594);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88595))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88595 = `enum SL_CHARACTERENCODING_ISO88595 = ( cast( SLuint32 ) 0x00000014 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88595); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88595);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88596))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88596 = `enum SL_CHARACTERENCODING_ISO88596 = ( cast( SLuint32 ) 0x00000015 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88596); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88596);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88597))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88597 = `enum SL_CHARACTERENCODING_ISO88597 = ( cast( SLuint32 ) 0x00000016 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88597); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88597);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88598))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88598 = `enum SL_CHARACTERENCODING_ISO88598 = ( cast( SLuint32 ) 0x00000017 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88598); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88598);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISO88599))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISO88599 = `enum SL_CHARACTERENCODING_ISO88599 = ( cast( SLuint32 ) 0x00000018 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88599); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISO88599);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_ISOEUCJP))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_ISOEUCJP = `enum SL_CHARACTERENCODING_ISOEUCJP = ( cast( SLuint32 ) 0x00000019 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_ISOEUCJP); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_ISOEUCJP);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_SHIFTJIS))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_SHIFTJIS = `enum SL_CHARACTERENCODING_SHIFTJIS = ( cast( SLuint32 ) 0x0000001A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_SHIFTJIS); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_SHIFTJIS);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_SMS7BIT))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_SMS7BIT = `enum SL_CHARACTERENCODING_SMS7BIT = ( cast( SLuint32 ) 0x0000001B );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_SMS7BIT); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_SMS7BIT);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_UTF7))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_UTF7 = `enum SL_CHARACTERENCODING_UTF7 = ( cast( SLuint32 ) 0x0000001C );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_UTF7); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_UTF7);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_UTF8))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_UTF8 = `enum SL_CHARACTERENCODING_UTF8 = ( cast( SLuint32 ) 0x0000001D );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_UTF8); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_UTF8);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_JAVACONFORMANTUTF8))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_JAVACONFORMANTUTF8 = `enum SL_CHARACTERENCODING_JAVACONFORMANTUTF8 = ( cast( SLuint32 ) 0x0000001E );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_JAVACONFORMANTUTF8); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_JAVACONFORMANTUTF8);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_UTF16BE))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_UTF16BE = `enum SL_CHARACTERENCODING_UTF16BE = ( cast( SLuint32 ) 0x0000001F );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_UTF16BE); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_UTF16BE);
        }
    }




    static if(!is(typeof(SL_CHARACTERENCODING_UTF16LE))) {
        private enum enumMixinStr_SL_CHARACTERENCODING_UTF16LE = `enum SL_CHARACTERENCODING_UTF16LE = ( cast( SLuint32 ) 0x00000020 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_CHARACTERENCODING_UTF16LE); }))) {
            mixin(enumMixinStr_SL_CHARACTERENCODING_UTF16LE);
        }
    }




    static if(!is(typeof(SL_METADATA_FILTER_KEY))) {
        private enum enumMixinStr_SL_METADATA_FILTER_KEY = `enum SL_METADATA_FILTER_KEY = ( cast( SLuint8 ) 0x01 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_METADATA_FILTER_KEY); }))) {
            mixin(enumMixinStr_SL_METADATA_FILTER_KEY);
        }
    }




    static if(!is(typeof(SL_METADATA_FILTER_LANG))) {
        private enum enumMixinStr_SL_METADATA_FILTER_LANG = `enum SL_METADATA_FILTER_LANG = ( cast( SLuint8 ) 0x02 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_METADATA_FILTER_LANG); }))) {
            mixin(enumMixinStr_SL_METADATA_FILTER_LANG);
        }
    }




    static if(!is(typeof(SL_METADATA_FILTER_ENCODING))) {
        private enum enumMixinStr_SL_METADATA_FILTER_ENCODING = `enum SL_METADATA_FILTER_ENCODING = ( cast( SLuint8 ) 0x04 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_METADATA_FILTER_ENCODING); }))) {
            mixin(enumMixinStr_SL_METADATA_FILTER_ENCODING);
        }
    }




    static if(!is(typeof(SL_METADATATRAVERSALMODE_ALL))) {
        private enum enumMixinStr_SL_METADATATRAVERSALMODE_ALL = `enum SL_METADATATRAVERSALMODE_ALL = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_METADATATRAVERSALMODE_ALL); }))) {
            mixin(enumMixinStr_SL_METADATATRAVERSALMODE_ALL);
        }
    }




    static if(!is(typeof(SL_METADATATRAVERSALMODE_NODE))) {
        private enum enumMixinStr_SL_METADATATRAVERSALMODE_NODE = `enum SL_METADATATRAVERSALMODE_NODE = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_METADATATRAVERSALMODE_NODE); }))) {
            mixin(enumMixinStr_SL_METADATATRAVERSALMODE_NODE);
        }
    }




    static if(!is(typeof(SL_NODETYPE_UNSPECIFIED))) {
        private enum enumMixinStr_SL_NODETYPE_UNSPECIFIED = `enum SL_NODETYPE_UNSPECIFIED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_NODETYPE_UNSPECIFIED); }))) {
            mixin(enumMixinStr_SL_NODETYPE_UNSPECIFIED);
        }
    }




    static if(!is(typeof(SL_NODETYPE_AUDIO))) {
        private enum enumMixinStr_SL_NODETYPE_AUDIO = `enum SL_NODETYPE_AUDIO = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_NODETYPE_AUDIO); }))) {
            mixin(enumMixinStr_SL_NODETYPE_AUDIO);
        }
    }




    static if(!is(typeof(SL_NODETYPE_VIDEO))) {
        private enum enumMixinStr_SL_NODETYPE_VIDEO = `enum SL_NODETYPE_VIDEO = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_NODETYPE_VIDEO); }))) {
            mixin(enumMixinStr_SL_NODETYPE_VIDEO);
        }
    }




    static if(!is(typeof(SL_NODETYPE_IMAGE))) {
        private enum enumMixinStr_SL_NODETYPE_IMAGE = `enum SL_NODETYPE_IMAGE = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_NODETYPE_IMAGE); }))) {
            mixin(enumMixinStr_SL_NODETYPE_IMAGE);
        }
    }




    static if(!is(typeof(SL_NODE_PARENT))) {
        private enum enumMixinStr_SL_NODE_PARENT = `enum SL_NODE_PARENT = 0xFFFFFFFF;`;
        static if(is(typeof({ mixin(enumMixinStr_SL_NODE_PARENT); }))) {
            mixin(enumMixinStr_SL_NODE_PARENT);
        }
    }




    static if(!is(typeof(SL_PLAYSTATE_STOPPED))) {
        private enum enumMixinStr_SL_PLAYSTATE_STOPPED = `enum SL_PLAYSTATE_STOPPED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYSTATE_STOPPED); }))) {
            mixin(enumMixinStr_SL_PLAYSTATE_STOPPED);
        }
    }




    static if(!is(typeof(SL_PLAYSTATE_PAUSED))) {
        private enum enumMixinStr_SL_PLAYSTATE_PAUSED = `enum SL_PLAYSTATE_PAUSED = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYSTATE_PAUSED); }))) {
            mixin(enumMixinStr_SL_PLAYSTATE_PAUSED);
        }
    }




    static if(!is(typeof(SL_PLAYSTATE_PLAYING))) {
        private enum enumMixinStr_SL_PLAYSTATE_PLAYING = `enum SL_PLAYSTATE_PLAYING = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYSTATE_PLAYING); }))) {
            mixin(enumMixinStr_SL_PLAYSTATE_PLAYING);
        }
    }




    static if(!is(typeof(SL_PLAYEVENT_HEADATEND))) {
        private enum enumMixinStr_SL_PLAYEVENT_HEADATEND = `enum SL_PLAYEVENT_HEADATEND = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYEVENT_HEADATEND); }))) {
            mixin(enumMixinStr_SL_PLAYEVENT_HEADATEND);
        }
    }




    static if(!is(typeof(SL_PLAYEVENT_HEADATMARKER))) {
        private enum enumMixinStr_SL_PLAYEVENT_HEADATMARKER = `enum SL_PLAYEVENT_HEADATMARKER = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYEVENT_HEADATMARKER); }))) {
            mixin(enumMixinStr_SL_PLAYEVENT_HEADATMARKER);
        }
    }




    static if(!is(typeof(SL_PLAYEVENT_HEADATNEWPOS))) {
        private enum enumMixinStr_SL_PLAYEVENT_HEADATNEWPOS = `enum SL_PLAYEVENT_HEADATNEWPOS = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYEVENT_HEADATNEWPOS); }))) {
            mixin(enumMixinStr_SL_PLAYEVENT_HEADATNEWPOS);
        }
    }




    static if(!is(typeof(SL_PLAYEVENT_HEADMOVING))) {
        private enum enumMixinStr_SL_PLAYEVENT_HEADMOVING = `enum SL_PLAYEVENT_HEADMOVING = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYEVENT_HEADMOVING); }))) {
            mixin(enumMixinStr_SL_PLAYEVENT_HEADMOVING);
        }
    }




    static if(!is(typeof(SL_PLAYEVENT_HEADSTALLED))) {
        private enum enumMixinStr_SL_PLAYEVENT_HEADSTALLED = `enum SL_PLAYEVENT_HEADSTALLED = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PLAYEVENT_HEADSTALLED); }))) {
            mixin(enumMixinStr_SL_PLAYEVENT_HEADSTALLED);
        }
    }




    static if(!is(typeof(SL_TIME_UNKNOWN))) {
        private enum enumMixinStr_SL_TIME_UNKNOWN = `enum SL_TIME_UNKNOWN = ( cast( SLuint32 ) 0xFFFFFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_TIME_UNKNOWN); }))) {
            mixin(enumMixinStr_SL_TIME_UNKNOWN);
        }
    }




    static if(!is(typeof(SL_PREFETCHEVENT_STATUSCHANGE))) {
        private enum enumMixinStr_SL_PREFETCHEVENT_STATUSCHANGE = `enum SL_PREFETCHEVENT_STATUSCHANGE = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PREFETCHEVENT_STATUSCHANGE); }))) {
            mixin(enumMixinStr_SL_PREFETCHEVENT_STATUSCHANGE);
        }
    }




    static if(!is(typeof(SL_PREFETCHEVENT_FILLLEVELCHANGE))) {
        private enum enumMixinStr_SL_PREFETCHEVENT_FILLLEVELCHANGE = `enum SL_PREFETCHEVENT_FILLLEVELCHANGE = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PREFETCHEVENT_FILLLEVELCHANGE); }))) {
            mixin(enumMixinStr_SL_PREFETCHEVENT_FILLLEVELCHANGE);
        }
    }




    static if(!is(typeof(SL_PREFETCHSTATUS_UNDERFLOW))) {
        private enum enumMixinStr_SL_PREFETCHSTATUS_UNDERFLOW = `enum SL_PREFETCHSTATUS_UNDERFLOW = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PREFETCHSTATUS_UNDERFLOW); }))) {
            mixin(enumMixinStr_SL_PREFETCHSTATUS_UNDERFLOW);
        }
    }




    static if(!is(typeof(SL_PREFETCHSTATUS_SUFFICIENTDATA))) {
        private enum enumMixinStr_SL_PREFETCHSTATUS_SUFFICIENTDATA = `enum SL_PREFETCHSTATUS_SUFFICIENTDATA = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PREFETCHSTATUS_SUFFICIENTDATA); }))) {
            mixin(enumMixinStr_SL_PREFETCHSTATUS_SUFFICIENTDATA);
        }
    }




    static if(!is(typeof(SL_PREFETCHSTATUS_OVERFLOW))) {
        private enum enumMixinStr_SL_PREFETCHSTATUS_OVERFLOW = `enum SL_PREFETCHSTATUS_OVERFLOW = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_PREFETCHSTATUS_OVERFLOW); }))) {
            mixin(enumMixinStr_SL_PREFETCHSTATUS_OVERFLOW);
        }
    }




    static if(!is(typeof(SL_RATEPROP_RESERVED1))) {
        private enum enumMixinStr_SL_RATEPROP_RESERVED1 = `enum SL_RATEPROP_RESERVED1 = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_RESERVED1); }))) {
            mixin(enumMixinStr_SL_RATEPROP_RESERVED1);
        }
    }




    static if(!is(typeof(SL_RATEPROP_RESERVED2))) {
        private enum enumMixinStr_SL_RATEPROP_RESERVED2 = `enum SL_RATEPROP_RESERVED2 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_RESERVED2); }))) {
            mixin(enumMixinStr_SL_RATEPROP_RESERVED2);
        }
    }




    static if(!is(typeof(SL_RATEPROP_SILENTAUDIO))) {
        private enum enumMixinStr_SL_RATEPROP_SILENTAUDIO = `enum SL_RATEPROP_SILENTAUDIO = ( cast( SLuint32 ) 0x00000100 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_SILENTAUDIO); }))) {
            mixin(enumMixinStr_SL_RATEPROP_SILENTAUDIO);
        }
    }




    static if(!is(typeof(SL_RATEPROP_STAGGEREDAUDIO))) {
        private enum enumMixinStr_SL_RATEPROP_STAGGEREDAUDIO = `enum SL_RATEPROP_STAGGEREDAUDIO = ( cast( SLuint32 ) 0x00000200 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_STAGGEREDAUDIO); }))) {
            mixin(enumMixinStr_SL_RATEPROP_STAGGEREDAUDIO);
        }
    }




    static if(!is(typeof(SL_RATEPROP_NOPITCHCORAUDIO))) {
        private enum enumMixinStr_SL_RATEPROP_NOPITCHCORAUDIO = `enum SL_RATEPROP_NOPITCHCORAUDIO = ( cast( SLuint32 ) 0x00000400 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_NOPITCHCORAUDIO); }))) {
            mixin(enumMixinStr_SL_RATEPROP_NOPITCHCORAUDIO);
        }
    }




    static if(!is(typeof(SL_RATEPROP_PITCHCORAUDIO))) {
        private enum enumMixinStr_SL_RATEPROP_PITCHCORAUDIO = `enum SL_RATEPROP_PITCHCORAUDIO = ( cast( SLuint32 ) 0x00000800 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATEPROP_PITCHCORAUDIO); }))) {
            mixin(enumMixinStr_SL_RATEPROP_PITCHCORAUDIO);
        }
    }




    static if(!is(typeof(SL_SEEKMODE_FAST))) {
        private enum enumMixinStr_SL_SEEKMODE_FAST = `enum SL_SEEKMODE_FAST = ( cast( SLuint32 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SEEKMODE_FAST); }))) {
            mixin(enumMixinStr_SL_SEEKMODE_FAST);
        }
    }




    static if(!is(typeof(SL_SEEKMODE_ACCURATE))) {
        private enum enumMixinStr_SL_SEEKMODE_ACCURATE = `enum SL_SEEKMODE_ACCURATE = ( cast( SLuint32 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_SEEKMODE_ACCURATE); }))) {
            mixin(enumMixinStr_SL_SEEKMODE_ACCURATE);
        }
    }




    static if(!is(typeof(SL_RECORDSTATE_STOPPED))) {
        private enum enumMixinStr_SL_RECORDSTATE_STOPPED = `enum SL_RECORDSTATE_STOPPED = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDSTATE_STOPPED); }))) {
            mixin(enumMixinStr_SL_RECORDSTATE_STOPPED);
        }
    }




    static if(!is(typeof(SL_RECORDSTATE_PAUSED))) {
        private enum enumMixinStr_SL_RECORDSTATE_PAUSED = `enum SL_RECORDSTATE_PAUSED = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDSTATE_PAUSED); }))) {
            mixin(enumMixinStr_SL_RECORDSTATE_PAUSED);
        }
    }




    static if(!is(typeof(SL_RECORDSTATE_RECORDING))) {
        private enum enumMixinStr_SL_RECORDSTATE_RECORDING = `enum SL_RECORDSTATE_RECORDING = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDSTATE_RECORDING); }))) {
            mixin(enumMixinStr_SL_RECORDSTATE_RECORDING);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_HEADATLIMIT))) {
        private enum enumMixinStr_SL_RECORDEVENT_HEADATLIMIT = `enum SL_RECORDEVENT_HEADATLIMIT = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_HEADATLIMIT); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_HEADATLIMIT);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_HEADATMARKER))) {
        private enum enumMixinStr_SL_RECORDEVENT_HEADATMARKER = `enum SL_RECORDEVENT_HEADATMARKER = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_HEADATMARKER); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_HEADATMARKER);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_HEADATNEWPOS))) {
        private enum enumMixinStr_SL_RECORDEVENT_HEADATNEWPOS = `enum SL_RECORDEVENT_HEADATNEWPOS = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_HEADATNEWPOS); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_HEADATNEWPOS);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_HEADMOVING))) {
        private enum enumMixinStr_SL_RECORDEVENT_HEADMOVING = `enum SL_RECORDEVENT_HEADMOVING = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_HEADMOVING); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_HEADMOVING);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_HEADSTALLED))) {
        private enum enumMixinStr_SL_RECORDEVENT_HEADSTALLED = `enum SL_RECORDEVENT_HEADSTALLED = ( cast( SLuint32 ) 0x00000010 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_HEADSTALLED); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_HEADSTALLED);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_BUFFER_INSUFFICIENT))) {
        private enum enumMixinStr_SL_RECORDEVENT_BUFFER_INSUFFICIENT = `enum SL_RECORDEVENT_BUFFER_INSUFFICIENT = ( cast( SLuint32 ) 0x00000020 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_BUFFER_INSUFFICIENT); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_BUFFER_INSUFFICIENT);
        }
    }




    static if(!is(typeof(SL_RECORDEVENT_BUFFER_FULL))) {
        private enum enumMixinStr_SL_RECORDEVENT_BUFFER_FULL = `enum SL_RECORDEVENT_BUFFER_FULL = ( cast( SLuint32 ) 0x00000020 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RECORDEVENT_BUFFER_FULL); }))) {
            mixin(enumMixinStr_SL_RECORDEVENT_BUFFER_FULL);
        }
    }




    static if(!is(typeof(SL_EQUALIZER_UNDEFINED))) {
        private enum enumMixinStr_SL_EQUALIZER_UNDEFINED = `enum SL_EQUALIZER_UNDEFINED = ( cast( SLuint16 ) 0xFFFF );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_EQUALIZER_UNDEFINED); }))) {
            mixin(enumMixinStr_SL_EQUALIZER_UNDEFINED);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_NONE))) {
        private enum enumMixinStr_SL_REVERBPRESET_NONE = `enum SL_REVERBPRESET_NONE = ( cast( SLuint16 ) 0x0000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_NONE); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_NONE);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_SMALLROOM))) {
        private enum enumMixinStr_SL_REVERBPRESET_SMALLROOM = `enum SL_REVERBPRESET_SMALLROOM = ( cast( SLuint16 ) 0x0001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_SMALLROOM); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_SMALLROOM);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_MEDIUMROOM))) {
        private enum enumMixinStr_SL_REVERBPRESET_MEDIUMROOM = `enum SL_REVERBPRESET_MEDIUMROOM = ( cast( SLuint16 ) 0x0002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_MEDIUMROOM); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_MEDIUMROOM);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_LARGEROOM))) {
        private enum enumMixinStr_SL_REVERBPRESET_LARGEROOM = `enum SL_REVERBPRESET_LARGEROOM = ( cast( SLuint16 ) 0x0003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_LARGEROOM); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_LARGEROOM);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_MEDIUMHALL))) {
        private enum enumMixinStr_SL_REVERBPRESET_MEDIUMHALL = `enum SL_REVERBPRESET_MEDIUMHALL = ( cast( SLuint16 ) 0x0004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_MEDIUMHALL); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_MEDIUMHALL);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_LARGEHALL))) {
        private enum enumMixinStr_SL_REVERBPRESET_LARGEHALL = `enum SL_REVERBPRESET_LARGEHALL = ( cast( SLuint16 ) 0x0005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_LARGEHALL); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_LARGEHALL);
        }
    }




    static if(!is(typeof(SL_REVERBPRESET_PLATE))) {
        private enum enumMixinStr_SL_REVERBPRESET_PLATE = `enum SL_REVERBPRESET_PLATE = ( cast( SLuint16 ) 0x0006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_REVERBPRESET_PLATE); }))) {
            mixin(enumMixinStr_SL_REVERBPRESET_PLATE);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT = `enum SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT = { ( cast( SLmillibel ) ( - ( cast( SLmillibel ) 0x7FFF ) - 1 ) ) , 0 , 1000 , 500 , ( cast( SLmillibel ) ( - ( cast( SLmillibel ) 0x7FFF ) - 1 ) ) , 20 , ( cast( SLmillibel ) ( - ( cast( SLmillibel ) 0x7FFF ) - 1 ) ) , 40 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_DEFAULT);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_GENERIC))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_GENERIC = `enum SL_I3DL2_ENVIRONMENT_PRESET_GENERIC = { - 1000 , - 100 , 1490 , 830 , - 2602 , 7 , 200 , 11 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_GENERIC); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_GENERIC);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL = `enum SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL = { - 1000 , - 6000 , 170 , 100 , - 1204 , 1 , 207 , 2 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PADDEDCELL);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_ROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_ROOM = { - 1000 , - 454 , 400 , 830 , - 1646 , 2 , 53 , 3 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM = { - 1000 , - 1200 , 1490 , 540 , - 370 , 7 , 1030 , 11 , 1000 , 600 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_BATHROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM = { - 1000 , - 6000 , 500 , 100 , - 1376 , 3 , - 1104 , 4 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LIVINGROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM = { - 1000 , - 300 , 2310 , 640 , - 711 , 12 , 83 , 17 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONEROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM = `enum SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM = { - 1000 , - 476 , 4320 , 590 , - 789 , 20 , - 289 , 30 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_AUDITORIUM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL = `enum SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL = { - 1000 , - 500 , 3920 , 700 , - 1230 , 20 , - 2 , 29 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CONCERTHALL);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_CAVE))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CAVE = `enum SL_I3DL2_ENVIRONMENT_PRESET_CAVE = { - 1000 , 0 , 2910 , 1300 , - 602 , 15 , - 302 , 22 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CAVE); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CAVE);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_ARENA))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ARENA = `enum SL_I3DL2_ENVIRONMENT_PRESET_ARENA = { - 1000 , - 698 , 7240 , 330 , - 1166 , 20 , 16 , 30 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ARENA); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ARENA);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_HANGAR))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HANGAR = `enum SL_I3DL2_ENVIRONMENT_PRESET_HANGAR = { - 1000 , - 1000 , 10050 , 230 , - 602 , 20 , 198 , 30 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HANGAR); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HANGAR);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY = `enum SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY = { - 1000 , - 4000 , 300 , 100 , - 1831 , 2 , - 1630 , 30 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CARPETEDHALLWAY);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY = `enum SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY = { - 1000 , - 300 , 1490 , 590 , - 1219 , 7 , 441 , 11 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_HALLWAY);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR = `enum SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR = { - 1000 , - 237 , 2700 , 790 , - 1214 , 13 , 395 , 20 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_STONECORRIDOR);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_ALLEY))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ALLEY = `enum SL_I3DL2_ENVIRONMENT_PRESET_ALLEY = { - 1000 , - 270 , 1490 , 860 , - 1204 , 7 , - 4 , 11 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ALLEY); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_ALLEY);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_FOREST))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_FOREST = `enum SL_I3DL2_ENVIRONMENT_PRESET_FOREST = { - 1000 , - 3300 , 1490 , 540 , - 2560 , 162 , - 613 , 88 , 790 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_FOREST); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_FOREST);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_CITY))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CITY = `enum SL_I3DL2_ENVIRONMENT_PRESET_CITY = { - 1000 , - 800 , 1490 , 670 , - 2273 , 7 , - 2217 , 11 , 500 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CITY); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_CITY);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS = `enum SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS = { - 1000 , - 2500 , 1490 , 210 , - 2780 , 300 , - 2014 , 100 , 270 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MOUNTAINS);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_QUARRY))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_QUARRY = `enum SL_I3DL2_ENVIRONMENT_PRESET_QUARRY = { - 1000 , - 1000 , 1490 , 830 , ( cast( SLmillibel ) ( - ( cast( SLmillibel ) 0x7FFF ) - 1 ) ) , 61 , 500 , 25 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_QUARRY); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_QUARRY);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_PLAIN))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLAIN = `enum SL_I3DL2_ENVIRONMENT_PRESET_PLAIN = { - 1000 , - 2000 , 1490 , 500 , - 2466 , 179 , - 2514 , 100 , 210 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLAIN); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLAIN);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT = `enum SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT = { - 1000 , 0 , 1650 , 1500 , - 1363 , 8 , - 1153 , 12 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PARKINGLOT);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE = `enum SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE = { - 1000 , - 1000 , 2810 , 140 , 429 , 14 , 648 , 21 , 800 , 600 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SEWERPIPE);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER = `enum SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER = { - 1000 , - 4000 , 1490 , 100 , - 449 , 7 , 1700 , 11 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_UNDERWATER);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM = { - 1000 , - 600 , 1100 , 830 , - 400 , 5 , 500 , 10 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_SMALLROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM = { - 1000 , - 600 , 1300 , 830 , - 1000 , 20 , - 200 , 20 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM = `enum SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM = { - 1000 , - 600 , 1500 , 830 , - 1600 , 5 , - 1000 , 40 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEROOM);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL = `enum SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL = { - 1000 , - 600 , 1800 , 700 , - 1300 , 15 , - 800 , 30 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_MEDIUMHALL);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL = `enum SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL = { - 1000 , - 600 , 1800 , 700 , - 2000 , 30 , - 1400 , 60 , 1000 , 1000 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_LARGEHALL);
        }
    }




    static if(!is(typeof(SL_I3DL2_ENVIRONMENT_PRESET_PLATE))) {
        private enum enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLATE = `enum SL_I3DL2_ENVIRONMENT_PRESET_PLATE = { - 1000 , - 200 , 1300 , 900 , 0 , 2 , 0 , 10 , 1000 , 750 };`;
        static if(is(typeof({ mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLATE); }))) {
            mixin(enumMixinStr_SL_I3DL2_ENVIRONMENT_PRESET_PLATE);
        }
    }




    static if(!is(typeof(SL_ROLLOFFMODEL_EXPONENTIAL))) {
        private enum enumMixinStr_SL_ROLLOFFMODEL_EXPONENTIAL = `enum SL_ROLLOFFMODEL_EXPONENTIAL = ( cast( SLuint32 ) 0x00000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_ROLLOFFMODEL_EXPONENTIAL); }))) {
            mixin(enumMixinStr_SL_ROLLOFFMODEL_EXPONENTIAL);
        }
    }




    static if(!is(typeof(SL_ROLLOFFMODEL_LINEAR))) {
        private enum enumMixinStr_SL_ROLLOFFMODEL_LINEAR = `enum SL_ROLLOFFMODEL_LINEAR = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_ROLLOFFMODEL_LINEAR); }))) {
            mixin(enumMixinStr_SL_ROLLOFFMODEL_LINEAR);
        }
    }




    static if(!is(typeof(SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR))) {
        private enum enumMixinStr_SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR = `enum SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR); }))) {
            mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RUNTIME_ERROR);
        }
    }




    static if(!is(typeof(SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION))) {
        private enum enumMixinStr_SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION = `enum SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION); }))) {
            mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_ASYNC_TERMINATION);
        }
    }




    static if(!is(typeof(SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST))) {
        private enum enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST = `enum SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST); }))) {
            mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST);
        }
    }




    static if(!is(typeof(SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY))) {
        private enum enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY = `enum SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY); }))) {
            mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_LOST_PERMANENTLY);
        }
    }




    static if(!is(typeof(SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE))) {
        private enum enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE = `enum SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE); }))) {
            mixin(enumMixinStr_SL_DYNAMIC_ITF_EVENT_RESOURCES_AVAILABLE);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_NOTE_ON_OFF))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_NOTE_ON_OFF = `enum SL_MIDIMESSAGETYPE_NOTE_ON_OFF = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_NOTE_ON_OFF); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_NOTE_ON_OFF);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_POLY_PRESSURE))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_POLY_PRESSURE = `enum SL_MIDIMESSAGETYPE_POLY_PRESSURE = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_POLY_PRESSURE); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_POLY_PRESSURE);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_CONTROL_CHANGE))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_CONTROL_CHANGE = `enum SL_MIDIMESSAGETYPE_CONTROL_CHANGE = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_CONTROL_CHANGE); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_CONTROL_CHANGE);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_PROGRAM_CHANGE))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_PROGRAM_CHANGE = `enum SL_MIDIMESSAGETYPE_PROGRAM_CHANGE = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_PROGRAM_CHANGE); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_PROGRAM_CHANGE);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE = `enum SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_CHANNEL_PRESSURE);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_PITCH_BEND))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_PITCH_BEND = `enum SL_MIDIMESSAGETYPE_PITCH_BEND = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_PITCH_BEND); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_PITCH_BEND);
        }
    }




    static if(!is(typeof(SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE))) {
        private enum enumMixinStr_SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE = `enum SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE); }))) {
            mixin(enumMixinStr_SL_MIDIMESSAGETYPE_SYSTEM_MESSAGE);
        }
    }




    static if(!is(typeof(SL_RATECONTROLMODE_CONSTANTBITRATE))) {
        private enum enumMixinStr_SL_RATECONTROLMODE_CONSTANTBITRATE = `enum SL_RATECONTROLMODE_CONSTANTBITRATE = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATECONTROLMODE_CONSTANTBITRATE); }))) {
            mixin(enumMixinStr_SL_RATECONTROLMODE_CONSTANTBITRATE);
        }
    }




    static if(!is(typeof(SL_RATECONTROLMODE_VARIABLEBITRATE))) {
        private enum enumMixinStr_SL_RATECONTROLMODE_VARIABLEBITRATE = `enum SL_RATECONTROLMODE_VARIABLEBITRATE = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_RATECONTROLMODE_VARIABLEBITRATE); }))) {
            mixin(enumMixinStr_SL_RATECONTROLMODE_VARIABLEBITRATE);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_PCM))) {
        private enum enumMixinStr_SL_AUDIOCODEC_PCM = `enum SL_AUDIOCODEC_PCM = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_PCM); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_PCM);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_MP3))) {
        private enum enumMixinStr_SL_AUDIOCODEC_MP3 = `enum SL_AUDIOCODEC_MP3 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_MP3); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_MP3);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_AMR))) {
        private enum enumMixinStr_SL_AUDIOCODEC_AMR = `enum SL_AUDIOCODEC_AMR = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_AMR); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_AMR);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_AMRWB))) {
        private enum enumMixinStr_SL_AUDIOCODEC_AMRWB = `enum SL_AUDIOCODEC_AMRWB = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_AMRWB); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_AMRWB);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_AMRWBPLUS))) {
        private enum enumMixinStr_SL_AUDIOCODEC_AMRWBPLUS = `enum SL_AUDIOCODEC_AMRWBPLUS = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_AMRWBPLUS); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_AMRWBPLUS);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_AAC))) {
        private enum enumMixinStr_SL_AUDIOCODEC_AAC = `enum SL_AUDIOCODEC_AAC = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_AAC); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_AAC);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_WMA))) {
        private enum enumMixinStr_SL_AUDIOCODEC_WMA = `enum SL_AUDIOCODEC_WMA = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_WMA); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_WMA);
        }
    }




    static if(!is(typeof(SL_AUDIOCODEC_REAL))) {
        private enum enumMixinStr_SL_AUDIOCODEC_REAL = `enum SL_AUDIOCODEC_REAL = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCODEC_REAL); }))) {
            mixin(enumMixinStr_SL_AUDIOCODEC_REAL);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_PCM))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_PCM = `enum SL_AUDIOPROFILE_PCM = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_PCM); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_PCM);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_MPEG1_L3))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_MPEG1_L3 = `enum SL_AUDIOPROFILE_MPEG1_L3 = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG1_L3); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG1_L3);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_MPEG2_L3))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_MPEG2_L3 = `enum SL_AUDIOPROFILE_MPEG2_L3 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG2_L3); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG2_L3);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_MPEG25_L3))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_MPEG25_L3 = `enum SL_AUDIOPROFILE_MPEG25_L3 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG25_L3); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_MPEG25_L3);
        }
    }




    static if(!is(typeof(SL_AUDIOCHANMODE_MP3_MONO))) {
        private enum enumMixinStr_SL_AUDIOCHANMODE_MP3_MONO = `enum SL_AUDIOCHANMODE_MP3_MONO = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_MONO); }))) {
            mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_MONO);
        }
    }




    static if(!is(typeof(SL_AUDIOCHANMODE_MP3_STEREO))) {
        private enum enumMixinStr_SL_AUDIOCHANMODE_MP3_STEREO = `enum SL_AUDIOCHANMODE_MP3_STEREO = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_STEREO); }))) {
            mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_STEREO);
        }
    }




    static if(!is(typeof(SL_AUDIOCHANMODE_MP3_JOINTSTEREO))) {
        private enum enumMixinStr_SL_AUDIOCHANMODE_MP3_JOINTSTEREO = `enum SL_AUDIOCHANMODE_MP3_JOINTSTEREO = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_JOINTSTEREO); }))) {
            mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_JOINTSTEREO);
        }
    }




    static if(!is(typeof(SL_AUDIOCHANMODE_MP3_DUAL))) {
        private enum enumMixinStr_SL_AUDIOCHANMODE_MP3_DUAL = `enum SL_AUDIOCHANMODE_MP3_DUAL = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_DUAL); }))) {
            mixin(enumMixinStr_SL_AUDIOCHANMODE_MP3_DUAL);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_AMR))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_AMR = `enum SL_AUDIOPROFILE_AMR = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_AMR); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_AMR);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_CONFORMANCE))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_CONFORMANCE = `enum SL_AUDIOSTREAMFORMAT_CONFORMANCE = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_CONFORMANCE); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_CONFORMANCE);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_IF1))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_IF1 = `enum SL_AUDIOSTREAMFORMAT_IF1 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_IF1); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_IF1);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_IF2))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_IF2 = `enum SL_AUDIOSTREAMFORMAT_IF2 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_IF2); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_IF2);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_FSF))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_FSF = `enum SL_AUDIOSTREAMFORMAT_FSF = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_FSF); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_FSF);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_RTPPAYLOAD))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_RTPPAYLOAD = `enum SL_AUDIOSTREAMFORMAT_RTPPAYLOAD = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_RTPPAYLOAD); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_RTPPAYLOAD);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_ITU))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_ITU = `enum SL_AUDIOSTREAMFORMAT_ITU = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_ITU); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_ITU);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_AMRWB))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_AMRWB = `enum SL_AUDIOPROFILE_AMRWB = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_AMRWB); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_AMRWB);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_AMRWBPLUS))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_AMRWBPLUS = `enum SL_AUDIOPROFILE_AMRWBPLUS = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_AMRWBPLUS); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_AMRWBPLUS);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_AAC_AAC))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_AAC_AAC = `enum SL_AUDIOPROFILE_AAC_AAC = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_AAC_AAC); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_AAC_AAC);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_MAIN))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_MAIN = `enum SL_AUDIOMODE_AAC_MAIN = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_MAIN); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_MAIN);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_LC))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_LC = `enum SL_AUDIOMODE_AAC_LC = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_LC); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_LC);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_SSR))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_SSR = `enum SL_AUDIOMODE_AAC_SSR = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_SSR); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_SSR);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_LTP))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_LTP = `enum SL_AUDIOMODE_AAC_LTP = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_LTP); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_LTP);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_HE))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_HE = `enum SL_AUDIOMODE_AAC_HE = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_SCALABLE))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_SCALABLE = `enum SL_AUDIOMODE_AAC_SCALABLE = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_SCALABLE); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_SCALABLE);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_ERLC))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_ERLC = `enum SL_AUDIOMODE_AAC_ERLC = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_ERLC); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_ERLC);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_LD))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_LD = `enum SL_AUDIOMODE_AAC_LD = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_LD); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_LD);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_HE_PS))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_HE_PS = `enum SL_AUDIOMODE_AAC_HE_PS = ( cast( SLuint32 ) 0x00000009 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE_PS); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE_PS);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_AAC_HE_MPS))) {
        private enum enumMixinStr_SL_AUDIOMODE_AAC_HE_MPS = `enum SL_AUDIOMODE_AAC_HE_MPS = ( cast( SLuint32 ) 0x0000000A );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE_MPS); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_AAC_HE_MPS);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_MP2ADTS))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_MP2ADTS = `enum SL_AUDIOSTREAMFORMAT_MP2ADTS = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP2ADTS); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP2ADTS);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_MP4ADTS))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4ADTS = `enum SL_AUDIOSTREAMFORMAT_MP4ADTS = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4ADTS); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4ADTS);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_MP4LOAS))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LOAS = `enum SL_AUDIOSTREAMFORMAT_MP4LOAS = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LOAS); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LOAS);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_MP4LATM))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LATM = `enum SL_AUDIOSTREAMFORMAT_MP4LATM = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LATM); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4LATM);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_ADIF))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_ADIF = `enum SL_AUDIOSTREAMFORMAT_ADIF = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_ADIF); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_ADIF);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_MP4FF))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4FF = `enum SL_AUDIOSTREAMFORMAT_MP4FF = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4FF); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_MP4FF);
        }
    }




    static if(!is(typeof(SL_AUDIOSTREAMFORMAT_RAW))) {
        private enum enumMixinStr_SL_AUDIOSTREAMFORMAT_RAW = `enum SL_AUDIOSTREAMFORMAT_RAW = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_RAW); }))) {
            mixin(enumMixinStr_SL_AUDIOSTREAMFORMAT_RAW);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_WMA7))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_WMA7 = `enum SL_AUDIOPROFILE_WMA7 = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_WMA7); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_WMA7);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_WMA8))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_WMA8 = `enum SL_AUDIOPROFILE_WMA8 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_WMA8); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_WMA8);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_WMA9))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_WMA9 = `enum SL_AUDIOPROFILE_WMA9 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_WMA9); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_WMA9);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_WMA10))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_WMA10 = `enum SL_AUDIOPROFILE_WMA10 = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_WMA10); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_WMA10);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMA_LEVEL1))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMA_LEVEL1 = `enum SL_AUDIOMODE_WMA_LEVEL1 = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL1); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL1);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMA_LEVEL2))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMA_LEVEL2 = `enum SL_AUDIOMODE_WMA_LEVEL2 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL2); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL2);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMA_LEVEL3))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMA_LEVEL3 = `enum SL_AUDIOMODE_WMA_LEVEL3 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL3); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL3);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMA_LEVEL4))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMA_LEVEL4 = `enum SL_AUDIOMODE_WMA_LEVEL4 = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL4); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMA_LEVEL4);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMAPRO_LEVELM0))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM0 = `enum SL_AUDIOMODE_WMAPRO_LEVELM0 = ( cast( SLuint32 ) 0x00000005 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM0); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM0);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMAPRO_LEVELM1))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM1 = `enum SL_AUDIOMODE_WMAPRO_LEVELM1 = ( cast( SLuint32 ) 0x00000006 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM1); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM1);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMAPRO_LEVELM2))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM2 = `enum SL_AUDIOMODE_WMAPRO_LEVELM2 = ( cast( SLuint32 ) 0x00000007 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM2); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM2);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_WMAPRO_LEVELM3))) {
        private enum enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM3 = `enum SL_AUDIOMODE_WMAPRO_LEVELM3 = ( cast( SLuint32 ) 0x00000008 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM3); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_WMAPRO_LEVELM3);
        }
    }




    static if(!is(typeof(SL_AUDIOPROFILE_REALAUDIO))) {
        private enum enumMixinStr_SL_AUDIOPROFILE_REALAUDIO = `enum SL_AUDIOPROFILE_REALAUDIO = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOPROFILE_REALAUDIO); }))) {
            mixin(enumMixinStr_SL_AUDIOPROFILE_REALAUDIO);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_REALAUDIO_G2))) {
        private enum enumMixinStr_SL_AUDIOMODE_REALAUDIO_G2 = `enum SL_AUDIOMODE_REALAUDIO_G2 = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_G2); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_G2);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_REALAUDIO_8))) {
        private enum enumMixinStr_SL_AUDIOMODE_REALAUDIO_8 = `enum SL_AUDIOMODE_REALAUDIO_8 = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_8); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_8);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_REALAUDIO_10))) {
        private enum enumMixinStr_SL_AUDIOMODE_REALAUDIO_10 = `enum SL_AUDIOMODE_REALAUDIO_10 = ( cast( SLuint32 ) 0x00000003 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_10); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_10);
        }
    }




    static if(!is(typeof(SL_AUDIOMODE_REALAUDIO_SURROUND))) {
        private enum enumMixinStr_SL_AUDIOMODE_REALAUDIO_SURROUND = `enum SL_AUDIOMODE_REALAUDIO_SURROUND = ( cast( SLuint32 ) 0x00000004 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_SURROUND); }))) {
            mixin(enumMixinStr_SL_AUDIOMODE_REALAUDIO_SURROUND);
        }
    }




    static if(!is(typeof(SL_ENGINEOPTION_THREADSAFE))) {
        private enum enumMixinStr_SL_ENGINEOPTION_THREADSAFE = `enum SL_ENGINEOPTION_THREADSAFE = ( cast( SLuint32 ) 0x00000001 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_ENGINEOPTION_THREADSAFE); }))) {
            mixin(enumMixinStr_SL_ENGINEOPTION_THREADSAFE);
        }
    }




    static if(!is(typeof(SL_ENGINEOPTION_LOSSOFCONTROL))) {
        private enum enumMixinStr_SL_ENGINEOPTION_LOSSOFCONTROL = `enum SL_ENGINEOPTION_LOSSOFCONTROL = ( cast( SLuint32 ) 0x00000002 );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_ENGINEOPTION_LOSSOFCONTROL); }))) {
            mixin(enumMixinStr_SL_ENGINEOPTION_LOSSOFCONTROL);
        }
    }






    static if(!is(typeof(SL_API))) {
        private enum enumMixinStr_SL_API = `enum SL_API = __declspec ( dllimport );`;
        static if(is(typeof({ mixin(enumMixinStr_SL_API); }))) {
            mixin(enumMixinStr_SL_API);
        }
    }





}
