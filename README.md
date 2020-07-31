# Grocery Delivery App

Grocery Delivery App

## Getting Started

### Create `.env` file in root folder

Add these following in env variable 
```
APPLICATION_NAME='here_with_single_quotes'
API_URL=
ONE_SIGNAL_KEY=
GOOGLE_MAP_API_KEY=
```

### before doing flutter run. run this command once.

if you close terminal you need to run this command again.

```
source .env; export APPLICATION_NAME=$APPLICATION_NAME; export GOOGLE_MAP_API_KEY=$GOOGLE_MAP_API_KEY;
```

for windows user need to set environment variables separately. using
```
set GOOGLE_MAP_API_KEY=
set APPLICATION_NAME=
```


### to generate new launcher icons for android and ios.

replace lib/assets/logo.png and run this command
```
flutter pub run flutter_launcher_icons:main
```