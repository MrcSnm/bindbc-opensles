set androidPath=C:\Users\Hipreme\AppData\Local\Android\Sdk\ndk\21.3.6528147\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\aarch64-linux-android\21\

set bindbcSrc=../bindbc/OpenSLES/types.d ../bindbc/OpenSLES/android.d ../bindbc/OpenSLES/android_metadata.d ../bindbc/OpenSLES/android_configuration.d
@REM set bindbcSrc=../bindbc/OpenSLES/sles.d

ldc2 -I=../bindbc -L=-L%androidPath%  -L=-lOpenSLES -L=-llog -mtriple=aarch64--linux-android --shared opensles_interface.d opensles_helper.d opensles_utils.d %bindbcSrc% jni.d

if %errorlevel%==0 (
	MOVE libopensles_interface.so D:\Programming\Android\Apps\app\src\main\jniLibs\arm64-v8a
	cd D:\Programming\Android\Apps
	@REM gradlew assembleDebug
	@REM adb shell am start -n "com.hipreme.zenambience/com.hipreme.zenambience.MainActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
	cd D:\Programming\Open\bindbc-opensles\source
)