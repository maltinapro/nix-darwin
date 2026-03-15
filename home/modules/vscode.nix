{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
   
    profiles.default = {
      userSettings = {
        "files.autoSave" = "onFocusChange"; 
        "editor.fontSize" = 14;

        "terminal.integrated.fontSize" = 14;

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