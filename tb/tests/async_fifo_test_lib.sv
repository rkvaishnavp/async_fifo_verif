class async_fifo_base_test extends uvm_test;

  `uvm_component_utils(async_fifo_base_test)
  function new(string name = "async_fifo_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class async_fifo_rd_test extends async_fifo_base_test;
endclass
