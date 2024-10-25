# jahinzee's Highly-Volatile uBlue Playground!

## NOT FOR GENERAL CONSUMPTION

This repo is a testing ground for experimenting with building my own uBlue
image. I would absolutely not recommend using this on any system in any way,
_especially_ in production or any daily-driver capacity.

This repo is made public mainly for ease of testing on virtual machines, and as
a sort of educational record on what you can do with a uBlue image.

That being said, the code here will probably not be blessed with any sort of
rigor or quality: expect unhelpful commit messages, commits that undo previous
commits, multiple changes to a file within a day as I test things out, etc.

Like I said, **please** do not rely on the images generated from here for any
kind of work. I will not be held liable for any data loss, broken systems, nose
demons, yadda yadda.

If you are looking for an immutable distro you can rely on, try the
[mainline Fedora Atomic Desktops](https://fedoraproject.org/atomic-desktops/),
or the [Universal Blue images](https://universal-blue.org/).

## Usage

If you still want to use this for some reason, I haven't set up any ISO build
systems yet, so in the meantime, you can do the following:

1. Download and install any Fedora Atomic Desktop image – preferably Kinoite on
   a virtual machine.
2. Once installed, open up the terminal and run:

```sh
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jahinzee/ublue-playground:latest
```

3. Reboot, and now your Fedora installation is fully at the mercy of this repo.

### Going back to your previous image

To revert to your previous base image, run the same command, but change the
container URL to whatever you had previously.

You can find your last image by running:

```sh
rpm-ostree status
```
