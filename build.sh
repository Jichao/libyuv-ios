# build libyuv.a & libyuv_neon.a for ios

#mkdir libyuv
#gclient config --name src https://chromium.googlesource.com/libyuv/libyuv
#gclient sync
#echo ";target_os=['ios'];" >> .gclient
#gclient sync

#additional_target_cpus does not work for libyuv
rm -r out
gn gen out/arm64 "--args=is_debug=false target_os=\"ios\" ios_enable_code_signing=false target_cpu=\"arm64\""
gn gen out/arm "--args=is_debug=false target_os=\"ios\" ios_enable_code_signing=false target_cpu=\"arm\""
gn gen out/x64 "--args=is_debug=false target_os=\"ios\" ios_enable_code_signing=false use_xcode_clang=true target_cpu=\"x64\""

ninja -v -C out/arm64 libyuv
ninja -v -C out/arm libyuv
ninja -v -C out/x64 libyuv

cd out
lipo -arch arm64 ./arm64/obj/libyuv_internal.a -arch arm ./arm/obj/libyuv_internal.a -arch x86_64 ./x64/obj/libyuv_internal.a -create -output libyuv_internal.a
lipo -arch arm64 ./arm64/obj/libyuv_neon.a -arch arm ./arm/obj/libyuv_neon.a -create -output libyuv_neon.a

