%module(directors="1") jctp

%include "string_array.i"
%apply (char **STRING_ARRAY, int LENGTH) { (char *ppInstrumentID[], int nCount) }

%{
#include "ThostFtdcTraderApi.h"
#include "ThostFtdcMdApi.h"
#include <codecvt>
#include <locale>
#include <vector>
#include <string>
using namespace std;

#ifdef _MSC_VER
const static locale g_loc("zh-CN");
#else
const static locale g_loc("zh_CN.GB18030");
#endif

jstring convertUTF8(JNIEnv *jenv, char *input) {
    jstring jresult = 0 ;
    const std::string &gb2312(input);
    std::vector<wchar_t> wstr(gb2312.size());
    wchar_t* wstrEnd = nullptr;
    const char* gbEnd = nullptr;
    mbstate_t state = {};
    int res = use_facet<codecvt<wchar_t, char, mbstate_t> >
            (g_loc).in(state, gb2312.data(), gb2312.data() + gb2312.size(),
                       gbEnd, wstr.data(), wstr.data() + wstr.size(), wstrEnd);

    if (codecvt_base::ok == res) {
        wstring_convert<codecvt_utf8<wchar_t>> cutf8;
        std::string result = cutf8.to_bytes(wstring(wstr.data(), wstrEnd));
        jresult=jenv->NewStringUTF(result.c_str());
    } else {
        std::string result;
        jresult=jenv->NewStringUTF(result.c_str());
    }
    return jresult;
}
%}

%typemap(out) char[ANY], char[] {
    $result = convertUTF8(jenv, $1);
}

%pragma(java) jniclassimports=%{
import org.scijava.nativelib.BaseJniExtractor;
import org.scijava.nativelib.NativeLibraryUtil;
import org.scijava.nativelib.NativeLoader;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
%}
%pragma(java) jniclasscode=%{
	private static boolean libraryLoaded = false;
	
	/**
     * 检查动态链接库是否已被正确加载
     * @return true if loaded else false
     */
    public final static boolean libraryLoaded() {
        return libraryLoaded;
    }

    static {
        try {
            String osName = System.getProperty("os.name").toLowerCase();
            if (osName.contains("mac")) {
                String[] libs = {
                        "libcomunicationkey.a",
                        "libcrypto.a",
                        "libssl.a",
                        "libthostmduserapi_se.a",
                        "libthosttraderapi_se.a",
                };
                String libPath = NativeLibraryUtil.getPlatformLibraryPath(NativeLibraryUtil.DEFAULT_SEARCH_PATH);
                BaseJniExtractor jniExtractor = (BaseJniExtractor) NativeLoader.getJniExtractor();
                File jniDir = jniExtractor.getJniDir();
                for (String lib : libs) {
                    URL libRes = jctpJNI.class.getResource("/" + libPath + lib);
                    File outfile = new File(jniDir, lib);
                    InputStream in = null;
                    try {
                        URLConnection connection = libRes.openConnection();
                        connection.setUseCaches(false);
                        in = connection.getInputStream();
                        FileOutputStream out = null;
                        try {
                            out = new FileOutputStream(outfile);
                            final byte[] tmp = new byte[8192];
                            int len = 0;
                            while (true) {
                                len = in.read(tmp);
                                if (len <= 0) {
                                    break;
                                }
                                out.write(tmp, 0, len);
                            }
                        } finally {
                            if (out != null) { out.close(); }
                        }
                        outfile.deleteOnExit();
                    } finally {
                        if (in != null) { in.close(); }
                    }
                }
            } else {
                NativeLoader.loadLibrary("thostmduserapi_se");
                NativeLoader.loadLibrary("thosttraderapi_se");
            }
            NativeLoader.loadLibrary("jctp");
            swig_module_init();
            libraryLoaded = true;
        } catch (Exception e) {
            System.err.println("Failed to load CTP native library: \n" + e);
        }
    }

    /**
     * 删除 C++ 中对 jctpJNI class 的全局引用，避免 GC root 的持续存在
     */
    public final static native void release();
%}

%wrapper %{
SWIGEXPORT void JNICALL Java_org_rationalityfrontline_jctp_jctpJNI_release(JNIEnv *jenv, jclass jcls) {
    jenv->DeleteGlobalRef(Swig::jclass_jctpJNI);
    Swig::jclass_jctpJNI = NULL;
}
%}

%ignore THOST_FTDC_VTC_BankBankToFuture;
%ignore THOST_FTDC_VTC_BankFutureToBank;
%ignore THOST_FTDC_VTC_FutureBankToFuture;
%ignore THOST_FTDC_VTC_FutureFutureToBank;
%ignore THOST_FTDC_FTC_BankLaunchBankToBroker;
%ignore THOST_FTDC_FTC_BrokerLaunchBankToBroker;
%ignore THOST_FTDC_FTC_BankLaunchBrokerToBank;
%ignore THOST_FTDC_FTC_BrokerLaunchBrokerToBank;

%include "../cpp/src/ThostFtdcUserApiDataType.h"
%include "../cpp/src/ThostFtdcUserApiStruct.h"
%feature("director") CThostFtdcTraderSpi;
%include "../cpp/src/ThostFtdcTraderApi.h"
%feature("director") CThostFtdcMdSpi;
%include "../cpp/src/ThostFtdcMdApi.h"
