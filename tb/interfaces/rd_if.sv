interface rd_if #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 6
) (
    input logic rd_clk
);

  //--------------------------------------------------------------------------
  // Read-domain control
  //--------------------------------------------------------------------------
  logic                  rd_rst_n;
  logic                  rd_en;
  logic                  rd_clk_en;

  //--------------------------------------------------------------------------
  // Read-domain status / data
  //--------------------------------------------------------------------------
  logic [DATA_WIDTH-1:0] rd_data;
  logic                  empty;
  logic                  almost_empty;
  logic                  underflow_err;
  logic                  parity_err;
  logic [  ADDR_WIDTH:0] rd_occupancy;

  //--------------------------------------------------------------------------
  // Clocking block (verification-friendly)
  //--------------------------------------------------------------------------
  clocking cb @(posedge rd_clk);
    default input #1step output #1step;

    // TB-driven
    output rd_rst_n;
    output rd_en;
    output rd_clk_en;

    // DUT-driven
    input rd_data;
    input empty;
    input almost_empty;
    input underflow_err;
    input parity_err;
    input rd_occupancy;
  endclocking

  //--------------------------------------------------------------------------
  // Modports
  //--------------------------------------------------------------------------
  modport DUT(
      input rd_clk,
      input rd_rst_n,
      input rd_en,
      input rd_clk_en,
      output rd_data,
      output empty,
      output almost_empty,
      output underflow_err,
      output parity_err,
      output rd_occupancy
  );

  modport TB(clocking cb, input rd_clk);

endinterface
