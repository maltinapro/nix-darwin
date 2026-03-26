{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
   
    profiles.default = {
      userSettings = {
        "files.autoSave" = "onFocusChange"; 
        "editor.fontSize" = 12;

        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.profiles.osx" = {
          "zsh" = {
            "path" = "zsh";
            "args" = [ "-l" ]; # This '-l' is the "Login" flag
          };
        };
        "terminal.integrated.defaultProfile.osx" = "zsh";

        "editor.fontFamily" = "JetBrainsMono Nerd Font, JetBrainsMono NF, monospace";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
      };

      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
      ];
    };
  };

  home.packages = [ pkgs.nixd ];
}