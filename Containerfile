# Allow build scripts to be referenced without being copied into the final image
# FROM scratch AS ctx
# COPY build_files /

# Base Image
#FROM ghcr.io/ublue-os/bazzite:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable

FROM quay.io/fedora/fedora-sway-atomic:latest
 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN dnf5 install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf5 install -y tmux 
RUN dnf5 install -y htop
RUN dnf5 install -y btop
RUN dnf5 install -y neofetch
RUN dnf5 install akmod-nvidia xorg-x11-drv-nvidia-cuda
RUN dnf5 clean all


RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN systemctl set-default graphical.target

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
