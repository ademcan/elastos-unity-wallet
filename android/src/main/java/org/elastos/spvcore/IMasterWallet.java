
package org.elastos.spvcore;

import java.util.ArrayList;
import android.util.Log;

/**
 * IMasterWallet
 */
public class IMasterWallet {
    static public class CHAINID {
        public static String MAIN = "ELA";
        public static String ID = "IdChain";
    }
	static public String TAG = "IMasterWallet";

    private long mMasterProxy;

    public IMasterWallet(long proxy) {
        mMasterProxy = proxy;
    }

    private native String nativeGetId(long masterProxy);
	private native String nativeGetBasicInfo(long masterProxy);
    private native Object[] nativeGetAllSubWallets(long masterProxy);
    private native long nativeCreateSubWallet(long masterProxy, String chainID, long feePerKb);
    private native String nativeGetPublicKey(long masterProxy);
    private native void nativeDestroyWallet(long masterProxy, long subWalletProxy);
    private native String nativeSign(long masterProxy, String message, String payPassword);
    private native boolean nativeCheckSign(long masterProxy, String publicKey, String message, String signature);
    private native boolean nativeIsAddressValid(long masterProxy, String address);
    private native String[] nativeGetSupportedChains(long masterProxy);
    private native void nativeChangePassword(long proxy, String oldPassword, String newPassword);
}
