{
  pkgs ? import <nixpkgs> { },
}:

let
  # Import the necessary packages
  neovim-unwrapped = pkgs.neovim;

  # Get the current directory as a path
  src = ./.;

  # Create a custom init.lua that will work with Nix
  initLua = pkgs.runCommandLocal "init.lua" { } ''
    cp ${src}/init.lua $out
  '';

  # Create a packpath structure that follows Neovim's expected directory layout
  packpath = pkgs.runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/myconfig/{start,opt}

    # Copy all our config files to the pack structure
    mkdir -p $out/pack/myconfig/start/
    cp -r ${src}/lua $out/pack/myconfig/start/
    cp -r ${src}/after $out/pack/myconfig/start/
    cp -r ${src}/doc $out/pack/myconfig/start/
    cp ${src}/init.lua $out/pack/myconfig/start/
  '';

  # Create a wrapper script with proper environment variables
  wrapper = pkgs.runCommandLocal "nvim-wrapper" { } ''
    mkdir -p $out/bin
    cat > $out/bin/nvim << 'EOF'
    #!${pkgs.bash}/bin/bash
    export NVIM_APPNAME="nvim-custom"
    exec -a "$0" ${neovim-unwrapped}/bin/nvim -u ${initLua} --cmd 'set packpath^=${packpath} | set runtimepath^=${packpath}' "$@"
    EOF
    chmod +x $out/bin/nvim
  '';

  # Create the final package
  neovim-pkg = pkgs.symlinkJoin {
    name = "neovim-custom";
    paths = [
      neovim-unwrapped
      packpath
      wrapper
    ];
  };

in
neovim-pkg
