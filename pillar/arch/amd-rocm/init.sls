amd_rocm:
  multipkgs:
    - pkg:
        - rocm-core
        - rocm-hip-runtime
        - rocm-language-runtime
        
        - rocm-device-libs

        # utilities
        - rocminfo

        # Dev tools
        - rocm-cmake
        - rocm-llvm
        - rocm-smi-lib
        - rocm-toolchain
        - rocm-ml-sdk
