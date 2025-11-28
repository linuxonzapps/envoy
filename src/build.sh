#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Ensure sudo is installed along with utilities to build rpm and deb packages
apt-get update && apt-get install sudo -y
useradd -ms /bin/bash testuser && usermod -aG sudo testuser && echo "%sudo  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
original_dir=$(pwd)
cd /home/testuser
su testuser -c "bash /tmp/linux-on-ibm-z-scripts/Envoy/${version}/build_envoy.sh -y"
tar cvfz ${original_dir}/envoy-${version}-linux-s390x.tar.gz -C $PWD/envoy/bazel-bin/source/exe envoy-static
exit 0
