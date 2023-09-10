{
    pkgs ? import <nixpkgs> {}
}:
with pkgs; mkShell {
    buildInputs = [
        swig4
        clang_14
        clang-tools_14
        python3Full
        twine
    ];

    shellHook = ''
    export CC=${clang_14}/bin/clang
    export CXX=${clang_14}/bin/clang++
    '';
}
