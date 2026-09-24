# Savings Pro for Android

The Android app bundles the repository's `index.html` inside a WebView served from a secure local HTTPS origin. Its launcher icon uses the same Savings Pro logo as the website. Internet access is still required for Supabase, Cloudinary, and images/scripts loaded from the web.

## Install the test APK

Download `downloads/SavingsPro.apk` from the running app's `/downloads/SavingsPro.apk` path, open it on an Android phone (Android 6.0 or newer), and allow installation from your browser/files app when prompted. This is a **debug-signed test APK**, not a Play Store release. To distribute updates without uninstalling, keep a stable release signing key and increment `versionCode` in `app/build.gradle`.

## Rebuild

Use Java 17, Gradle 8.10.2, Android SDK platform 35 and build tools 35.0.0. From the repository root, set `SUPABASE_URL` and `SUPABASE_ANON_KEY` in your build environment and run `./android/build-apk.sh`. The script copies the current web page into Android assets, writes only the **public** Supabase URL and anon key to the app's `config.js`, and copies the debug build to `downloads/SavingsPro.apk`. It deliberately does **not** package `SUPABASE_SERVICE_KEY`. Never include a service-role key in an APK: anyone can extract its files. Features relying on that key require a trusted server before production use.

The generated `android/app/src/main/assets/` directory is ignored by Git; rebuild the APK after editing the website. The logo source is `app/src/main/res/drawable-nodpi/logo.png`, with the legacy launcher image in `mipmap-anydpi/ic_launcher.png` and an adaptive icon in `mipmap-anydpi-v26/ic_launcher.xml`.
