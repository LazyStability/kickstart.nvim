{ pkgs ? import <nixpkgs> { } }:

let
  lib = pkgs.lib;
  neovim-unwrapped = pkgs.neovim;

  src = ./.;
  packageName = "nvim-custom";

  plugins = with pkgs.vimPlugins; [
    # Completion
    nvim-cmp
    luasnip
    cmp_luasnip
    cmp-nvim-lsp
    cmp-path
    friendly-snippets

    # Treesitter
    nvim-treesitter
    nvim-treesitter-context

    # Fuzzy finder
    telescope-nvim
    plenary-nvim
    telescope-fzf-native-nvim
    telescope-ui-select-nvim

    # LSP
    nvim-lspconfig
    fidget-nvim
    neodev-nvim

    # UI
    lualine-nvim
    nvim-web-devicons
    gitsigns-nvim
    tokyonight-nvim
    which-key-nvim
    indent-blankline-nvim

    # Formatters & Linters
    conform-nvim
    nvim-lint

    # Git
    neogit
    diffview-nvim

    # Editor
    undotree
    nvim-surround
    smart-splits-nvim
    nvim-autopairs
    comment-nvim
    vimtex

    # Markdown
    obsidian-nvim
    render-markdown-nvim
    todo-comments-nvim

    # Debug
    nvim-dap
    nvim-dap-ui
    nvim-nio
    nvim-dap-virtual-text

    # Misc
    image-nvim
  ];

  initLua = pkgs.runCommandLocal "init.lua" { } ''
    cp ${src}/init.lua $out
  '';

  packpath = pkgs.runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (plugin: ''
      ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}
    '') plugins}

    mkdir -p $out/pack/${packageName}/start/myconfig
    cp -r ${src}/lua $out/pack/${packageName}/start/myconfig/
    cp -r ${src}/after $out/pack/${packageName}/start/myconfig/
    cp -r ${src}/doc $out/pack/${packageName}/start/myconfig/
    cp ${src}/init.lua $out/pack/${packageName}/start/myconfig/
  '';

  wrapper = pkgs.runCommandLocal "nvim-wrapper" { } ''
    mkdir -p $out/bin
    cat > $out/bin/nvim << 'WRAPPER_EOF'
    #!${pkgs.bash}/bin/bash
    export NVIM_APPNAME="${packageName}"
    exec -a "$0" ${neovim-unwrapped}/bin/nvim -u ${initLua} --cmd "set packpath^=${packpath}" --cmd "set runtimepath^=${packpath}" "$@"
    WRAPPER_EOF
    chmod +x $out/bin/nvim
  '';

  neovim-pkg = pkgs.symlinkJoin {
    name = packageName;
    paths = [
      neovim-unwrapped
      packpath
      wrapper
    ];
  };

in
neovim-pkg
