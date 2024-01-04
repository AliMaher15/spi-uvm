// Class: spi_controller_only_vseq_c
//
// send stimulus over controller/user interface only
class spi_controller_only_vseq_c extends spi_base_vseq_c ;

  `uvm_object_utils(spi_controller_only_vseq_c)

  // Sequences Handles
  //
  spi_general_seq_c     spi_cont_seq_h;


  // Constructor: new
  function new(string name = "");
    super.new(name);
  endfunction : new


  // Task: body
  extern task body();
  
endclass : spi_controller_only_vseq_c

// Task: body
task spi_controller_only_vseq_c::body();
  // Build and 
  spi_cont_seq_h = spi_general_seq_c::type_id::create("spi_cont_seq_h") ;
  seq_set_cfg(spi_cont_seq_h);
  // start
  super.body();
  fork
    repeat(10) begin
      `uvm_info(get_full_name(), "Executing sequence", UVM_HIGH)
      spi_cont_seq_h.start(p_sequencer.m_spi_controller_agent_seqr);
      `uvm_info(get_full_name(), "Sequence complete", UVM_HIGH)
    end
  join
endtask : body