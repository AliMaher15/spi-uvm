// Class: spi_base_vseq_c
//
// Declare the virtual sequencer of the test, through it can run sequences across any agent
class spi_base_vseq_c extends  uvm_sequence#(uvm_sequence_item);

    `uvm_object_utils(spi_base_vseq_c)

    `uvm_declare_p_sequencer(spi_vsequencer_c)

    spi_env_cfg_c      m_cfg;

    int run_seq_count = 16;
  
  
    // Contructor: new
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    // Task: body
    virtual task body();
        m_cfg = p_sequencer.m_cfg ;
        if(m_cfg == null) begin
            `uvm_fatal(get_full_name(), "env_config is null")
        end
    endtask : body


    // Function: seq_set_cfg
    function void seq_set_cfg(spi_base_seq_c seq_);
        seq_.m_cfg = m_cfg;
    endfunction : seq_set_cfg
   
  
  endclass : spi_base_vseq_c