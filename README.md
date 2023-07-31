# APK Tool - Shell Script for Decompiling and Compiling APK Packages

## Overview

APK Tool is a shell script that simplifies the decompilation and compilation of APK (Android Package) files. This script uses the popular APKTool for decompiling APK packages, and it also utilizes Jarsigner for signing the compiled APKs. The repository includes the script and other necessary files.

## Prerequisites

Before using this script, make sure you have the following tools installed on your system:

-   Java Development Kit (JDK)
-   APKTool
-   Jarsigner
-   Keytool (for creating keystores if needed)

## Usage

The APK Tool script supports two main commands:

1. Decompiling an APK package:

```bash ./apk_tool.sh decompile package_name.apk```

This command decompiles the specified APK package into a folder named "package_name" and creates a subfolder "source_code" to store the decompiled files.

2. Compiling source code into an APK package:

```bash ./apk_tool.sh compile package_name [optional_keystore] [optional_keystore_alias]```

This command compiles the source code located in the "package_name/source_code" folder into an APK package with the filename "package_name_dd-mm-yyyy.apk", where "dd-mm-yyyy" represents the current date.

If you want to sign the compiled APK, you can provide the optional_keystore and optional_keystore_alias arguments. If not provided, the script will use default values.

## Notes

-   Ensure the APKTool and Jarsigner are in the same directory as the script or add their paths to the system's PATH variable.
-   If you have existing keystores, provide their paths in the compile command, or the script will generate a new keystore.

## Disclaimer

This script is provided as-is, and the author takes no responsibility for any misuse or damages that may arise from its usage. Use it responsibly and at your own risk.
