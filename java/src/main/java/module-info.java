module jctp {
    requires org.scijava.nativelib;
    exports org.rationalityfrontline.jctp;

    opens natives.windows_64;
    opens natives.linux_64;
}