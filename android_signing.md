# Android App Signing Guide

This guide explains how to sign your Android app for release.

## Types of Keystores

1. **Debug Keystore**: Used during development

   - Located at `~/.android/debug.keystore`
   - Default password: `android`
   - Default alias: `androiddebugkey`
   - **Not for production use**

2. **Release Keystore**: Used for Play Store releases
   - Must be kept secure
   - Required for app updates
   - Generated following steps below

## 1. Generate a Release Keystore

Generate a keystore file using the `keytool` command:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be prompted to:

1. Create a password for the keystore
2. Enter your name, organization, and location details
3. Create a password for the key

**Keep these passwords safe!** You'll need them for future app updates.

## 2. Configure Key Properties

Create a file `[project]/android/key.properties` (do not commit this file to version control):

```properties
storePassword=<password from step 1>
keyPassword=<password from step 1>
keyAlias=upload
storeFile=<path to upload-keystore.jks>
```

Example:

```properties
storePassword=myStorePassword123
keyPassword=myKeyPassword123
keyAlias=upload
storeFile=/Users/username/upload-keystore.jks
```

## 3. Configure Gradle

Update `[project]/android/app/build.gradle`:

1. Add the key configuration before the `android` block:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
}
```

2. Replace the `buildTypes` block in the `android` block:

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

## 4. Build Release APK/Bundle

### Build APK

```bash
flutter build apk
```

The signed APK will be at `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle
```

The signed bundle will be at `build/app/outputs/bundle/release/app-release.aab`

## Security and Backup

### 1. Version Control Exclusion

Add to `.gitignore`:

```
**/android/key.properties
**/android/**/upload-keystore.jks
```

### 2. Backup Recommendations

Store securely:

- Keystore file (upload-keystore.jks)
- Keystore password
- Key password
- Key alias
- A copy of the signed APK

Consider:

- Secure password manager for credentials
- Encrypted backup of keystore file
- Company secure storage for team projects

### 3. Play Store Requirements

- Minimum 10,000 days validity period
- SHA-256 signing algorithm
- Full details in Play Console
- App signing by Google Play recommended

## Verifying the Signature

To verify the app is properly signed:

```bash
# For APK
apksigner verify --verbose build/app/outputs/flutter-apk/app-release.apk

# For App Bundle
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=release.apks
```

## Key Loss Consequences

If you lose your keystore:

1. Cannot update existing app on Play Store
2. Must publish as new app with different package name
3. Lose all ratings and reviews
4. Existing users won't get updates

## Troubleshooting

1. **Invalid keystore format**

   - Ensure the path in `key.properties` is absolute
   - Verify keystore file exists and is readable
   - Check file permissions

2. **Gradle sync failed**

   - Check all passwords in `key.properties` are correct
   - Verify the keyAlias matches the one used in keystore generation
   - Clean and rebuild project

3. **Build failed**

   - Ensure all paths use forward slashes, even on Windows
   - Verify the storeFile path is correct for your system
   - Try running `flutter clean` before building

4. **Signature verification failed**
   - Verify keystore file is not corrupted
   - Ensure correct passwords are being used
   - Check Gradle configuration matches key.properties
