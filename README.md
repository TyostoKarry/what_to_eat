# what_to_eat

## Build

### Full APK with all ABIs

To build a full APK with all ABIs, run the following command:

```bash
flutter build apk
```

This will create a single APK file that contains all the necessary architecture-specific code for ARM, ARM64, x86, and x86_64.

### Separate APKs for each ABI

To build separate APKs for each ABI, run the following command:

```bash
flutter build apk --split-per-abi
```

This will create separate APK files for each architecture:

- `app-armeabi-v7a-release.apk` (ARM)
- `app-arm64-v8a-release.apk` (ARM64)
- `app-x86_64-release.apk` (x86_64)

Note that building separate APKs for each ABI can result in smaller APK files, but it may also increase the complexity of your app's distribution and installation process.
