`timescale 1ns/1ps
module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import async_fifo_pkg::*;

  //--------------------------------------------------------------------------
  // Clock generation
  //--------------------------------------------------------------------------
  logic rd_clk = 0;
  logic wr_clk = 0;

  always #5 rd_clk = ~rd_clk;   // 100 MHz read clock
  always #3 wr_clk = ~wr_clk;   // ~166 MHz write clock

  //--------------------------------------------------------------------------
  // Reset generation
  //--------------------------------------------------------------------------
  logic rd_rst_n = 0;
  logic wr_rst_n = 0;

  initial begin
    rd_rst_n = 0;
    wr_rst_n = 0;
    #100;
    @(posedge wr_clk);
    wr_rst_n = 1;
    @(posedge rd_clk);
    rd_rst_n = 1;
  end

  //--------------------------------------------------------------------------
  // Interface instantiation
  //--------------------------------------------------------------------------
  rd_if #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) rd_if_inst (
      .rd_clk(rd_clk)
  );

  wr_if #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) wr_if_inst (
      .wr_clk(wr_clk)
  );

  //--------------------------------------------------------------------------
  // DUT instantiation
  //--------------------------------------------------------------------------
  async_fifo_ultra #(
      .DATA_WIDTH      (DATA_WIDTH),
      .ADDR_WIDTH      (ADDR_WIDTH),
      .SYNC_STAGES     (3),
      .ALMOST_FULL_TH  (4),
      .ALMOST_EMPTY_TH (4),
      .ENABLE_PARITY   (1),
      .ENABLE_STATS    (1)
  ) dut (
      // Write domain
      .wr_clk         (wr_clk),
      .wr_rst_n       (wr_if_inst.wr_rst_n),
      .wr_en          (wr_if_inst.wr_en),
      .wr_clk_en      (wr_if_inst.wr_clk_en),
      .wr_data        (wr_if_inst.wr_data),
      .full           (wr_if_inst.full),
      .almost_full    (wr_if_inst.almost_full),
      .overflow_err   (wr_if_inst.overflow_err),

      // Read domain
      .rd_clk         (rd_clk),
      .rd_rst_n       (rd_if_inst.rd_rst_n),
      .rd_en          (rd_if_inst.rd_en),
      .rd_clk_en      (rd_if_inst.rd_clk_en),
      .rd_data        (rd_if_inst.rd_data),
      .empty          (rd_if_inst.empty),
      .almost_empty   (rd_if_inst.almost_empty),
      .underflow_err  (rd_if_inst.underflow_err),

      // Diagnostics
      .wr_occupancy   (wr_if_inst.wr_occupancy),
      .rd_occupancy   (rd_if_inst.rd_occupancy),
      .parity_err     (rd_if_inst.parity_err)
  );

  //--------------------------------------------------------------------------
  // Connect reset to interfaces
  //--------------------------------------------------------------------------
  assign rd_if_inst.rd_rst_n = rd_rst_n;
  assign wr_if_inst.wr_rst_n = wr_rst_n;

  //--------------------------------------------------------------------------
  // UVM configuration and test start
  //--------------------------------------------------------------------------
  initial begin
    uvm_config_db#(virtual rd_if)::set(null, "*", "rd_vif", rd_if_inst);
    uvm_config_db#(virtual wr_if)::set(null, "*", "wr_vif", wr_if_inst);
    run_test("async_fifo_base_test");
  end

endmodule
