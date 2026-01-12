interface wr_if #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 6
) (
    input logic wr_clk
);

  //--------------------------------------------------------------------------
  // Signals
  //--------------------------------------------------------------------------
  logic                  wr_rst_n;
  logic                  wr_en;
  logic                  wr_clk_en;
  logic [DATA_WIDTH-1:0] wr_data;

  logic                  full;
  logic                  almost_full;
  logic                  overflow_err;
  logic [  ADDR_WIDTH:0] wr_occupancy;

  //--------------------------------------------------------------------------
  // Clocking block (for TB / UVM)
  //--------------------------------------------------------------------------
  clocking cb @(posedge wr_clk);
    default input #1step output #1step;

    output wr_en;
    output wr_clk_en;
    output wr_data;
    output wr_rst_n;

    input full;
    input almost_full;
    input overflow_err;
    input wr_occupancy;
  endclocking

  //--------------------------------------------------------------------------
  // Modports
  //--------------------------------------------------------------------------
  modport DUT(
      input wr_clk,
      input wr_rst_n,
      input wr_en,
      input wr_clk_en,
      input wr_data,
      output full,
      output almost_full,
      output overflow_err,
      output wr_occupancy
  );

  modport TB(clocking cb, input wr_clk);

endinterface
