package org.elastos.mainchain.reactnative;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import android.util.Log;

import org.elastos.wallet.lib.ElastosWallet;
import org.elastos.wallet.lib.ElastosWalletDID;
import org.elastos.wallet.lib.ElastosWalletHD;
import org.elastos.wallet.lib.ElastosWalletSign;

public class RNElastosMainchainModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String TAG = "WalletPlugin";
    private ElastosWallet.Data mSeed;
    private int mSeedLen;

    public RNElastosMainchainModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNElastosMainchain";
    }

    @ReactMethod
    public void generateMnemonic(Callback callback) {
        String message = "";

        String language = "english";
        String words = "";

        String mnemonic = ElastosWallet.generateMnemonic(language, words);
        if (mnemonic == null) {
            String errmsg = "Failed to generate mnemonic.";
            Log.e(TAG, errmsg);
            message += errmsg;
            callback.invoke(null, message);
        }
//        message += mnemonic;
//
//        mSeed = new ElastosWallet.Data();
//        int ret = ElastosWallet.getSeedFromMnemonic(mSeed, mnemonic, language, words, "0");
//        if (ret <= 0) {
//            String errmsg = "Failed to get seed from mnemonic. ret=" + ret + "\n";
//            Log.e(TAG, errmsg);
//            message += errmsg;
//            callback.invoke(null, message);
//        }
//        mSeedLen = ret;
//        message += "seed: " + mSeed.buf + ", len: " + mSeedLen + "\n";
//
//        String privateKey = ElastosWallet.getSinglePrivateKey(mSeed, mSeedLen);
//        if (privateKey == null) {
//            String errmsg = "Failed to generate privateKey.\n";
//            Log.e(TAG, errmsg);
//            message += errmsg;
//
//            callback.invoke(null, message);
//        }
//        message += "privateKey: " + privateKey + "\n";
//
//        String publicKey = ElastosWallet.getSinglePublicKey(mSeed, mSeedLen);
//        if (publicKey == null) {
//            String errmsg = "Failed to generate publicKey.\n";
//            Log.e(TAG, errmsg);
//            message += errmsg;
//
//            callback.invoke(null, message);
//        }
//        message += "publicKey: " + publicKey + "\n";
//
//        String address = ElastosWallet.getAddress(publicKey);
//        if (address == null) {
//            String errmsg = "Failed to get address.\n";
//            Log.e(TAG, errmsg);
//            message += errmsg;
//
//            callback.invoke(null, message);
//        }
//        message += "address: " + address + "\n";
//
//
//        ElastosWallet.Data data = new ElastosWallet.Data();
//        data.buf = new byte[]{0, 1, 2, 3, 4, 5};
//        ElastosWallet.Data signedData = new ElastosWallet.Data();
//        int signedLen = ElastosWallet.sign(privateKey, data, data.buf.length, signedData);
//        if (signedLen <= 0) {
//            String errmsg = "Failed to sign data.\n";
//            Log.e(TAG, errmsg);
//            message += errmsg;
//
//            callback.invoke(null, message);
//        }
//
//        boolean verified = ElastosWallet.verify(publicKey, data, data.buf.length, signedData, signedLen);
//        message += "verified: " + verified + "\n";
//
//        message += "================================================\n";
//        callback.invoke(null, message);
        callback.invoke(null, mnemonic);
    }

    @ReactMethod
    public void getSinglePrivateKey(Callback callback) {
        String mnemonic = ElastosWallet.generateMnemonic("english", "");
        mSeed = new ElastosWallet.Data();
        mSeedLen = ElastosWallet.getSeedFromMnemonic(mSeed, mnemonic, "english", "", "0");
        String privateKey = ElastosWallet.getSinglePrivateKey(mSeed, mSeedLen);
        callback.invoke(null, privateKey);
    }

    @ReactMethod
    public void getSinglePublicKey(Callback callback) {
        String mnemonic = ElastosWallet.generateMnemonic("english", "");
        mSeed = new ElastosWallet.Data();
        mSeedLen = ElastosWallet.getSeedFromMnemonic(mSeed, mnemonic, "english", "", "0");
        String publicKey = ElastosWallet.getSinglePublicKey(mSeed, mSeedLen);
        callback.invoke(null, publicKey);
    }
}