# BindBC-OpenSLES

The reasoning on this project is to generate a D binding to OpenSLES, an audio library for embedded systems.

It is using [bindbc-generator](https://www.github.com/MrcSnm/bindbc-generator) for bind automation.
Initially, I plan to use bindbc-generator as a starting point for this project and maintain what was generated
after that.

I'm not too bothered about distribution right now, so, use it at your risk, this API is not beginner friendly, right now, I'm building a interface for easier use, which will include decoding.

The JNI found here, is from [@adamdruppe/arsd](https://www.github.com/adamdruppe/arsd) as it is the best implementation I could find.

## WARNING

This is a static-binding only. I didn't care about dynamic bindings right now because much of the API is made from callbacks and I don't know how much those would work at a binding.


## Update

Bindbc-Generator wasn't actually needed as OpenSL ES follows a structure close to what a COM interface is.
> Actually, the only needed from the bindbc-generator was dpp, which started the project, and now I'm maintaining without any bind generators, as this is a stable API and won't change it much.

Together with the OpenSL ES, I'm providing a useful interface I'm using for easier use,but you won't actually need anything more than what's on bindbc folder.



The current main target for this project is to execute it on Android.
