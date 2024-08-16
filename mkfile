%.dis: %.b
	limbo -gw $stem.b

all: nqueens.dis nqueens2.dis nqueens3.dis langford.dis xcc.dis xccm.dis
	echo done

test: xccm.dis  xcc.dis
	mash ./xcc.dis ex1.dlx
