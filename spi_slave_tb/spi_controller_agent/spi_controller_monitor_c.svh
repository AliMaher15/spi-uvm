class spi_controller_monitor_c extends uvm_monitor;
    
    `uvm_component_utils(spi_controller_monitor_c)

    // Interface and Config handles
    //
	  virtual    spi_controller_intf.mon_mp      vif;
	  spi_controller_agent_cfg_c                 m_cfg;

    // Analysis Ports
    //
    uvm_analysis_port #(spi_item_c) spi_controller_mon_inp_ap;
    uvm_analysis_port #(spi_item_c) spi_controller_mon_out_ap;


    // Variables
    //


    // Counstructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction


    // Class Methods
    //
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

endclass : spi_controller_monitor_c


// Function: build_phase
function void spi_controller_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(spi_controller_agent_cfg_c)::get(this, "", "spi_controller_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.mon_vif;
    spi_controller_mon_inp_ap = new("spi_controller_mon_inp_ap", this);
    spi_controller_mon_out_ap = new("spi_controller_mon_out_ap", this);
endfunction: build_phase


// Task: run_phase
task spi_controller_monitor_c::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.i_Rst_L);

      fork
        input_monitor_run();
        output_monitor_run();
      join_none

      @(negedge vif.i_Rst_L);
      disable fork;
      cleanup();
    end   
endtask: run_phase


// Task: input_monitor_run
// inputs are: 
//             i_TX_Byte:   user byte for the slave to serialize to master
//             i_TX_DV:     user data valid for TX_Byte
task spi_controller_monitor_c::input_monitor_run();
    forever begin
      // if TX_DV is High, then it is a usefull input to write
      @(vif.mon_cb);
      if (vif.mon_cb.i_TX_DV) begin
        spi_item_c    spi_controller_inp_item = spi_item_c::type_id::create("spi_controller_inp_item");
        spi_controller_inp_item.rst_op = 0;
        spi_controller_inp_item.i_TX_Byte = vif.mon_cb.i_TX_Byte;
        spi_controller_mon_inp_ap.write(spi_controller_inp_item);
      end
    end
endtask: input_monitor_run



// Task: output_monitor_run
// outputs are: 
//             o_RX_Byte:   master's completed byte to slave
//             o_RX_DV:     if byte recieved from master is valid
task spi_controller_monitor_c::output_monitor_run();
  forever begin
    // don't write any new transaction unless RX_DV pulse is high
    @(vif.mon_cb);
    if (vif.mon_cb.o_RX_DV) begin
      spi_item_c      spi_controller_out_item = spi_item_c::type_id::create("spi_controller_out_item");
      spi_controller_out_item.rst_op = 0;
      spi_controller_out_item.o_RX_Byte = vif.mon_cb.o_RX_Byte;
      spi_controller_mon_out_ap.write(spi_controller_out_item);
    end 
  end
endtask: output_monitor_run


// Function: cleanup
function void spi_controller_monitor_c::cleanup();
  // Clear all
  spi_item_c    cleanup_item = spi_item_c::type_id::create("cleanup_item");
  cleanup_item.rst_op = 1;
  spi_controller_mon_inp_ap.write(cleanup_item);
  spi_controller_mon_out_ap.write(cleanup_item);

endfunction : cleanup