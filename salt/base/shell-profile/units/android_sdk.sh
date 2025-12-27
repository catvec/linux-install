export ANDROID_HOME="{{ pillar.android_sdk.sdk_root }}"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"

# Add all Android SDK build-tools to PATH
for dir in $ANDROID_HOME/build-tools/*/; do
    export PATH="$PATH:$dir"
done
