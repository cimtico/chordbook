{ pkgs ? import <nixpkgs> {} }:
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

      buildPackages.postgresql
      ];
    # buildInputs = [ pkg-config zlib openssl libxml2 libxslt libyaml icu libiconv libffi ];

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
