#!/bin/bash

# For building on Raspberry Pi (note for 2GB and smaller increase swapfile)

HERE=$PWD

swapspace() {
  echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile
  sudo dphys-swapfile setup
  sudo dphys-swapfile swapon
}

libcamera_deps() {
  sudo apt install -y clang g++ gcc libyaml-dev python3-yaml python3-ply python3-jinja2 libdw-dev libunwind-dev libboost-dev libudev-dev python3-sphinx doxygen graphviz texlive-latex-extra libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libevent-dev qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5 qttools5-dev-tools libtiff-dev liblttng-ust-dev python3-jinja2 lttng-tools libexif-dev libjpeg-dev libevent-dev cmake libdrm-dev
  pip3 install --user meson
  pip3 install --user --upgrade meson
  pip3 install -U sphinx
}

libcamera_source() {
  git clone https://git.libcamera.org/libcamera/libcamera.git $HERE/libcamera
}

libcamera_build() {
  cd $HERE/libcamera
  meson build
  sudo ninja -v -C build install
}

libcamera_deps
libcamera_source
libcamera_build

cd $HERE || exit 1
