
yesod: yesod.hs
	ghc --make -threaded -rtsopts yesod.hs

run:
	./yesod production +RTS -N4 -A1000000 2>/dev/null

bench:
	httperf --hog --client=0/1 --server=localhost --port=8080 --uri=/ --rate=1000 --send-buffer=4096 --recv-buffer=16384 --num-conns=100 --num-calls=100 --burst-length=20 | grep "^Request rate"

clean:
	rm -f *.hi *.o warp yesod
