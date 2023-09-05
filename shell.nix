{
    pkgs ? import <nixpkgs> {}
}:
with pkgs; mkShell {
    buildInputs = [
        swig
        clang_16
        clang-tools_16
        python3Full
        valgrind
        twine
    ];
}
