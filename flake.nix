{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        devPackages = [
          (pkgs.bats.withLibraries (p: [ p.bats-support p.bats-assert ]))
          pkgs.watchexec
        ];
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "git-wizard";
          version = "unstable";
          src = self;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postInstall = ''
            ls -al $target && \
              substituteInPlace $target/bin/tmux_git_wizard.sh \
                --replace  \$CURRENT_DIR $target
              substituteInPlace $target/git_wizard.tmux \
                --replace  \$CURRENT_DIR $target
              wrapProgram $target/bin/tmux_git_wizard.sh \
                --prefix PATH : ${with pkgs; lib.makeBinPath ([ fzf git gawk])}
          '';
        };
      in
      {
        packages.default = plugin;

        packages.dev = (pkgs.symlinkJoin
          {
            name = "dev-environment";
            paths = [
              plugin
              plugin.buildInputs
              pkgs.tmux
              pkgs.bashInteractive
              pkgs.busybox
            ] ++ devPackages;
          });

        devShell = pkgs.mkShell {
          buildInputs = devPackages;
        };
      }
    );
}
