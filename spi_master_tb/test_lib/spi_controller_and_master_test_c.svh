// Class: spi_controller_and_master_test_c
//
// run spi_controller_only_vseq_c    and     spi_master_only_vseq_c
class spi_controller_and_master_test_c extends  spi_base_test_c;
    `uvm_component_utils(spi_controller_and_master_test_c)
    
   // Constructor
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   // Task: run_phase
   extern task run_phase(uvm_phase phase);
  
  endclass : spi_controller_and_master_test_c


// Task: run_phase
task spi_controller_and_master_test_c::run_phase(uvm_phase phase);

  //vseq_class_name              vseq_handle   = seq_class_name     ::type_id       ::create("vseq_handle");
  spi_controller_only_vseq_c     m_spi_cont_vseq = spi_controller_only_vseq_c::type_id::create("m_spi_cont_vseq");
  spi_master_only_vseq_c         m_spi_m_vseq    = spi_master_only_vseq_c    ::type_id::create("m_spi_m_vseq");

  set_seqs(m_spi_cont_vseq);
  set_seqs(m_spi_m_vseq);
    
  phase.raise_objection(this);

  super.run_phase(phase); 
  
    `uvm_info(get_full_name(),"Starting test", UVM_LOW)
     fork
      m_spi_cont_vseq.start(m_spi_env.m_vseqr);  
      m_spi_m_vseq.start(m_spi_env.m_vseqr);
     join
          
    #1000ns;

    `uvm_info(get_full_name(),"Ending test", UVM_LOW)
  
  phase.drop_objection(this);
  
endtask : run_phase