
#  This is your file 
# Add your configurations here
export EDITOR=nvim

if command -v yay >/dev/null; then
    export aurhelper="yay"
elif command -v paru >/dev/null; then
    export aurhelper="paru"
fi

# Android 
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME='/opt/android-sdk'
export JAVA_HOME='/usr/lib/jvm/java-17-openjdk'
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'

export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest:$PATH"
