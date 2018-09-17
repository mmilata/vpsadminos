{lib, vpsadmin}:

[
        (import ./overlays/gem-config.nix)
        (import ./overlays/osctl.nix)
        (import ./overlays/tools.nix)
        (import ./overlays/lxc.nix)
        (import ./overlays/lxcfs.nix)
        (import ./overlays/htop.nix)
        (import ./overlays/zfs.nix)
        (import ./overlays/minify.nix)
] ++ lib.optionals (vpsadmin != null && (lib.isStorePath vpsadmin || lib.pathExists vpsadmin))
        [(import ./overlays/vpsadmin.nix vpsadmin)]
