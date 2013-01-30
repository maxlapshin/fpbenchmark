(ns cljwebtest.core
  (:require lamina.core aleph.http)
  (:require org.httpkit.server)
  (:require ring.adapter.jetty)
  (:use [clojure.tools.cli :only [cli]])
  (:gen-class))

(defn hello-aleph [port]
  (defn hello-world [channel request]
    (lamina.core/enqueue channel
                         {:status 200
                          :headers {"content-type" "text/html"}
                          :body "Hello World from Aleph!"}))

  (println "Starting Aleph webserver on port" port)
  (aleph.http/start-http-server hello-world {:port port}))

(defn hello-http-kit [port]
  (defn hello-world [req]
    {:status 200
     :headers {"Content-Type" "text/plain"}
     :body "Hello World from http-kit!"})

  (println "Starting http-kit webserver on port" port)
  (org.httpkit.server/run-server hello-world {:port port}))

(defn hello-ring-jetty [port]
  (defn hello-world [req]
    {:status  200
     :headers {"Content-Type" "text/plain"}
     :body    "Hello World from ring-jetty!"})

  (println "Starting ring-[over]-jetty webserver on port" port)
  (ring.adapter.jetty/run-jetty hello-world {:port port}))

(defn -main
  [& args]
  (let [[options args banner]
        (cli args
             ["-h" "--help" "Show help" :default false :flag true]
             ["-s" "--server" (str "Type of Clojure webserver to start "
                                   "(aleph, http-kit, ring-jetty)")]
             ["-p" "--port" "Which port should be used"
              :default 8080 :parse-fn #(Integer. %)])]
    (when (or (:help options) (not (:server options)))
      (println banner)
      (System/exit 0))
    (let [port (:port options)]
      (condp = (:server options)
        "aleph" (hello-aleph port)
        "http-kit" (hello-http-kit port)
        "ring-jetty" (hello-ring-jetty port)
        (do (println banner)
            (System/exit 0))))))
