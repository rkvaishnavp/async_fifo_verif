class rd_driver extends uvm_driver #(rd_tx);
  `uvm_component_utils(rd_driver)

  virtual rd_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual rd_if)::get(this, "", "rd_vif", vif)) begin
      `uvm_fatal(get_type_name(), "Didn't get handle to Virtual Interface rd_if")
    end
  endfunction

  task run_phase(uvm_phase phase);

    vif.rd_en     <= 0;
    vif.rd_clk_en <= 0;

    forever begin
      @(posedge vif.rd_clk);

      seq_item_port.get_next_item(req);

      if (!vif.empty) begin
        vif.rd_en     <= req.rd_en;
        vif.rd_clk_en <= req.clk_en;
      end else begin
        vif.rd_en     <= 0;
        vif.rd_clk_en <= 0;
      end

      @(posedge vif.rd_clk);
      vif.rd_en     <= 0;
      vif.rd_clk_en <= 0;

      seq_item_port.item_done();
    end
  endtask
endclass
