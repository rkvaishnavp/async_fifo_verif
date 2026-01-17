class async_fifo_env extends uvm_env;

  `uvm_component_utils(async_fifo_env)

  rd_agent rd_agent_async_fifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_agent_async_fifo = rd_agent::type_id::create("rd_agent_async_fifo", this);
  endfunction
endclass
