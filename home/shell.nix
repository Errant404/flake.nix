{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
    ];
    sessionVariables = {
      MCFLY_PATH = "${pkgs.mcfly}/bin/mcfly";
    };
  };
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
    };
  };
}
