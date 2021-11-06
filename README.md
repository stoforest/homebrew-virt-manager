homebrew-virt-manager
=====================

A set of [homebrew][homebrew] formulae to install [`virt-manager`][virt-manager] and [`virt-viewer`][virt-viewer] on Mac OSX.

## Usage

    brew tap stoforest/homebrew-virt-manager
    brew install virt-manager virt-viewer
    virt-manager -c test:///default

## FAQs

#### Why can't I connect to a remote URI?

When connecting to remote URIs, you probably need to override the `libvirt` socket location, see [www.jedi.be][jedi].

    virt-manager -c 'qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock'
    virt-viewer -c 'qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock'

#### I still can't connect to a remote URI, why?

This formula for `virt-manager` does not include the `openssh-askpass` dependency and does not prompt for passwords in a popup window. Here are two workarounds:

1. Run `virt-manager` with either the `--debug` or `--no-fork` option to get password prompt via the CLI.

2. Set up SSH keys between your local and remote system to avoid the prompt.

#### Why can't I connect to a local URI (*e.g.*, qemu:///system)?

I've not yet tested `virt-manager` against any local URIs/hypervisors. If you get `virt-manager` working with a local hypervisor and needed to take any special steps, feel free to share the details.

#### Everything was working yesterday, but it's not working today, can you help?

If `virt-manager` or its dependencies have been upgraded recently (`brew upgrade`), it's possible that a reinstall may fix the issue (see [#39](https://github.com/jeffreywildman/homebrew-virt-manager/issues/39)).


#### Why am I getting the error "No GSettings schemas are installed on the system"?

You must make sure that  ``/usr/local/share`` is not missing from XDG_DATA_DIRS. If it is, add it to XDG_DATA_DIRS. You can make sure by running ``echo $XDG_DATA_DIRS`` (better in a new bash, zsh etc. session since if you set that environment variable temporarily it would only fix the issue for that shell session). 

[homebrew]: http://brew.sh/
[virt-manager]: https://virt-manager.org/
[virt-viewer]: https://virt-manager.org/
[jedi]: http://www.jedi.be/blog/2011/09/13/libvirt-fog-provider/#macosx-remote-libvirt-client-
