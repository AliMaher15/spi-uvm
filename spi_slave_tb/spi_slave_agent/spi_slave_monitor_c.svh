class spi_master_monitor_c extends uvm_monitor;
    
    `uvm_component_utils(spi_master_monitor_c)

    // Interface and Config handles
    //
	  virtual    spi_master_intf.mon_mp      vif;
	  spi_master_agent_cfg_c                 m_cfg;

    // Analysis Ports
    //
    uvm_analysis_port #(spi_item_c) spi_master_mon_inp_ap;
    uvm_analysis_port #(spi_item_c) spi_master_mon_out_ap;


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

endclass : spi_master_monitor_c


// Function: build_phase
function void spi_master_monitor_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(spi_master_agent_cfg_c)::get(this, "", "spi_master_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.mon_vif;
    spi_master_mon_inp_ap = new("spi_master_mon_inp_ap", this);
    spi_master_mon_out_ap = new("spi_master_mon_out_ap", this);
endfunction: build_phase


// Task: run_phase
task spi_master_monitor_c::run_phase(uvm_phase phase);
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
//             i_SPI_MISO:  slave's serialized byte to master   (what is the master driver is serializing)
task spi_master_monitor_c::input_monitor_run();
    forever begin
      spi_item_c    spi_master_inp_item = spi_item_c::type_id::create("spi_master_inp_item");
      spi_master_inp_item.rst_op = 0;

      // from my understanding. in Mode "1", serialized data is sampled at posedge
      // monitor the MISO serialization (LSB first) but then it is flipped in RX_byte
      for (int i=7; i>=0; --i) begin
        @(vif.mon_cb); // block the loop if no transmission
        spi_master_inp_item.SPI_MISO[i] = vif.mon_cb.i_SPI_MISO;
      end
      spi_master_mon_inp_ap.write(spi_master_inp_item);
    end
endtask: input_monitor_run



// Task: output_monitor_run
// outputs are: 
//             o_SPI_MOSI:  master takes i_TX_Byte then serialize it (should be equal to what the controller driver put on i_TX_Byte)
//             o_SPI_Clk:   transmission clock generated by master (IDLE is "LOW" in SPI mode "1")
task spi_master_monitor_c::output_monitor_run();
  forever begin
    spi_item_c      spi_master_out_item = spi_item_c::type_id::create("spi_master_out_item");
    spi_master_out_item.rst_op = 0;

    // monitor the MOSI serialization (MSB first)
    for (int i=7; i>=0; --i) begin
      @(vif.mon_cb);
      spi_master_out_item.SPI_MOSI[i] = vif.mon_cb.o_SPI_MOSI;
    end
    
    spi_master_mon_out_ap.write(spi_master_out_item);
  end
endtask: output_monitor_run


// Function: cleanup
function void spi_master_monitor_c::cleanup();
  // Clear all
  spi_item_c    cleanup_item = spi_item_c::type_id::create("cleanup_item");
  cleanup_item.rst_op = 1;
  spi_master_mon_inp_ap.write(cleanup_item);
  spi_master_mon_out_ap.write(cleanup_item);

endfunction : cleanup