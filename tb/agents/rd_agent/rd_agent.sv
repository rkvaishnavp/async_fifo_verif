class rd_agent extends uvm_agent;

  `uvm_component_utils(rd_agent);
  rd_driver driver;
  rd_monitor monitor;
  rd_sqr sqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = rd_driver::type_id::create("driver", this);
    monitor = rd_monitor::type_id::create("monitor", this);
    sqr = rd_sqr::type_id::create("sqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass
