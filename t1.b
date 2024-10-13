implement Command;
include "cmd.m";
include "xc.m";
xc : Xc;

main(nil:list of string)
{
	xc = load Xc "xcm.dis";
	xc->init();
	(a, b) := xc->read_input("ex1.dlx");
	print("%d\n", len a);
}
