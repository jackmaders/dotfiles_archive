{...}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./themes/pure.toml);
  };
}
