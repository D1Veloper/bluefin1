# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
#FROM ghcr.io/ublue-os/bazzite:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable

FROM quay.io/fedora/fedora-silverblue:latest
 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

 #RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
 #   --mount=type=cache,dst=/var/cache \
 #   --mount=type=cache,dst=/var/log \
 #   --mount=type=tmpfs,dst=/tmp \
 #    /ctx/build.sh && / 
 #   ostree container commit

#dnf5 install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 update

dnf5 install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
dnf5 install -y akmod-nvidia 
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf

dnf5 install -y tmux 
dnf5 install -y htop
dnf5 install -y btop
dnf5 install -y neofetch
dnf5 clean all

# RUN systemctl set-default graphical.target

### LINTING
## Verify final image and contents are correct.

RUN bootc container lint
