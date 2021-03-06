# Go Installation in a Docker Container

If you don't want to install Go locally, this image is exactly for you. All you need is Docker installed.

### Go and it's Build Environment

I still don't get it why the required directory structure for building a Go program is the way it is. IMHO its really stupid to either depend on the external path where you checkout a project or doing some symlink magic like a crazy devil.

But what do I know. Selfcontained and easy-to-build repositories are obviously not the intended target.

Enough ranting. The image takes care of manipulating the required environment settings.

### Usage of the Image

Script `go-builder` should take away most of the burden of specifying commandline arguments for the container. Just use `./go-builder` as a prefix to commands like `go build`.

Examples:

```
./go-builder go get
./go-builder go build
./go-builder go fmt
```

Command `go` isn't inserted by the script automatically, because this way you can call other commands, too.

```
# a stupid one
./go-builder ls -l
# more useful
./go-builder make
# much more useful
./go-builder godep save
```

Unless specified via environment variables otherwise, `go-builder' will use subdirectory __vendor__ to store vendored packages. If this subdirectory don't exist, it will be generated.

You can override the used directory by specifying environment variable GOVENDOR. If you do so, please make sure, that the environment variable point to subdirectory of `/src` (the project directory within the container).


To setup GOPATH correctly the image needs to know the fully-qualified package name of the package to compile. You can either set it in file .godir or you can use an import annotation in your main file like this:

```
package main // import "github.com/MyAccount/hello"
```

To handle dependencies, __godep__ and __glock__ are preinstalled.

Handling of variables is yet a little bit cumbersome. Quoting or escaping doesn't seem to work. Until I'll find a solution you have to use subshells or `eval`:

```
## very hack-ish ...
./go-builder sh -c 'echo "user=$UID"'
./go-builder eval 'echo "user=$UID"'
```

#### Building statically linked binaries

Statically linking enables you to put these binaries in otherwise complete empty containers. Here is an example of a Dockerfile for a complete empty container beside a binary:

```
FROM scratch
ADD my_program /
ENTRYPOINT ["/my_program"]
```

If a binary is not statically linked, it wouldn't run in such a container, because it still requires some dynamically linked libraries like libc.

To generate a statically linked program use `go-builder` like this

```
CGO_ENABLED=0 ./go-builder go build -a  -installsuffix cgo -ldflags='-s'
```

To verify that is really statically linked (in this case binary `testapp`), run:

```
ldd testapp
```

What's really strange is: the statically linked binaries are much smaller than their dynamically linked counterparts. Can someone explain this? Shouldn't it be the other way around?

#### Cross Compiling

Since Go 1.5 cross compiling is really simple. Just set to environment variables. Here is an example of cross compiling using this image:

```
## produces testapp.exe
GOOS=windows GOARCH=386 ./go-builder go build
```

For valid GOOS and GOARCH combinations, see: [http://golang.org/doc/install/source#environment](http://golang.org/doc/install/source#environment)


