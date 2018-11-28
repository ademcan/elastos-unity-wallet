package org.elastos.mainchain.reactnative;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import org.elastos.elastoswallet.*;

public class RNElastosMainchainModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String TAG = "WalletPlugin";

    public String rootPath;

    public MasterWalletManager walletManager;
    public String language;

    public RNElastosMainchainModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;

        rootPath = reactContext.getFilesDir().getParent();
        ElastosWalletUtils.InitConfig(reactContext, rootPath);
        walletManager = new MasterWalletManager(rootPath);
        language = "english";
    }

    @Override
    public String getName() {
        return "RNElastosMainchain";
    }

    @ReactMethod
    public void generateMnemonic(Callback callback) {
        String message = "";
        String mnemonic = walletManager.GenerateMnemonic(language);
        message = "mnemonic: " + mnemonic + "\n";

        String masterWalletId = "masterWalletId";
        String phrasePassword = "";
        String payPassword = "elastos2018";
        IMasterWallet masterWallet = walletManager.CreateMasterWallet(masterWalletId, mnemonic, phrasePassword, payPassword, language);
        message += "PublicKey: " + masterWallet.GetPublicKey() + "\n";

        String chainID = "ELA";
        boolean singleAddress = false;
        long feePerKb = 10000; //SELA
        ISubWallet subWallet = masterWallet.CreateSubWallet(chainID, payPassword, singleAddress, feePerKb);
        message += "Balance: " + String.valueOf(subWallet.GetBalance()) + "\n";
        message += "Address: " + subWallet.CreateAddress() + "\n";

        callback.invoke(null, message);
    }
}