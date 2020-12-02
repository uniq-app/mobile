# uniq

This is mood board application for mobile devices!

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Preparation for using Flutter and virtual emulation
Here's a quick guide that will take you by the hand and won't let you down (hopefully).

## Flutter installation - Windows

1. Go to this [website](https://flutter.dev/docs/get-started/install/windows) and get the Flutter SDK.
2. Unzip the zip archive in a folder (C:\flutter\).
3. Update the system path to include flutter bin directory (C:\flutter\bin).
4. Praise.

## Android Studio installation
1. Download and install from [here](https://developer.android.com/studio).
2. Go to the plugins (File → Settings → Plugins), find Flutter and install it.
3. Flutter instalation will trigger instalation of Dart as well - nothing to worry about.
4. Restart IDE.
5. Praise again.


## Setting up the emulator
1. Have a lot of free space on your system drive (like a LOT)
2. Click AVD Manager - icon with Android head and the phone behind it - 4th icon from the right at the top.
3. Create Virtual Device
4. Next, next, Finish

If anything goes wrong [here](https://developer.android.com/studio/run/managing-avds) is a proper guide.


## Doctor! My Flutter does not work...

Use the super-secret-command in CMD to check what is wrong:

```bash
flutter doctor
```

## After installing powyższe rzeczy..

1. Go to root folder.
2. Run in terminal 
```bash
flutter packages get
```
