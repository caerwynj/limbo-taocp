%.dis: %.b
	limbo -g $stem.b

DIS=\
	nqueens.dis\
	nqueens2.dis\
	nqueens3.dis\
	langford.dis\
	xc.dis\
	xcm.dis\
	debug.dis

all: $DIS
	echo done

test: xcm.dis xc.dis
	mash ./xc.dis ex1.dlx

clean:
	rm *.sbl

nuke:
	rm -f *.sbl *.dis

profile:
	emu-g sh -l -c "cprof -f -m Command xc ex1.dlx" | awk -f countmems.awk
