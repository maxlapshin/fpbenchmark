It's a package for testing Clojure webservers with fpbenchmark.

Getting up and running
======================

First of all, JVM is needed. We will use Oracle's JVM. On Ubuntu,
it can be installed like this:

  1. `sudo apt-get install java-package`
  2. download Java 7 SDK from [here](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
  3. run `fakeroot make-jpkg [file that you've downloaded from oracle.com]`
  4. `sudo dpkg -i` on deb that was made on previous step

Now, you need Leiningen (the following was taken from Leiningen's README.md):

  1. [Download the script](https://raw.github.com/technomancy/leiningen/stable/bin/lein).
  2. Place it on your `$PATH`. (I like to use `~/bin`)
  3. Set it to be executable. (`chmod 755 ~/bin/lein`)

Finally, you can run `lein uberjar` in this directory. This command will build
the project and include all dependencies in a stand-alone jar that can be
run like this:

`java -jar target/cljwebtest-0.1.0-SNAPSHOT-standalone.jar -s http-kit`

You can get a list of available commandline options like this:

```
> java -jar target/cljwebtest-0.1.0-SNAPSHOT-standalone.jar --help
Usage:

 Switches               Default  Desc
 --------               -------  ----
 -h, --no-help, --help  false    Show help
 -s, --server                    Type of Clojure webserver to start (aleph, http-kit, ring-jetty)
 -p, --port             8080     Which port should be used
```
