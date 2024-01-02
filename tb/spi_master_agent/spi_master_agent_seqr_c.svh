class spi_master_agent_seqr_c extends uvm_sequencer #(spi_item_c);

    `uvm_component_utils(spi_master_agent_seqr_c)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass : spi_master_agent_seqr_c