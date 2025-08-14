{
  lib,
  pkgs,
}:
# Adapted from github:jakehamilton/tmux
let
  hr = text: let
    parts = builtins.split "." text;
  in
    builtins.foldl'
    (
      text: part:
        if builtins.isList part
        then "${text}-"
        else text
    )
    ""
    (builtins.tail parts);

  config-files = lib.snowfall.fs.get-files-recursive ./config;
  extra-config =
    lib.concatMapStringsSep
    "\n"
    (file: ''
      # ${file}
      # ${hr file}

      ${builtins.readFile file}
    '')
    config-files;

  shell = "${pkgs.pwzsh}/bin/pwzsh";
  plugins = with pkgs.tmuxPlugins; [
    resurrect
    sensible
    open
    # continuum
    # nord
    # tilish
    tmux-fzf
    vim-tmux-navigator
  ];
in
  lib.pwtmux.mkConfig {
    inherit pkgs plugins extra-config shell;
  }
