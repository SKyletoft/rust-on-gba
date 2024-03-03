{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url     = "github:nixos/nixpkgs/nixpkgs-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem(system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
				lib = nixpkgs.lib;
				gba-tools = pkgs.stdenv.mkDerivation {
					pname = "gba-tools";
					version = "1.2.0";

					src = pkgs.fetchFromGitHub {
						owner = "devkitPro";
						repo = "gba-tools";
						rev = "v1.2.0";
						sha256 = "sha256-8I0RbrLVUy/+klEQnsPvXWQYx5I49QGjqqw33RLzkOY=";
					};

					nativeBuildInputs = with pkgs; [ stdenv automake autoconf ];

					buildPhase = "./autogen.sh && ./configure && make gbafix";

					installPhase = ''
						mkdir -p $out/bin
						cp gbafix $out/bin
					'';
				};
			in rec {
				devShells.default = pkgs.mkShell rec {
					nativeBuildInputs = with pkgs; [
						rustup
						rust-analyzer

						mgba
						gba-tools

						gdb
						gcc-arm-embedded
					];
				};
			}
		);
}
