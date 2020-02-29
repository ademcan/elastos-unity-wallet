# React Native Elastos Wallet Plugin

The Elastos Unity wallet repository provides all the necessary code to port the wallet functionnalities to React Native. Developers can use the Elastos Unity wallet module to implement the Elastos wallet functionalities into their app.
Elastos Wallet is used to manage private and public keys and to make transactions on the Elastos network, including DID sidechain.

## Getting started

Due to the size limitation of npmjs.org, the Elastos Unity wallet module is actually available via git install from the npm command:
`$ npm install github:cyber-republic/elastos-unity-wallet --save`

### Mostly automatic installation

`$ react-native link elastos-unity-wallet`

Then, for only Android, it needs to follow the following Manual Installation Android Step 4.

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-elastos-wallet-core` and add `RNElastosMainchain.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNElastosMainchain.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import org.elastos.mainchain.reactnative.RNElastosMainchainPackage;` to the imports at the top of the file
  - Add `new RNElastosMainchainPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-elastos-wallet-core'
  	project(':react-native-elastos-wallet-core').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-elastos-wallet-core/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
    implementation project(':react-native-elastos-wallet-core')
  	```
4. Insert the following lines inside the android block in `android/app/build.gradle`:
  	```
    packagingOptions {
        pickFirst '**/libc++_shared.so'
    }
  	```

## Usage
```javascript
import RNElastosMainchain from 'react-native-elastos-wallet-core';

// Generate a new mnemonic (defaults to English)
RNElastosMainchain.generateMnemonic((err, mnemonic) => {
    console.log(mnemonic)
});
```

The complete documentation is available on: 
