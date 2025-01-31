{ pkgs ? import <nixpkgs> {} }:
let
    # customOpensearch = pkgs.opensearch.overrideAttrs (finalAttrs: previousAttrs: {
    #   dataDir = "/var/lib/opensearch";
    #   extraJavaOptions = "-Xlog:disable";
    # });
  in
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      pkg-config
      icu
      libyaml
      libxml2
      buildPackages.ruby_3_3
      buildPackages.nodejs
      buildPackages.yarn
      python3Packages.supervisor
      #customOpensearch
      buildPackages.postgresql
      opensearch
      ];

    shellHook = ''
      export GEM_HOME=$PWD/.nix-gems
      export GEM_PATH=$GEM_HOME
      export PATH=$GEM_HOME/bin:$PATH
      export PATH=$PWD/bin:$PATH

      gem list -i ^bundler$ -v 2.5.6 || gem install bundler --version=2.5.6 --no-document
      bundle config set --local path vendor/bundle

      bundle install
    '';
}
