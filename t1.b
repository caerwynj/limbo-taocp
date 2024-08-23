implement Command;
include "cmd.m";
include "xc.m";
xc : Xc;

main(nil:list of string)
{
	xc = load Xc "xcm.dis";
	print("hello\n");
	xc->init();
	(a, b) := xc->read_input("ex1.dlx");
	print("%d\n", len a);
}
