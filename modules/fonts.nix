{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji-blob-bin
    noto-fonts-cjk-sans
    
    nerd-fonts.terminess-ttf
    nerd-fonts._0xproto 
    nerd-fonts.symbols-only
  ];
}
