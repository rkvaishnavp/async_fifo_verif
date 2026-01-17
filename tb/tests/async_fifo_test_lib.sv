class async_fifo_base_test extends uvm_test;

  `uvm_component_utils(async_fifo_base_test)

  async_fifo_env env;

  function new(string name = "async_fifo_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);
  endfunction

endclass

class async_fifo_rd_test extends async_fifo_base_test;

  `uvm_component_utils(async_fifo_rd_test)

  function new(string name = "async_fifo_rd_test", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
