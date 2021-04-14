// Interface of LOC
interface loc_if #(
		parameter N = 8
	);
  logic [N-1:0] x;
  logic [$clog2(N):0] y;
  logic [6:0] ssd;
endinterface