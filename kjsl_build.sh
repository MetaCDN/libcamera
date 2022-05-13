#!/bin/bash

# For building on Raspberry Pi (note for 2GB and smaller increase swapfile)

HERE=$PWD

if [ "$(id -un)" != "root" ]; then
  echo "ERROR: run as root"
  exit 1
fi

swapspace() {
  echo "CONF_SWAPSIZE=2048" >> /etc/dphys-swapfile
  dphys-swapfile setup
  dphys-swapfile swapon
}

libcamera_deps_meson() {
  if [ ! -f "get-pip.py" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    pip3 uninstall meson
    pip3 install meson
    pip3 install --upgrade meson
    pip3 install sphinx
  fi
}

libcamera_deps() {
  apt install -y clang g++ gcc libyaml-dev python3-yaml python3-ply python3-jinja2 libdw-dev libunwind-dev libboost-dev libudev-dev python3-sphinx doxygen graphviz texlive-latex-extra libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libevent-dev qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5 qttools5-dev-tools libtiff-dev liblttng-ust-dev python3-jinja2 lttng-tools libexif-dev libjpeg-dev libevent-dev cmake libdrm-dev
  libcamera_deps_meson
}

libcamera_source() {
  # sudo rm -rf $HERE/libcamera
  cd $HERE || exit 1
  git clone https://git.libcamera.org/libcamera/libcamera.git $HERE/libcamera
}

libcamera_build() {
  cd $HERE/libcamera
  meson build
  ninja -v -C build install
}

libcamera_deps
libcamera_source
libcamera_build

cd $HERE || exit 1
