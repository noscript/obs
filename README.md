# Install OSC

```
sudo apt install osc
```

# Check out the home project

```
osc checkout $HOME_PROJECT
rsync -avh ./$HOME_PROJECT/ .
rm -rf ./$HOME_PROJECT
```

# Create a new package

```
./mkpac.sh $PACKAGE_NAME [$GIT_URL]
```

# Commit changes

```
git commit
git push
osc commit -n
```

# Pull changes from OBS

```
osc update
```

# Trigger rebuild

```
osc service remoterun $(cat .osc/_project) $PACKAGE_NAME
```

# Wait for build to finish

```
osc service wait $(cat .osc/_project) $PACKAGE_NAME
```

# Download sources

```
osc checkout -S -o ${PACKAGE_NAME}-SOURCES $PACKAGE_NAME
```

# Print build status

```
osc prjresults -n $PACKAGE_NAME -a $(arch) -q
```

# Print build log

```
osc remotebuildlog $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch)
```

# List binaries

```
osc list -b $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch)
```

# Download binaries

```
osc getbinaries -d BINARIES $(cat .osc/_project) $PACKAGE_NAME $(lsb_release -cs) $(arch) [FILE]
```

# Unpack package sources

```
dpkg-source -x ${PACKAGE_NAME}.dsc
```
