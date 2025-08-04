# Flutter's default rules are configured in gradle.
# By default, Flutter builds in release mode with R8 enabled.
# R8 performs code shrinking, which may remove classes needed by your app.
#
# To prevent R8 from removing classes that are needed by your app,
# you can add rules to this file.
#
# For more information, see:
# https://developer.android.com/studio/build/shrink-code

# tflite_flutter
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
