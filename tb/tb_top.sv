
module tb_top;

  import uvm_pkg::*;
  import async_fifo_pkg::*;


  logic rd_clk;
  logic wr_clk;

  always #1 rd_clk = ~rd_clk;
  always #3 wr_clk = ~wr_clk;

  rd_if #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) rd_if (
      .rd_clk(rd_clk)
  );

  wr_if #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) wr_if (
      .wr_clk(wr_clk)
  );

  initial begin
    run_test("");
  end

endmodule
