#!/usr/bin/env bash

set -e
sudo apt update
sudo apt install xvfb file binutils patchelf findutils grep sed coreutils strace vulkan-tools -y
sudo apt install libvulkan1 mesa-vulkan-drivers vulkan-tools libvulkan-dev vulkan-validationlayers libsdl2-2.0-0 libasound2-plugins -y
sudo apt install libqt6svg6 -y
sudo add-apt-repository ppa:pcsx2-team/pcsx2-daily -y
sudo apt update
sudo apt install pcsx2-unstable -y
mkdir AppDir
OUTDIR=./AppDir

cd "$OUTDIR"

# Baixar sharun
wget -O "sharun" "https://github.com/VHSgunzo/sharun/releases/download/v0.8.1/sharun-x86_64"

chmod +x ./sharun

# Gerar AppRun com xvfb
xvfb-run -- ./sharun l -p -v -e -s -k /usr/bin/pcsx2-qt \
	/usr/lib/x86_64-linux-gnu/dri/* \
	/usr/lib/x86_64-linux-gnu/vdpau/* \
	/usr/lib/x86_64-linux-gnu/qt6/*/* \
	/usr/lib/x86_64-linux-gnu/libshaderc.so* \
	/usr/lib/x86_64-linux-gnu/libsdl2* \
	/usr/lib/x86_64-linux-gnu/alsa-lib/* \
	/usr/lib/x86_64-linux-gnu/libQt6Svg.so* \
	/usr/lib/x86_64-linux-gnu/lib*CL*.so* \
	/usr/lib/x86_64-linux-gnu/libvulkan*.so* \
	/usr/lib/x86_64-linux-gnu/libVkLayer*.so* \
	/usr/lib/x86_64-linux-gnu/libvulkan_* \
	/usr/lib/x86_64-linux-gnu/libvulkan* \
    /usr/lib/x86_64-linux-gnu/lib*GL*.so* \
	/usr/lib/x86_64-linux-gnu/libXss.so* \
	/usr/lib/x86_64-linux-gnu/gio/modules/* \
	/usr/lib/x86_64-linux-gnu/gdk-pixbuf-*/*/*/* \
	/usr/lib/x86_64-linux-gnu/alsa-lib/* \
	/usr/lib/x86_64-linux-gnu/pulseaudio/* \
	/usr/lib/x86_64-linux-gnu/pipewire-0.3/* \
	/usr/lib/x86_64-linux-gnu/spa-0.2/*/* || true
cp -r /usr/share/PCSX2/ ./share/
# Copiar ícone
cp "${GITHUB_WORKSPACE}"/PCSX2.png .
cp "${GITHUB_WORKSPACE}"/PCSX2.desktop .
ln PCSX2.png .DirIcon
ln -rs share/ ./shared/
ln ./sharun AppRun
./sharun -g
#echo 'SHARUN_ALLOW_LD_PRELOAD=1' > .env
#echo 'SHARUN_ALLOW_SYS_VKICD=1' >> .env
echo 'QT_QPA_PLATFORM=xcb' > .env
#echo 'SDL_AUDIODRIVER=pulseaudio' >> .env

cd ..

# Baixar appimagetool
wget -q -O appimagetool "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool

# Criar AppImage
ARCH=x86_64 ./appimagetool -n "$OUTDIR"
