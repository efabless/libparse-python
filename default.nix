{
  python3,
  buildPythonPackage,
  lib,
  pytest,
  nix-gitignore,
  clang,
  swig4,
}:

let
  yosys = builtins.fetchTarball {
    url = "https://github.com/yosyshq/yosys/archive/73cb4977b2e493b840b23419919a63be7c83e6df.tar.gz";
    sha256 = "sha256:0rhhx08dia0rd51rp3922vnqzi2fjarz1mrzp27s79k9y5k0mhzk";
  };
in
buildPythonPackage rec {
  name = "libparse";

  version_file = builtins.readFile ./libparse/__version__.py;
  version_list = builtins.match ''.+''\n__version__ = "([^"]+)"''\n.+''$'' version_file;
  version = builtins.head version_list;
  
  prePatch = ''
    rm -rf ./yosys
    cp -r ${yosys} ./yosys
  '';

  src = (nix-gitignore.gitignoreSourcePure ./.gitignore ./.);

  checkPhase = ''
    python3 ./test/test.py
  '';

  nativeBuildInputs = [
    clang
    swig4
  ];
  
  meta = with lib; {
    description = "Python wrapper around Yosys's libparse";
    license = with licenses; [asl20];
    homepage = "https://github.com/efabless/libpaprse-python";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
