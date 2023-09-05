{
    pkgs ? import <nixpkgs> {}
}:
with pkgs; mkShell {
    buildInputs = [
        swig
        clang
        python3Full
        valgrind
        twine
    ];
}
