// Class: spi_master_only_vseq_c
//
// send stimulus over spi master interface only
class spi_master_only_vseq_c extends spi_base_vseq_c ;

  `uvm_object_utils(spi_master_only_vseq_c)

  // Sequences Handles
  //
  spi_general_seq_c         spi_mast_seq_h;
  spi_gnrl_constr_seq_c     spi_mast_contr_seq_h;


  // Constructor: new
  function new(string name = "");
    super.new(name);
  endfunction : new


  // Task: body
  extern task body();
  
endclass : spi_master_only_vseq_c

// Task: body
task spi_master_only_vseq_c::body();
  // Build
  spi_mast_seq_h = spi_general_seq_c::type_id::create("spi_mast_seq_h") ;
  seq_set_cfg(spi_mast_seq_h);
  spi_mast_contr_seq_h = spi_gnrl_constr_seq_c::type_id::create("spi_mast_contr_seq_h") ;
  seq_set_cfg(spi_mast_contr_seq_h);
  // start
  super.body();
    repeat(run_seq_count) begin
      spi_mast_seq_h.start(p_sequencer.m_spi_master_agent_seqr);
      spi_mast_contr_seq_h.start(p_sequencer.m_spi_master_agent_seqr);
    end
endtask : body