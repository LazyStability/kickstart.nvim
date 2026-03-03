# neovim.nix
{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,
  vimUtils,
  fetchFromGitHub,
  lib,
}:
let
  packageName = "mypackage";

  startPlugins = with vimPlugins; [
    # Lazy loading
    lz-n

    # nvim-cmp
    # nvim-lint
    # nvim-lspconfig
    # typst-vim
    # telescope-fzf-native-nvim
    # vimPlugins.plenary-nvim # not needed, since it will be pulled automatically as a dependency
    # Treesitter, a context provider
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context

    ## Quality of life stuff ##
    # Nice html functionality in non-native fileformats
    nvim-ts-autotag

    ## UI ##
    # Theme
    catppuccin-nvim
    tokyonight-nvim

    nvim-web-devicons

    # Notification window
    fidget-nvim
  ];
  optPlugins = with vimPlugins; [
    ## Quality of life changes ##
    # Format
    conform-nvim
    mini-sessions
    # Auto close pairs of brackets or similar symbols
    mini-pairs
    # nvim-autopairs

    # Surround selection or delete surrounding
    (vimUtils.buildVimPlugin {
      name = "nvim-surround";
      src = fetchFromGitHub {
        owner = "kylechui";
        repo = "nvim-surround";
        rev = "a868c256c861044beb9794b4dd126480dcdfbdad";
        hash = "sha256-sbLPR1x3lP8Dg+neFeO0elnHFT55rCY3F1uGGtU1nAU=";
      };
    })
    # Show a tree of all changes
    undotree

    # Magit like git integration in neovim
    neogit
    diffview-nvim

    # shows git changes & enables partial commiting
    gitsigns-nvim

    # comment-nvim
    vim-nix

    ## Interaction with the terminal ##
    # Use nvim as a scrollback buffer in kitty
    kitty-scrollback-nvim
    # Enable movement between nvim panes and terminal panes (or tmux, zelij, etc.)
    smart-splits-nvim

    ## UI ##
    # Adds intentation help on blanklines
    indent-blankline-nvim
    # Nice UI for keybindings
    which-key-nvim
    # nicer statusline
    lualine-nvim
    # Renders special comments
    todo-comments-nvim
    # Show pretty markdown files
    render-markdown-nvim
  ];

  foldPlugins = builtins.foldl' (
    acc: next:
    acc
    ++ [
      next
    ]
    ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);
  optPluginsWithDeps = lib.unique (foldPlugins optPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ln -vsfT ${./myplugin} $out/pack/${packageName}/start/myplugin

    ${
      lib.concatMapStringsSep "\n" (
        plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
      ) startPluginsWithDeps
      + "\n"
      + lib.concatMapStringsSep "\n" (
        plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/opt/${lib.getName plugin}"
      ) optPluginsWithDeps
    }
  '';
in
symlinkJoin {
  name = "neovim-custom";
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags 'NORC' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
      --set-default NVIM_APPNAME nvim-custom
  '';

  passthru = {
    inherit packpath;
  };
}
