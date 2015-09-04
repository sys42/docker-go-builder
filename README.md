# Go Installation in a Docker Container

If you don't want to install Go locally, this image is exactly for you. All you need is Docker installed.

### Go and it's Build Environment

I still don't get it why the required directory structure for building a Go program is the way it is. IMHO its really stupid to either depend on the external path where you checkout a project or doing some symlink magic like a crazy devil.

But what do I know. Selfcontained and easy-to-build repositories are obviously not the intended target.

Enough ranting. The image takes care of manipulating GOPATH and GOBIN.

### Usage of the Image

Script `go.sh` should take away most of the burden of specifying commandline arguments for the container. Just use `go.sh` like you would use `go` with a locally installed golang package. All parameters are handed over to the go binary within the container. 

Have a look at its source if you want to know the details or want to customize it further.

#### Building statically linked binaries

Statically linking enables you to put these binaries in otherwise complete empty containers. Here is an example of a Dockerfile for a complete empty container beside a binary:

```
FROM scratch
ADD my_program /
ENTRYPOINT ["/my_program"]
```

If a binary is not statically linked, it wouldn't run in such a container, because it still requires some dynamically linked libraries like libc.

To generate a statically linked program use `go.sh` like this

```
CGO_ENABLED=0 ./go.sh build -a --ldflags='-s'
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
GOOS=windows GOARCH=386 ./go.sh build
```

For valid GOOS and GOARCH combinations, see: [http://golang.org/doc/install/source#environment](http://golang.org/doc/install/source#environment)

