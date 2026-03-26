{config, pkgs, ...}: {
  home.packages = with pkgs; [
    pfetch-rs
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "rust" "docker" ];
    };
    initContent = ''
    case $(tty) in
      (/dev/tty[1-9]);;
      (*)
        eval pfetch;;
    esac
    '';
  };
}

