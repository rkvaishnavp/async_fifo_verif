package async_fifo_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Parameters
  parameter int DATA_WIDTH = 32;
  parameter int ADDR_WIDTH = 6;

  // Transaction classes
  `include "agents/rd_agent/rd_tx.sv"

  // Sequencer typedefs
  typedef uvm_sequencer#(rd_tx) rd_sqr;

  // Component classes
  `include "agents/rd_agent/rd_driver.sv"
  `include "agents/rd_agent/rd_monitor.sv"
  `include "agents/rd_agent/rd_agent.sv"

  // Environment
  `include "env/env.sv"

  // Sequences
  `include "sequences/async_fifo_seq_lib.sv"

  // Tests
  `include "tests/async_fifo_test_lib.sv"

endpackage
