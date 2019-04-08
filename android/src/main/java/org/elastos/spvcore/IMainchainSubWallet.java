package org.elastos.spvcore;

/**
 * IMainchainSubWallet jni
 */
public class IMainchainSubWallet extends ISubWallet {
	private long mMainchainProxy;

	public IMainchainSubWallet(long proxy) {
		super(proxy);
		mMainchainProxy = proxy;
	}


	private native String nativeCreateDepositTransaction(long proxy, String fromAddress, String lockedAddress, long amount,
			String sideChainAddress, String memo, String remark, boolean useVotedUTXO);

	private native String nativeGenerateProducerPayload(long proxy, String publicKey, String nodePublicKey, String nickName,
			String url, String IPAddress, long location, String payPasswd);

	private native String nativeGenerateCancelProducerPayload(long proxy, String publicKey, String payPasswd);

	private native String nativeCreateRegisterProducerTransaction(long proxy, String fromAddress, String payloadJson, long amount,
			String memo, String remark, boolean useVotedUTXO);

	private native String nativeCreateUpdateProducerTransaction(long proxy, String fromAddress, String payloadJson, String memo, String remark, boolean useVotedUTXO);

	private native String nativeCreateCancelProducerTransaction(long proxy, String fromAddress, String payloadJson, String memo, String remark, boolean useVotedUTXO);

	private native String nativeCreateRetrieveDepositTransaction(long proxy, long amount, String memo, String remark);

	private native String nativeGetPublicKeyForVote(long proxy);

	private native String nativeCreateVoteProducerTransaction(long proxy, String fromAddress, long stake, String publicKeys, String memo, String remark, boolean useVotedUTXO);

	private native String nativeGetVotedProducerList(long proxy);

	private native String nativeGetRegisteredProducerInfo(long proxy);

}
