{
    pkgs ? import <nixpkgs> {}
}:
with pkgs; mkShell {
    buildInputs = [
        swig
        clang_14
        clang-tools_14
        python3Full
        twine
    ];

    CC = "clang";
    CXX = "clang++";
}
