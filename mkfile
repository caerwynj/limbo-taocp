%.dis: %.b
	limbo -g $stem.b

DIS=\
	nqueens.dis\
	nqueens2.dis\
	nqueens3.dis\
	langford.dis\
	xcc.dis\
	xccm.dis\
	debug.dis

all: $DIS
	echo done

test: xccm.dis xcc.dis
	mash ./xcc.dis ex1.dlx

clean:
	rm *.sbl

nuke:
	rm -f *.sbl *.dis

profile:
	emu-g sh -l -c "cprof -f -m Command xcc ex1.dlx" | awk -f countmems.awk
