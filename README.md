# react-native-elastos-mainchain

## Getting started

`$ npm install react-native-elastos-mainchain --save`

### Mostly automatic installation

`$ react-native link react-native-elastos-mainchain`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-elastos-mainchain` and add `RNElastosMainchain.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNElastosMainchain.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import org.elastos.mainchain.reactnative.RNElastosMainchainPackage;` to the imports at the top of the file
  - Add `new RNElastosMainchainPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-elastos-mainchain'
  	project(':react-native-elastos-mainchain').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-elastos-mainchain/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-elastos-mainchain')
  	```


## Usage
```javascript
import RNElastosMainchain from 'react-native-elastos-mainchain';

// TODO: What to do with the module?
RNElastosMainchain;
```
  