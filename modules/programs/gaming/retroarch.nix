{ ... }: {
  programs.retroarch = {
    enable = true;
    cores = {
      melonds.enable = true;
      ppsspp.enable = true;
      swanstation.enable = true;
    };
    settings = { };
  };
}
