
# Initial setup

Setup Rust:

```
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"

# required for cross-compilation
rustup target add aarch64-linux-android
rustup target add arm-linux-androideabi
rustup target add i686-linux-android
rustup target add x86_64-linux-android

# Verify installed cross-compilation libraries
rustup target list | grep "android.* (installed)"

rustup toolchain list
```

Setup Python venv:

```
yay -S miniconda3

source /opt/miniconda3/etc/profile.d/conda.sh
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
conda create -n build-wheel python=3.10
conda activate build-wheel
pip install -r server/pypi/requirements.txt
```

# Build

```
source "$HOME/.cargo/env"
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate build-wheel

cd ~/src/chaquopy/server/pypi
rm -rf dist
git checkout server/pypi/dist/.gitignore

PYTHON_VER=3.10
ABIS=(x86 armeabi-v7a arm64-v8a x86_64)
PACKAGES=(cryptography mitmproxy_rs aioquic pylsqpack)

for PKG in $PACKAGES; do
  do_break=0

  for ABI in $ABIS; do
    echo "Building $PKG for $ABI..."
    ./build-wheel.py --python $PYTHON_VER --abi $ABI $PKG

    if [ $? -ne 0 ]; then
      do_break=1
      break
    fi
  done

  if [ $do_break -eq 1 ]; then
    break
  fi
done

find dist -name "*.whl" -exec mv {} ~/src/PCAPdroid-mitm/submodules/chaquopy-wheels \;
```
