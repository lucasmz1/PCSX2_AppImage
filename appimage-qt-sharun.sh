#!/usr/bin/env bash

SCRIPTDIR=$(dirname "${BASH_SOURCE[0]}")

set -e
sudo apt-get update
sudo apt-get install xvfb file binutils patchelf findutils grep sed coreutils strace -y
sudo apt-get install libqt6svg6 -y
sudo add-apt-repository ppa:pcsx2-team/pcsx2-daily -y
sudo apt-get update
sudo apt-get install pcsx2-unstable -y
mkdir -p AppDir
OUTDIR=./AppDir

cd "$OUTDIR"

# Copiar ícone
cp /usr/share/icons/hicolor/256x256/apps/PCSX2.png .
cp /usr/share/applications/PCSX2.desktop .
# Baixar sharun
wget -O "sharun" "https://github.com/VHSgunzo/sharun/releases/download/v0.8.1/sharun-x86_64"


chmod +x ./sharun

# Gerar AppRun com xvfb
xvfb-run -- ./sharun l -p -v -e -s -k /usr/bin/pcsx2-qt \
	/usr/lib/x86_64-linux-gnu/dri/* \
	/usr/lib/x86_64-linux-gnu/vdpau/* \
	/usr/lib/x86_64-linux-gnu/qt6/*/* \
	/usr/lib/x86_64-linux-gnu/libshaderc.so* \
	/usr/lib/x86_64-linux-gnu/libQt6Svg.so* \
	/usr/lib/x86_64-linux-gnu/lib*CL*.so* \
	/usr/lib/x86_64-linux-gnu/libvulkan*.so* \
	/usr/lib/x86_64-linux-gnu/libVkLayer*.so* \
	/usr/lib/x86_64-linux-gnu/libvulkan_* \
    /usr/lib/x86_64-linux-gnu/lib*GL*.so* \
	/usr/lib/x86_64-linux-gnu/libXss.so* \
	/usr/lib/x86_64-linux-gnu/gio/modules/* \
	/usr/lib/x86_64-linux-gnu/gdk-pixbuf-*/*/*/* \
	/usr/lib/x86_64-linux-gnu/alsa-lib/* \
	/usr/lib/x86_64-linux-gnu/pulseaudio/* \
	/usr/lib/x86_64-linux-gnu/pipewire-0.3/* \
	/usr/lib/x86_64-linux-gnu/spa-0.2/*/* || true
cp -r /usr/share/PCSX2/ ./share/
ln -rs share/ ./shared/
ln ./sharun AppRun
./sharun -g
echo 'QT_QPA_PLATFORM=xcb' >> .env

cd ..

# Baixar appimagetool
wget -q -O appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool

# Criar AppImage
ARCH=x86_64 ./appimagetool -n "$OUTDIR"
