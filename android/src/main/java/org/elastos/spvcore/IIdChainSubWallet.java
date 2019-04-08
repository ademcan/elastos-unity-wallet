package org.elastos.spvcore;

/**
 * IIdChainSubWallet jni
 */
public class IIdChainSubWallet extends ISidechainSubWallet{
    private long mIDchainProxy;

    public IIdChainSubWallet(long proxy) {
        super(proxy);
        mIDchainProxy = proxy;
    }

    private native String nativeCreateIdTransaction(long proxy, String fromAddress,
            String payloadJson, String programJson, String memo, String remark);
}
