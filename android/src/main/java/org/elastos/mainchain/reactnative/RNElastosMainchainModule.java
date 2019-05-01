package org.elastos.mainchain.reactnative;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import org.elastos.spvcore.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;

public class RNElastosMainchainModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String TAG = "WalletPlugin";

    public String rootPath;

    public MasterWalletManager walletManager;
    public IMasterWallet masterWallet;
    public ISubWallet subWallet;
    public String language;
    public String mnemonic;
    public String masterWalletId;
    public String phrasePassword;
    public String payPassword;
    public boolean singleAddress;
    public long feePerKb;

    public RNElastosMainchainModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;

        rootPath = reactContext.getFilesDir().getParent();
        ElastosWalletUtils.InitConfig(reactContext, rootPath);
        walletManager = new MasterWalletManager(rootPath);
        mnemonic = "";
        language = "english";
        masterWalletId = "masterWalletId";
        phrasePassword = "";
        payPassword = "elastos2018";
        singleAddress = false;
        feePerKb = 10000; //SELA
    }

    @Override
    public String getName() {
        return "RNElastosMainchain";
    }

    public void addCallbackMethod() {
        subWallet.AddCallback(new ISubWalletCallback() {
            @Override public void OnTransactionStatusChanged(String txId, String status, String desc, int confirms) {
                Log.e("Wallet Info", "txId: " + txId + " status: " + status + " desc: " + desc + " confirms: " + String.valueOf(confirms));
            }
            @Override public void OnBlockSyncStarted() {
                Log.e("Wallet Info", "BlockSyncStarted");
            }

            @Override public void OnBlockSyncProgress(int currentBlockHeight, int estimatedHeight) {
                Log.e("Wallet Info", "currentBlockHeight: " + String.valueOf(currentBlockHeight) + " estimatedHeight: " + String.valueOf(estimatedHeight));
            }
            @Override public void OnBlockSyncStopped() {
                Log.e("Wallet Info", "BlockSyncStopped");
            }

            @Override
            public void OnBalanceChanged(String asset, long balance) {
                Log.e("Wallet Info", "asset: " + asset + "balance: " + String.valueOf(balance));
            }

            @Override
            public void OnTxPublished(String hash, String result) {
                Log.e("Wallet Info", "hash: " + hash + "result " + result);
            }

            @Override
            public void OnTxDeleted(String hash, boolean notifyUser, boolean recommendRescan) {
                Log.e("Wallet Info", "hash: " + hash + "notifyUser: " + (notifyUser ? "true" : "false") + "recommendRescan: " + (recommendRescan ? "true" : "false"));
            }
        });
    }

    @ReactMethod
    public void GenerateMnemonic(Callback callback) {
        String newMnemonic = walletManager.GenerateMnemonic(language);
        callback.invoke(null, newMnemonic);
    }

    @ReactMethod
    public void ImportWalletWithMnemonic(String mnemonic, Callback callback) {
        masterWallet = walletManager.ImportWalletWithMnemonic(masterWalletId, mnemonic, phrasePassword, payPassword, singleAddress);
        String chainID = "ELA";
        subWallet = masterWallet.CreateSubWallet(chainID, feePerKb);
        addCallbackMethod();
        callback.invoke(null, "success");
    }

    @ReactMethod
    public void ExportWalletWithMnemonic(String payPassword, Callback callback) {
        String walletStr = walletManager.ExportWalletWithMnemonic(masterWallet, payPassword);
        callback.invoke(null, walletStr);
    }

    @ReactMethod
    public void GetMultiSignPubKeyWithMnemonic(String mnemonic, Callback callback) {
        String multiSignPubKey = walletManager.GetMultiSignPubKeyWithMnemonic(mnemonic, phrasePassword);
        callback.invoke(null, multiSignPubKey);
    }

    @ReactMethod
    public void GetMultiSignPubKeyWithPrivKey(String privKey, Callback callback) {
        String multiSignPubKey = walletManager.GetMultiSignPubKeyWithPrivKey(privKey);
        callback.invoke(null, multiSignPubKey);
    }

    @ReactMethod
    public void CreateWallet(String mnemonic, Callback callback) {
        masterWallet = walletManager.CreateMasterWallet(masterWalletId, mnemonic, phrasePassword, payPassword, singleAddress);
        String chainID = "ELA";
        subWallet = masterWallet.CreateSubWallet(chainID, feePerKb);
        addCallbackMethod();
        callback.invoke(null, "success");
    }

    @ReactMethod
    public void CreateMultiSignMasterWallet(String masterWallet, String privKey, String payPassword, String coSigners, int requiredSignCount, Callback callback) {
        this.masterWallet = walletManager.CreateMultiSignMasterWallet(masterWallet, privKey, payPassword, coSigners, requiredSignCount);
        String chainID = "ELA";
        subWallet = this.masterWallet.CreateSubWallet(chainID, feePerKb);
        addCallbackMethod();
        callback.invoke(null, "success");
    }

    @ReactMethod
    public void GetPublicKey(Callback callback) {
        String publicKey = subWallet.GetPublicKey();
        callback.invoke(null, publicKey);
    }

    @ReactMethod
    public void IsAddressValid(String address, Callback callback) {
        boolean flag = masterWallet.IsAddressValid(address);
        callback.invoke(null, flag);
    }

    @ReactMethod
    public void GetSupportedChains(Callback callback) {
        String[] supportedChains = masterWallet.GetSupportedChains();
        callback.invoke(null, Arrays.toString(supportedChains));
    }

    @ReactMethod
    public void ChangePassword(String oldPassword, String newPassword, Callback callback) {
        masterWallet.ChangePassword(oldPassword, newPassword);
        callback.invoke(null, "success");
    }

    @ReactMethod
    public void CreateAddress(Callback callback) {
        String newAddress = subWallet.CreateAddress();
        callback.invoke(null, newAddress);
    }

    @ReactMethod
    public void GetBalance(int balanceType, Callback callback) {
        //    enum BalanceType {
        //        Default,
        //        Voted,
        //        Total,
        //    };
        long balance = subWallet.GetBalance(balanceType);
        callback.invoke(null, String.valueOf(balance));
    }

    @ReactMethod
    public void GetBalanceInfo(Callback callback) {
        String balanceInfo = subWallet.GetBalanceInfo();
        callback.invoke(null, balanceInfo);
    }

    @ReactMethod
    public void GetBalanceWithAddress(String address, int balanceType, Callback callback) {
        long balance = subWallet.GetBalanceWithAddress(address, balanceType);
        callback.invoke(null, String.valueOf(balance));
    }

    @ReactMethod
    public void GetAllAddress(Callback callback) throws JSONException {
        JSONArray allAddress = new JSONArray();
        for (int i = 0; ; i++){
            String address = new JSONObject(subWallet.GetAllAddress(i,1)).getJSONArray("Addresses").get(0).toString();
            try {
                JSONObject transaction = new JSONObject(subWallet.GetAllTransaction(0, 100, address));
                if (transaction.isNull("Transactions")) break;
                JSONArray transactionField = transaction.getJSONArray("Transactions");
                int length = transactionField.length();
                if (length == 0) break;
                allAddress.put(address);
            } catch (Throwable t) {
                Log.e("My App", "Could not parse malformed JSON");
            }
        }
        callback.invoke(null, allAddress.toString());
    }

    @ReactMethod
    public void GetAllTransaction(Callback callback) throws JSONException {
        JSONArray transactionHistory = new JSONArray();
        for (int i = 0; ; i++){
            String address = new JSONObject(subWallet.GetAllAddress(i,1)).getJSONArray("Addresses").get(0).toString();
            try {
                JSONObject transaction = new JSONObject(subWallet.GetAllTransaction(0, 5, address));
                if (transaction.isNull("Transactions")) break;
                JSONArray transactionField = transaction.getJSONArray("Transactions");
                int length = transactionField.length();
                if (length == 0) break;
                for (int j = 0; j < length; j++) {
                    JSONObject transactionSummary = transactionField.getJSONObject(j).getJSONObject("Summary");
                    transactionHistory.put(transactionSummary);
                }
            } catch (Throwable t) {
                Log.e("My App", "Could not parse malformed JSON");
            }
        }
        callback.invoke(null, transactionHistory.toString());
    }

    @ReactMethod
    public void Send(String amount, String toAddress, boolean useVotedUTXO, Callback callback) {
        String rawTransaction = subWallet.CreateTransaction("", toAddress, Long.parseLong(amount), "memo", "remark", useVotedUTXO);
        long fee = subWallet.CalculateTransactionFee(rawTransaction, feePerKb);
        rawTransaction = subWallet.UpdateTransactionFee(rawTransaction, fee, "");
        rawTransaction = subWallet.SignTransaction(rawTransaction, payPassword);
        String transactionId = subWallet.PublishTransaction(rawTransaction);
        callback.invoke(null, transactionId);
    }
}