%.dis: %.b
	limbo -gw $stem.b

all: nqueens.dis nqueens2.dis nqueens3.dis langford.dis xcc.dis
	echo done

test: in.dis 
	mash ./in.dis ex1.dlx
