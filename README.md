# golang-scribe: go bindings for scribe

This repo contains auto generated [golang](https://golang.org/)
bindings for [scribe](https://github.com/facebookarchive/scribe).

## Why?

Here at Yelp we use Scribe in some of our Go based projects.
Scribe uses [Thrift](https://thrift.apache.org/) files to specify their
bindings, which is great for using Scribe with a wide variety of
languages, however, this doesn't really play well with the Go
ecosystem. You could just run the thrift compiler once, generate
the Go bindings and then use them everywhere.

This works perfectly fine, except now you're using this magically
generated file everywhere. We believe that our builds should be
easily reproducible. Thus, in this effort, we created this repo which
contains both the generated Go files for easy use and the build
process.

## Example Usage

If you just wanna use our bindings, just go get it with:

`go get github.com/Yelp/golang-scribe/scribe`

and add it like a normal Go
remote import like so

```go
import "github.com/Yelp/golang-scribe/scribe"
```

## Build Guide

Building the bindings yourself is very easy. You have two options,
build using docker, or without.

### With docker

The only dependencies if you're building with docker are:

  * git
  * make
  * docker

Simply run `make` and you should spin up a docker container that
downloads all the required dependencies and generate the bindings
for you.

### Without docker

Building without docker is also possible, albeit you'll need to grab
all the dependencies yourself. Please consult the `Dockerfile` in
the root of the project to see what you'll need.

After you've installed all the required dependencies, just run
`make build` and you should be set.

