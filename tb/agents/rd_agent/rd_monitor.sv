class rd_monitor extends uvm_monitor;

  `uvm_component_utils(rd_monitor)

  virtual rd_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_if)::get(this, "", "rd_vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface must be set for monitor")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.rd_clk);

      // Print when a read ACTUALLY happens
      if (vif.rd_clk_en && vif.rd_en && !vif.empty) begin
        `uvm_info(
            get_type_name(),
            $sformatf(
                "[READ] data=%0d | occ=%0d | empty=%0b | almost_empty=%0b | underflow=%0b | parity_err=%0b",
                vif.rd_data, vif.rd_occupancy, vif.empty, vif.almost_empty, vif.underflow_err,
                vif.parity_err), UVM_NONE)
      end
    end
  endtask

endclass
