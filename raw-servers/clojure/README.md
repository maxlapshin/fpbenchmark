It's a package for testing Clojure webservers with fpbenchmark.

Getting up and running
======================

First of all, JVM is needed. We will use Oracle's JVM. On Ubuntu,
it can be installed like this:

    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java7-installer

Now, you need Leiningen (the following was taken from Leiningen's README.md):

    wget https://raw.github.com/technomancy/leiningen/stable/bin/lein
    chmod +x lein

Finally, you can run `./lein uberjar` in this directory. This command will build
the project and include all dependencies in a stand-alone jar that can be
run like this:

    java -jar target/cljwebtest-0.1.0-SNAPSHOT-standalone.jar -s http-kit

You can get a list of available commandline options like this:

> java -jar target/cljwebtest-0.1.0-SNAPSHOT-standalone.jar --help
Usage:

 Switches               Default  Desc
 --------               -------  ----
 -h, --no-help, --help  false    Show help
 -s, --server                    Type of Clojure webserver to start (aleph, http-kit, ring-jetty)
 -p, --port             8080     Which port should be used

