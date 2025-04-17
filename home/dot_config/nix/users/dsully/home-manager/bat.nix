# https://github.com/sharkdp/bat
{
  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      theme = "Nord";
      italic-text = "always";
      map-syntax = [
        ".dockerignore:Git Ignore"
        ".eslintignore:Git Ignore"
        ".eslintrc:JSON"
        ".lua-format:YAML"
        ".luacheckrc:Lua"
      ];
    };
  };
}
