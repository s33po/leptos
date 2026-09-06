# LeptOS

A custom, trimmed-down **bootc** desktop image built on **CentOS Stream 10**.

> Intended for personal use only.

## Design choices

- **Minimal package set.** Only what I actually need for my own use case and hardware, which keeps the image small. The image comes out to about half the size of Fedora Kinoite and the payoff is obvious: faster builds and pushes, faster downloads, smaller updates, and less disk wear.
- **Trimmed desktop.** Lean KDE Plasma with a few core apps and basic tools. I have no use for Akonadi, KDE Connect, PIM suite, etc. Saves space, builds faster and keeps the DE's resource usage lower.
- **Everything else on demand.** Flatpak, AppImages and distrobox handle the rest; you really don't need much on the image itself.

## Some experience notes

### Using it

After a year or so, CentOS Stream has proven to be a good base for a mixed-use, "immutable" desktop.

- **Stable and up to date.** The kernel may look old, but it gets frequent backports, and Mesa and firmware are recent enough even for newer hardware.
- **Good KDE experience.** EPEL ships a recent KDE version that has been working very well on CentOS Stream. My experience has actually been better than on Fedora, probably because new KDE versions land in EPEL a bit later than they do in Fedora.
- **First-class container tooling.** CentOS seems to be the flagship distro for bootc and podman-related container tools, with new stable releases landing very quickly.
- **Good for gaming.** Steam, Heroic and other launchers via Flatpak have worked without issues. After switching from Bazzite I benchmarked a few games and found no real difference. The CentOS-based image with Flatpak Steam was even a hair faster on a couple of titles, though all results were within the margin of error. DualSense and other controllers, VRR and emulation have worked fine as well.

### Building it

- **The stock base image is unreliable.** It has repeatedly stalled for weeks over upstream CI/bot issues, leaving you layering on top of an old kernel and other out-of-date packages. That's why I eventually started building my own base image, *leptos-base*.
- **Smaller package pool.** EPEL helps, but the rpm selection is still a lot narrower than Fedora's.
- **Keep the image lean.** You don't need much baked in. Install heavy tools like ROCm into a distrobox, and rely on Flatpak apps for media so no non-free codecs are needed on the image — you will only miss *some* file-manager thumbnails.
- **Watch the space hogs.** Skip firmware packages you don't need, as they take a lot of space. Fonts, themes, wallpapers, offline documentation, etc. also add up faster than you'd expect, so include only the essentials. You can always download them locally instead of baking them into every image.

### Why LeptOS?

The name is a simple two-letter swap from CentOS, and a nod to the leopard seal (*Hydrurga leptonyx*), since bootc uses a seal as its mascot.
