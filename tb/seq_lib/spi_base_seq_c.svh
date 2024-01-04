// Class: spi_base_seq_c
//
class spi_base_seq_c extends  uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(spi_base_seq_c)
  
    spi_env_cfg_c     m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    virtual task body();
      if(m_cfg == null) begin
        `uvm_fatal(get_full_name(), "env_config is null")
      end
    endtask : body
  
  
  endclass : spi_base_seq_c
  
  
  