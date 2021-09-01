

#!/bin/sh

echo "Building Clight and its dependencies..."

echo "* Creating build directory"
mkdir build
cd build

###########################################################
# To build from latest release instead of -devel version, #
# Comment out following lines and uncomment the next ones #
###########################################################
echo "* Getting Sources from git "
git clone https://github.com/FedeDP/Clight.git
git clone https://github.com/FedeDP/Clightd.git
git clone https://github.com/FedeDP/libmodule.git
git clone https://github.com/rockowitz/ddcutil.git
git clone https://github.com/nullobsi/clight-gui.git

###########################################################
# To build from latest release, uncomment following lines #
# If needed, update tag name                              #
###########################################################
# echo "* Getting Sources from latest tags "
# git clone -b '4.0' --single-branch --depth 1 https://github.com/FedeDP/Clight.git
# git clone -b '4.0' --single-branch --depth 1 https://github.com/FedeDP/Clightd.git
# git clone -b '5.0.0' --single-branch --depth 1 https://github.com/FedeDP/libmodule.git
# git clone -b 'v0.9.7' --single-branch --depth 1 https://github.com/rockowitz/ddcutil.git

cd ddcutil
echo "* Building ddcutil"
./autogen.sh
./configure --prefix=/usr
make
sudo make install
cd ..

cd libmodule
echo "* Building Libmodule"
mkdir build
cd build
cmake  \
         -G "Unix Makefiles" \
         -DCMAKE_INSTALL_PREFIX=/usr \
         -DCMAKE_INSTALL_LIBDIR=lib \
         -DCMAKE_BUILD_TYPE="Release" \
         ..
make
sudo make install
cd ../..

cd Clightd
echo "* Building clightd"
mkdir build
cd build
cmake \
        -G "Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE="Release" \
        -DENABLE_DDC=1 -DENABLE_GAMMA=1 -DENABLE_SCREEN=1 -DENABLE_DPMS=1 \
        ..
make
sudo make install
cd ../..

cd Clight
echo "* Building clight"
mkdir build
cd build
cmake \
        -G "Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE="Release" \
        ..
make
sudo make install
sudo systemctl enable clightd.service
cd ../..

echo "* Building clight-gui"
sudo apt install -y libudev-dev libjpeg-turbo8-dev libpolkit-gobject-1-dev libdrm-dev libglib2.0-dev libusb-1.0-0-dev libtool autoconf autotools-dev libx11-dev libxrandr-dev libxext-dev libwayland-dev libgeoclue-2-dev
cd clight-gui
cmake -S src -B build
cd build
make
sudo make install
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor/
cd ../..

echo "Removing build directory"
cd ..
rm build -fr
echo "Done...Enjoy Clight!"

