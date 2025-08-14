{
  description = "PW's tmux with config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwzsh.url = "github:zmre/pwzsh";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      # You must provide our flake inputs to Snowfall Lib.
      inherit inputs;

      # The `src` must be the root of the flake. See configuration
      # in the next section for information on how you can move your
      # Nix files to a separate directory.
      src = ./.;

      overlays = [
        (final: prev: {
          inherit (inputs.pwzsh.packages.${final.system}) pwzsh;
        })
      ];

      alias.packages.default = "pwtmux";
      snowfall = {
        namespace = "pwtmux";
        meta = {
          name = "pwtmux";
          title = "PW Tmux Config";
        };
      };
    };
}
