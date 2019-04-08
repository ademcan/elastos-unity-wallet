// Copyright (c) 2012-2018 The Elastos Open Source Project
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "ElaUtils.h"
#include "ISidechainSubWallet.h"
#include "nlohmann/json.hpp"

using namespace Elastos::ElaWallet;

#define SIG_nativeCreateWithdrawTransaction "(JLjava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;"
static jstring JNICALL nativeCreateWithdrawTransaction(JNIEnv *env, jobject clazz, jlong jSideSubWalletProxy,
		jstring jfromAddress,
		jlong amount,
		jstring jmainChainAddress,
		jstring jmemo,
		jstring jremark)
{
	bool exception = false;
	std::string msgException;

	const char *fromAddress      = env->GetStringUTFChars(jfromAddress, NULL);
	const char *mainChainAddress = env->GetStringUTFChars(jmainChainAddress, NULL);
	const char *memo             = env->GetStringUTFChars(jmemo, NULL);
	const char *remark           = env->GetStringUTFChars(jremark, NULL);

	ISidechainSubWallet* wallet = (ISidechainSubWallet*)jSideSubWalletProxy;
	jstring tx = NULL;

	try {
		nlohmann::json txJson = wallet->CreateWithdrawTransaction(fromAddress, amount, mainChainAddress, memo, remark);

		tx = env->NewStringUTF(txJson.dump().c_str());
	} catch (std::exception &e) {
		exception = true;
		msgException = e.what();
	}

	env->ReleaseStringUTFChars(jfromAddress, fromAddress);
	env->ReleaseStringUTFChars(jmainChainAddress, mainChainAddress);
	env->ReleaseStringUTFChars(jmemo, memo);
	env->ReleaseStringUTFChars(jremark, remark);

	if (exception) {
		ThrowWalletException(env, msgException.c_str());
	}

	return tx;
}

#define SIG_nativeGetGenesisAddress "(J)Ljava/lang/String;"
static jstring JNICALL nativeGetGenesisAddress(JNIEnv *env, jobject clazz, jlong jSideSubWalletProxy)
{
	bool exception = false;
	std::string msgException;

	ISidechainSubWallet *wallet = (ISidechainSubWallet *)jSideSubWalletProxy;
	jstring addr = NULL;

	try {
		std::string address = wallet->GetGenesisAddress();
		addr = env->NewStringUTF(address.c_str());
	} catch (std::exception &e) {
		exception = true;
		msgException = e.what();
	}

	if (exception) {
		ThrowWalletException(env, msgException.c_str());
	}

	return addr;
}


static const JNINativeMethod gMethods[] = {
	REGISTER_METHOD(nativeCreateWithdrawTransaction),
	REGISTER_METHOD(nativeGetGenesisAddress),
};

jint register_elastos_spv_ISidechainSubWallet(JNIEnv *env)
{
	return jniRegisterNativeMethods(env, "org/elastos/spvcore/ISidechainSubWallet",
			gMethods, NELEM(gMethods));
}
