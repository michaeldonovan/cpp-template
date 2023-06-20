{
  description = "<description>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }@inputs:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        stdenv = pkgs.gcc13Stdenv;

        nativeBuildInputs = with pkgs; [
          cmake
          ninja
        ];
      in

      {
        packages = with pkgs;{
          pkg = stdenv.mkDerivation {
            pname = "<name>";
            version = "0.0.1";
            src = ./.;
            cmakeFlags = [
              "-GNinja"
            ];

            nativeBuildInputs = nativeBuildInputs;
            enableParallelBuilding = true;

            meta = with lib; {
              description = "<description>";
              license = licenses.gpl3;
              platforms = platforms.all;
              maintainers = with maintainers; [ michaeldonovan ];
            };
          };
        };

        devShell = stdenv.mkDerivation {
          name = "devShell";
          nativeBuildInputs = [ pkgs.gdb nativeBuildInputs ];
        };

        defaultPackage = self.packages.${system}.pkg;
      });
}
