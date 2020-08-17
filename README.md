# Grocery Delivery App

Grocery Delivery App

## Getting Started

### Create `.env` file in root folder

Add these following in env variable 
```
API_URL=
ONE_SIGNAL_KEY=
ANDROID_GOOGLE_MAP_API_KEY=
IOS_GOOGLE_MAP_API_KEY=
PREDEFINED=
```

### before doing flutter run. run this command once.

if you close terminal you need to run this command again.
```
source .env; export ANDROID_GOOGLE_MAP_API_KEY=$ANDROID_GOOGLE_MAP_API_KEY;
```

for windows user need to set environment variables separately. using
```
set ANDROID_GOOGLE_MAP_API_KEY=
```


### to generate new icons & splash for android and ios.

replace new images on lib/assets/logo.png (1024px*1024px) & lib/assets/splash.png (375px*812px) and run following commands.
```
cp lib/assets/logo.png ios/Runner/Assets.xcassets/AppIcon.appiconset/ItunesArtwork@2x.png
cp lib/assets/splash.png android/app/src/main/res/drawable/splash.png
flutter packages pub get
flutter pub run flutter_launcher_icons:main
```