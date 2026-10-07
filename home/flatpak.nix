{ ... }: {
  services.flatpak = {
    enable = true;
    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    packages = [
      "com.github.tchx84.Flatseal"
      "com.qq.QQ"
      "com.tencent.WeChat"
      "cn.feishu.Feishu"
      "org.zotero.Zotero"
      "com.termius.Termius"
    ];
    overrides = {
      writeMode = "replace";
      settings = {
        global = {
          Context.filesystems = [
            "/nix/store:ro"
            "xdg-config/gtk-3.0:ro"
          ];
          Environment = {
            LANG = "zh_CN.UTF-8";
          };
        };
        "cn.feishu.Feishu" = {
          "Session Bus Policy" = {
            "org.kde.StatusNotifierWatcher" = "talk";
            "org.kde.*" = "own";
          };
        };
        "com.qq.QQ" = {
          Context.sockets = [
            "x11"
            "!wayland"
            "!fallback-x11"
          ];
          Environment = {
            XDG_SESSION_TYPE = "x11";
          };
        };
        "org.zotero.Zotero" = {
          Context.filesystems = [
            "!home"
            "xdg-documents"
          ];
        };
      };
    };
  };
}
