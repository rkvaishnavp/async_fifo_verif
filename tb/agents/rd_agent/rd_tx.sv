class rd_tx extends uvm_sequence_item;

  rand bit clk_en;
  rand bit rd_en;

  `uvm_object_utils_begin(rd_tx)
    `uvm_field_int(clk_en, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "rd_tx");
    super.new(name);
  endfunction
endclass
