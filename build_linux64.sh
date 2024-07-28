#!/bin/bash -x
QT_PATH=$HOME/Qt/5.15.2/gcc_64
RELEASE_VERSION=$(cat "release_version.txt")
echo $RELEASE_VERSION
SOURCE_PATH=$PWD

BUILD_NAME=xpeviewer_lin64_portable

cd $SOURCE_PATH

function makeproject
{
    cd $SOURCE_PATH/$1
    
    $QT_PATH/bin/qmake $1.pro -spec linux-g++
    make -f Makefile clean
    make -f Makefile

    rm -rf Makefile
    rm -rf Makefile.Release
    rm -rf Makefile.Debug
    rm -rf object_script.*     

    cd $SOURCE_PATH
}

rm -rf $SOURCE_PATH/build

makeproject gui_source

cd $SOURCE_PATH/gui_source
$QT_PATH/bin/lupdate gui_source_tr.pro
cd $SOURCE_PATH

mkdir -p $SOURCE_PATH/release
rm -rf $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/base
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/base/platforms
mkdir -p $SOURCE_PATH/release/$BUILD_NAME/base/lang

cp -R $QT_PATH/plugins/platforms/libqxcb.so                     $SOURCE_PATH/release/$BUILD_NAME/base/platforms/

cp -R $SOURCE_PATH/build/release/xpeviewer                     $SOURCE_PATH/release/$BUILD_NAME/base/

cp -R $QT_PATH/lib/libQt5Core.so.5.15.2                         $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5Svg.so.5.15.2                          $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5Gui.so.5.15.2                          $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5Widgets.so.5.15.2                      $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5OpenGL.so.5.15.2                       $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5DBus.so.5.15.2                         $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libQt5XcbQpa.so.5.15.2                       $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libicui18n.so.56.1                           $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libicuuc.so.56.1                             $SOURCE_PATH/release/$BUILD_NAME/base/
cp -R $QT_PATH/lib/libicudata.so.56.1                           $SOURCE_PATH/release/$BUILD_NAME/base/

mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Core.so.5.15.2               $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Core.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Svg.so.5.15.2               	$SOURCE_PATH/release/$BUILD_NAME/base/libQt5Svg.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Gui.so.5.15.2                $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Gui.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Widgets.so.5.15.2            $SOURCE_PATH/release/$BUILD_NAME/base/libQt5Widgets.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5OpenGL.so.5.15.2             $SOURCE_PATH/release/$BUILD_NAME/base/libQt5OpenGL.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5DBus.so.5.15.2               $SOURCE_PATH/release/$BUILD_NAME/base/libQt5DBus.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libQt5XcbQpa.so.5.15.2             $SOURCE_PATH/release/$BUILD_NAME/base/libQt5XcbQpa.so.5
mv $SOURCE_PATH/release/$BUILD_NAME/base/libicui18n.so.56.1                 $SOURCE_PATH/release/$BUILD_NAME/base/libicui18n.so.56
mv $SOURCE_PATH/release/$BUILD_NAME/base/libicuuc.so.56.1                   $SOURCE_PATH/release/$BUILD_NAME/base/libicuuc.so.56
mv $SOURCE_PATH/release/$BUILD_NAME/base/libicudata.so.56.1                 $SOURCE_PATH/release/$BUILD_NAME/base/libicudata.so.56

$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_de.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_de.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_ja.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_ja.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_pl.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_pl.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_pt_BR.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_pt_BR.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_fr.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_fr.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_ru.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_ru.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_vi.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_vi.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_zh.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_zh.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_zh_TW.ts -qm  $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_zh_TW.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_es.ts -qm $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_es.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_it.ts -qm $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_it.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_ko.ts -qm $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_ko.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_tr.ts -qm $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_tr.qm
$QT_PATH/bin/lrelease  $SOURCE_PATH/gui_source/translation/xpeviewer_he.ts -qm $SOURCE_PATH/release/$BUILD_NAME/base/lang/xpeviewer_he.qm

mkdir -p $SOURCE_PATH/release/$BUILD_NAME/base/signatures
cp -R $SOURCE_PATH/signatures/crypto.db                     		$SOURCE_PATH/release/$BUILD_NAME/base/signatures

echo "#!/bin/sh" >> release/$BUILD_NAME/xpeviewer.sh
echo "CWD=\$(dirname \$0)" >> release/$BUILD_NAME/xpeviewer.sh
echo "export LD_LIBRARY_PATH=\"\$CWD/base:\$LD_LIBRARY_PATH\"" >> release/$BUILD_NAME/xpeviewer.sh
echo "\$CWD/base/xpeviewer \$*" >> release/$BUILD_NAME/xpeviewer.sh

chmod +x release/$BUILD_NAME/xpeviewer.sh

rm -rf $SOURCE_PATH/release/${BUILD_NAME}_${RELEASE_VERSION}.tar.gz
rm -rf $SOURCE_PATH/release/${BUILD_NAME}_${RELEASE_VERSION}.tar

cd release

tar -cvf ${BUILD_NAME}_${RELEASE_VERSION}.tar $BUILD_NAME
gzip --best ${BUILD_NAME}_${RELEASE_VERSION}.tar

cd ..

rm -rf release/$BUILD_NAME
