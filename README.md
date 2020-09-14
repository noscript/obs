#### Install OSC

```sh
sudo apt install osc
```

#### Check out the home project

```sh
HOME_PROJECT=home:$OBS_USERNAME
osc checkout $HOME_PROJECT
rsync -avh ./$HOME_PROJECT/ .
rm -rf ./$HOME_PROJECT
```

#### Create a new package

```sh
./mkpac.sh $PACKAGE_NAME [$GIT_URL]
```

#### Commit changes

```sh
git commit
git push
osc commit -n
```

#### Pull changes from OBS

```sh
osc update
```

#### Trigger rebuild

```sh
osc service remoterun $(cat .osc/_project) $PACKAGE_NAME
```

#### Wait for build to finish

```sh
osc service wait $(cat .osc/_project) $PACKAGE_NAME
```

#### Download sources

```sh
osc checkout -S -o ${PACKAGE_NAME}-SOURCES $PACKAGE_NAME
```

#### Print build status

```sh
osc prjresults -n $PACKAGE_NAME -a $(arch) -q
```

#### Print build log

```sh
osc remotebuildlog $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch)
```

#### List binaries

```sh
osc list -b $(cat .osc/_project) -r $(lsb_release -cs) -a $(arch) $PACKAGE_NAME
```

#### Download binaries

```sh
osc getbinaries -d BINARIES $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch) [FILE]
```

#### Unpack package sources

```sh
dpkg-source -x ${PACKAGE_NAME}.dsc
```

#### Packaging Rust

create `debian.install`:
```sh
echo "target/release/$PACKAGE_NAME usr/bin" > debian.install
```

append to `_service`:
```xml
<service name="download_url">
  <param name="path">dist/rust-1.41.0-x86_64-unknown-linux-gnu.tar.gz</param>
  <param name="host">static.rust-lang.org</param>
  <param name="filename">rust-1.41.0-x86_64-unknown-linux-gnu.tar.gz_</param>
</service>
```

create vendor tarball:
```sh
wget https://static.rust-lang.org/dist/rust-1.41.0-x86_64-unknown-linux-gnu.tar.gz
tar -xf rust-1.41.0-x86_64-unknown-linux-gnu.tar.gz
mkdir .cargo
./rust-1.41.0-x86_64-unknown-linux-gnu/cargo/bin/cargo vendor > .cargo/config
tar -cvzf vendor.tar.gz_ vendor/ .cargo/config
osc add vendor.tar.gz_
```

update `debian.rules`:
```Makefile
#!/usr/bin/make -f

.ONESHELL:
DEB_BUILD_OPTIONS=noddebs
RUST_DIR := $(shell readlink -f ../SOURCES)/rust-1.41.0-x86_64-unknown-linux-gnu

%:
	dh $@

override_dh_auto_build:
	# provided by _service:download_url:rust-1.41.0-x86_64-unknown-linux-gnu.tar.gz_:
	echo "343ba8ef7397eab7b3bb2382e5e4cb08835a87bff5c8074382c0b6930a41948b  $(RUST_DIR).tar.gz_" | sha256sum -c
	tar -xf $(RUST_DIR).tar.gz_ -C ../SOURCES
	$(RUST_DIR)/install.sh --prefix=$(RUST_DIR)/_local --disable-ldconfig
	export PATH=$(RUST_DIR)/_local/bin:$(PATH)

	tar -xf ../SOURCES/vendor.tar.gz_
	cargo build --release
```

commit and push:
```sh
git commt
git push
osc commit -n
```

#### Local build

```sh
sudo apt install fakeroot dpkg-dev debhelper
osc getbinaries -d BINARIES $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch)
dpkg-source -x $PACKAGE_NAME*.dsc
cd $PACKAGE_NAME*
dpkg-buildpackage  -us -uc
ls ../*.deb
```
