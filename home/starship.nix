{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableTransience = true;

    # Pure Preset implementation in Starship
    settings = {
      # Add a blank line between shell commands
      add_newline = true;

      # Clean, two-line layout matching Pure
      format = "$directory$git_branch$git_status$cmd_duration\n$character";

      # Turn off default hostname/user noise
      username.show_always = false;
      hostname.ssh_only = true;

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](bold purple)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bold black";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };
    };
  };
}
