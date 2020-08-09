/*
 * See various.i
 */

%typemap(jni) (char **STRING_ARRAY, int LENGTH) "jobjectArray"
%typemap(jtype) (char **STRING_ARRAY, int LENGTH) "String[]"
%typemap(jstype) (char **STRING_ARRAY, int LENGTH) "String[]"
%typemap(in) (char **STRING_ARRAY, int LENGTH) {
    int i = 0;
    if ($input) {
        $2 = JCALL1(GetArrayLength, jenv, $input);
        $1 = new char*[$2+1];
        for (i = 0; i<$2; i++) {
            jstring j_string = (jstring)JCALL2(GetObjectArrayElement, jenv, $input, i);
            const char *c_string = JCALL2(GetStringUTFChars, jenv, j_string, 0);
            $1[i] = new char [strlen(c_string)+1];
            strcpy($1[i], c_string);
            JCALL2(ReleaseStringUTFChars, jenv, j_string, c_string);
            JCALL1(DeleteLocalRef, jenv, j_string);
        }
        $1[i] = 0;
    } else {
        $1 = 0;
        $2 = 0;
    }
}

%typemap(freearg) (char **STRING_ARRAY, int LENGTH) {
        int i;
        for (i=0; i<$2; i++)
        delete[] $1[i];
        delete[] $1;
}

%typemap(out) (char **STRING_ARRAY, int LENGTH) {
        if ($1) {
            int i;
            jsize len=0;
            jstring temp_string;
            const jclass clazz = JCALL1(FindClass, jenv, "java/lang/String");

            while ($1[len]) len++;
            $result = JCALL3(NewObjectArray, jenv, len, clazz, NULL);
            /* exception checking omitted */

            for (i=0; i<len; i++) {
                temp_string = JCALL1(NewStringUTF, jenv, *$1++);
                JCALL3(SetObjectArrayElement, jenv, $result, i, temp_string);
                JCALL1(DeleteLocalRef, jenv, temp_string);
            }
        }
}

%typemap(javain) (char **STRING_ARRAY, int LENGTH) "$javainput"
%typemap(javaout) (char **STRING_ARRAY, int LENGTH) {
        return $jnicall;
}