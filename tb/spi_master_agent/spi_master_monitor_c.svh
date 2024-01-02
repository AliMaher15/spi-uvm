class spi_master_monitor_c extends uvm_monitor;
    
    `uvm_component_param_utils(spi_master_monitor_c)

    // Interface and Config handles
    //
	  virtual    spi_master_intf      vif;
	  spi_master_agent_cfg_c          m_cfg;

    // Analysis Ports
    //
    uvm_analysis_port #(spi_item_c) spi_master_mon_inp_ap;
    uvm_analysis_port #(spi_item_c) spi_master_mon_out_ap;


    // Monitoring Variables
    spi_item_c                      m_item;

    

    // Counstructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
        spi_master_mon_inp_ap = new("spi_master_mon_inp_ap", this);
        spi_master_mon_out_ap = new("spi_master_mon_out_ap", this);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: input_monitor_run
    extern task input_monitor_run();
    // Task: output_monitor_run
    extern task output_monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : spi_master_monitor_c


// Function: build_phase
function void spi_master_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(spi_master_agent_cfg_c)::get(this, "", "spi_master_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


// Task: run_phase
task spi_master_monitor_c::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.areset_n);

      fork
        input_monitor_run();
        output_monitor_run();
      join_none

      @(negedge vif.areset_n);
      disable fork;
      cleanup();
    end   
endtask: run_phase


// Task: monitor_run
task spi_master_monitor_c::monitor_run();
    forever begin
      m_item = axi_item_c::type_id::create("m_item");
      m_item.rst_op = 0;

      
      axi_master_mon_ap.write(m_item);
    end
endtask: monitor_run


// Function: cleanup
function void spi_master_monitor_c::cleanup();
  old_data_in = 0;
  old_send_in = 0;
  old_tready_in = 0;

  m_item = axi_item_c::type_id::create("m_item");

  m_item.rst_op = 1;

  axi_master_mon_ap.write(m_item);

endfunction : cleanup