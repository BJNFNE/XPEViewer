set VS_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
set QT_PATH=C:\Qt\5.15.2\msvc2019_64
set SEVENZIP_PATH="C:\Program Files\7-Zip"

set BUILD_NAME=xpeviewer_win64_portable
set SOURCE_PATH=%~dp0
mkdir %SOURCE_PATH%\build
mkdir %SOURCE_PATH%\release
set /p RELEASE_VERSION=<%SOURCE_PATH%\release_version.txt

set QT_PATH=%QT_PATH%
call %VS_PATH%\VC\Auxiliary\Build\vcvars64.bat
set GUIEXE=xpeviewer.exe
set ZIP_NAME=%BUILD_NAME%_%RELEASE_VERSION%
set RES_FILE=rsrc

del %SOURCE_PATH%\XArchive\.qmake.stash
del %SOURCE_PATH%\build_libs\.qmake.stash
del %SOURCE_PATH%\gui_source\.qmake.stash

cd build_libs
%QT_PATH%\bin\qmake.exe build_libs.pro -r -spec win32-msvc "CONFIG+=release"

nmake Makefile.Release clean
nmake
del Makefile
del Makefile.Release
del Makefile.Debug

cd ..

cd gui_source
%QT_PATH%\bin\qmake.exe gui_source.pro -r -spec win32-msvc "CONFIG+=release"
%QT_PATH%\bin\lupdate.exe gui_source_tr.pro

nmake Makefile.Release clean
nmake
del Makefile
del Makefile.Release
del Makefile.Debug

cd ..

mkdir %SOURCE_PATH%\release\%BUILD_NAME%
mkdir %SOURCE_PATH%\release\%BUILD_NAME%\lang
mkdir %SOURCE_PATH%\release\%BUILD_NAME%\platforms

copy %SOURCE_PATH%\build\release\%GUIEXE% %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\bin\Qt5Widgets.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\bin\Qt5Gui.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\bin\Qt5Core.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\bin\Qt5OpenGL.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\bin\Qt5Svg.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %QT_PATH%\plugins\platforms\qwindows.dll %SOURCE_PATH%\release\%BUILD_NAME%\platforms\

copy %VS_PATH%\VC\Redist\MSVC\14.27.29016\x64\Microsoft.VC142.CRT\msvcp140.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %VS_PATH%\VC\Redist\MSVC\14.27.29016\x64\Microsoft.VC142.CRT\vcruntime140.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %VS_PATH%\VC\Redist\MSVC\14.27.29016\x64\Microsoft.VC142.CRT\msvcp140_1.dll %SOURCE_PATH%\release\%BUILD_NAME%\
copy %VS_PATH%\VC\Redist\MSVC\14.27.29016\x64\Microsoft.VC142.CRT\vcruntime140_1.dll %SOURCE_PATH%\release\%BUILD_NAME%\

xcopy %SOURCE_PATH%\XStyles\qss %SOURCE_PATH%\release\%BUILD_NAME%\qss /E /I

%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_it.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_it.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_fr.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_fr.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_he.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_he.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_tr.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_tr.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_ko.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_ko.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_es.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_es.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_pt_PR.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_pt_PR.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_ja.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_ja.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_pl.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_pl.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_ru.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_ru.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_vi.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_vi.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_zh.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_zh.qm
%QT_PATH%\bin\lrelease.exe %SOURCE_PATH%\gui_source\translation\xpeviewer_zh_TW.ts -qm %SOURCE_PATH%\release\%BUILD_NAME%\lang\xpeviewer_zh_TW.qm

mkdir %SOURCE_PATH%\release\%BUILD_NAME%\signatures
xcopy %SOURCE_PATH%\signatures\crypto.db %SOURCE_PATH%\release\%BUILD_NAME%\signatures\

cd %SOURCE_PATH%\release
if exist %ZIP_NAME%.zip del %ZIP_NAME%.zip
%SEVENZIP_PATH%\7z.exe a %ZIP_NAME%.zip %BUILD_NAME%\*
rmdir /s /q %SOURCE_PATH%\release\%BUILD_NAME%
cd ..