%.dis: %.b
	limbo -g $stem.b

DIS=\
	nqueens.dis\
	nqueens2.dis\
	nqueens3.dis\
	langford.dis\
	xc.dis\
	xcm.dis\
	debug.dis\
	xcc.dis\
	xccm.dis\
	t1.dis\
	t2.dis

all: $DIS
	echo done

test: xcm.dis xc.dis xccm.dis xcc.dis
	mash ./xcc.dis ex4.dlx
	mash run -x mashfile

clean:
	rm *.sbl

nuke:
	rm -f *.sbl *.dis

profile:
	emu-g sh -l -c "cprof -f -m Command xc ex1.dlx" | awk -f countmems.awk
