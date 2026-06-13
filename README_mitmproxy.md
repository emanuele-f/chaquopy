The following instructions are specific to build the python 3.13 wheels required by mitmproxy on archlinux.

# Setup

```
sudo pacman -S rustup patchelf patch

yay -S python313 android-sdk-cmdline-tools-latest

# assumes the SDK is installed at ANDROID_HOME
/opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root="$ANDROID_HOME" --install "ndk;27.3.13750724"

# configure cross compilation Rust toolchains
rustup default stable
rustup target add aarch64-linux-android
rustup target add x86_64-linux-android

# download and prepare the Python target
./target/download-target.sh maven/com/chaquo/python/target/3.13.9-0

# install the requirements into a virtual environment
cd server/pypi
python3.13 -m venv .venv
source .venv/bin/activate
pip -r requirements.txt
```

See `server/pypi/README.md` for more detailed instructions.

# Build

Run `./build-mitmproxy-deps.sh` to build the required dependencies
