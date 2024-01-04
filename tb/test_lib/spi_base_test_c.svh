// Class: spi_base_test_c
//
class spi_base_test_c extends  uvm_test;
  
    `uvm_component_utils(spi_base_test_c)
  
    // Reset Driver
    rst_driver_c                      m_rst_drv;
    
    // Configurations and main Environment
    //
    // spi master interface
    spi_master_agent_cfg_c            m_spi_master_agent_cfg;
    // spi controller/user interface
    spi_controller_agent_cfg_c        m_spi_controller_agent_cfg;
    // environment
    spi_env_cfg_c                     m_spi_env_cfg;
    spi_env_c                         m_spi_env;
    
  
    // Constructor
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new


    // Class Methods
    //
    // Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
    // Task:     configure_phase
    extern virtual task configure_phase(uvm_phase phase);
    // Function: set_seqs
    extern virtual function void set_seqs(spi_base_vseq_c seq);
    // Function: start_of_simulation_phase
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
 
  
endclass : spi_base_test_c


// Function: build_phase
function void spi_base_test_c::build_phase(uvm_phase phase);
  // Create configuration objects
  m_spi_env_cfg               = spi_env_cfg_c             ::type_id::create("m_spi_env_cfg");
  m_spi_master_agent_cfg      = spi_master_agent_cfg_c    ::type_id::create("m_spi_master_agent_cfg");
  m_spi_controller_agent_cfg  = spi_controller_agent_cfg_c::type_id::create("m_spi_controller_agent_cfg");

  // get interfaces
  if(!uvm_config_db #(virtual spi_master_intf)    ::get(this, "","SPI_MASTER_IF",  m_spi_master_agent_cfg.vif))
  `uvm_fatal(get_full_name(), "Failed to get spi_master_if_c")

  if(!uvm_config_db #(virtual spi_controller_intf)::get(this, "","SPI_CONT_IF"  ,  m_spi_controller_agent_cfg.vif))
  `uvm_fatal(get_full_name(), "Failed to get spi_controller_if")

  // Set configuration variables and randomize if needed
  m_spi_master_agent_cfg    .active  = UVM_ACTIVE;
  m_spi_controller_agent_cfg.active  = UVM_ACTIVE;

  // connect configurations
  m_spi_env_cfg.m_spi_master_agent_cfg     = m_spi_master_agent_cfg;
  m_spi_env_cfg.m_spi_controller_agent_cfg = m_spi_controller_agent_cfg;

  // set environment configuration
  uvm_config_db #(spi_env_cfg_c)::set(this, "*", "m_spi_env_cfg", m_spi_env_cfg);

  // Build the environment
  m_spi_env = spi_env_c::type_id::create("m_spi_env",this);

  // Reset Handling
  m_rst_drv = rst_driver_c::type_id::create("m_rst_drv", this);
  uvm_config_db#(string)::set(this, "m_rst_drv", "intf_name", "rst_i");
  m_rst_drv.randomize();

endfunction : build_phase


// Task: configure_phase
task spi_base_test_c::configure_phase(uvm_phase phase);
  phase.raise_objection(this);
  #(100ns);
  phase.drop_objection(this);
endtask : configure_phase


// Function: set_seqs
// set the environment configuration handle inside virtual sequence to this test's env config handle
function void spi_base_test_c::set_seqs(spi_base_vseq_c seq);
  seq.m_cfg = m_spi_env_cfg;
endfunction


// Function: start_of_simulation_phase
// Print Testbench structure and factory contents
function void spi_base_test_c::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  if (uvm_report_enabled(UVM_MEDIUM)) begin
    this.print();
    factory.print();
  end
endfunction : start_of_simulation_phase