implement Command;
include "cmd.m";
include "xcc.m";
xcc : Xcc;

main(nil:list of string)
{
	xcc = load Xcc "xccm.dis";
	print("hello\n");
	xcc->init();
	(a, b) := xcc->read_input("ex1.dlx");
	print("%d\n", len a);
}
