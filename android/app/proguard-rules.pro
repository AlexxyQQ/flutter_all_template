# R8 rules for release builds (isMinifyEnabled = true).
# The Flutter Gradle plugin already adds the Flutter engine rules, and Firebase /
# AndroidX libraries ship their own consumer rules. Add rules here only for code
# reached via reflection (plugins, JSON/Gson models, JNI).

# Flutter embedding & plugins (defensive; normally covered by the Flutter plugin).
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter's deferred-components support references Play Core, which this app
# does not bundle. Without these R8 fails with "Missing class" errors.
-dontwarn com.google.android.play.core.**

# Firebase Cloud Messaging.
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.**

# awesome_notifications (uses reflection to restore notification models).
-keep class me.carda.awesome_notifications.** { *; }
-dontwarn me.carda.awesome_notifications.**

# Keep annotations / generic signatures used by Gson-style serializers.
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep crash stack traces readable (upload the mapping file to your crash reporter).
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
