<a href="https://nocturne.app"><img src="https://i.imgur.com/3b14zAm.png" align="left" height="114" width="387"/></a>      

<br>

**A simple React Native wrapper for Drift.com platform.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


## Getting started

`$ npm install react-native-drift --save`

### Mostly automatic installation

`$ react-native link react-native-drift`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-drift` and add `RNDrift.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDrift.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import app.nocturne.libs.drift.RNDriftPackage;` to the imports at the top of the file
  - Add `new RNDriftPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-drift'
  	project(':react-native-drift').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-drift/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-drift')
  	```


## Usage
```javascript
import Drift from 'react-native-drift';

// Init Drift - https://app.drift.com/settings/livechat
Drift.setup("YOUR API TOKEN");

// Create a user
Drift.registerUser("unique id of the user", "email");

// Logout user
Drift.logout();

// Display conversations view
Drift.showConversations();

// Display create conversation view
Drift.showCreateConversation();

```
  