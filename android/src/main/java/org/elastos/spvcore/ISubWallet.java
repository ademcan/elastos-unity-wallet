
package org.elastos.spvcore;

/**
 * ISubWallet
 */
public class ISubWallet {
    private long mSubProxy;

    public ISubWallet(long proxy) {
        mSubProxy = proxy;
    }

    protected long getProxy() {
        return mSubProxy;
    }

    private native String nativeGetChainId(long subProxy);
    private native String nativeGetBasicInfo(long subProxy);
    private native String nativeGetBalanceInfo(long subProxy);
    private native long nativeGetBalance(long subProxy, int balanceType);
    private native String nativeCreateAddress(long subProxy);
    private native String nativeGetAllAddress(long subProxy, int start, int count);
    private native long nativeGetBalanceWithAddress(long subProxy, String address, int balanceType);
    private native void nativeAddCallback(long subProxy, ISubWalletCallback subCallback);
    private native void nativeRemoveCallback(long subProxy);
    private native String nativeCreateTransaction(long subProxy, String fromAddress, String toAddress, long amount, String memo, String remark, boolean useVotedUTXO);
    private native String nativeCreateMultiSignTransaction(long subProxy, String fromAddress, String toAddress, long amount, String memo, String remark, boolean useVotedUTXO);
    private native long nativeCalculateTransactionFee(long subProxy, String rawTransaction, long feePerKb);
	private native String nativeUpdateTransactionFee(long subProxy, String rawTransaction, long fee, String fromAddress);
	private native String nativeSignTransaction(long subProxy, String rawTransaction, String payPassword);
	private native String nativeGetTransactionSignedSigners(long subProxy, String rawTransaction);
	private native String nativePublishTransaction(long subProxy, String rawTransaction);
    private native String nativeGetAllTransaction(long subProxy, int start, int count, String addressOrTxId);
    private native String nativeSign(long subProxy, String message, String payPassword);
    private native boolean nativeCheckSign(long subProxy, String publicKey, String message, String signature);
	private native String nativeGetPublicKey(long jSubProxy);
}
