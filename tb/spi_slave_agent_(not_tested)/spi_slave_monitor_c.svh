class spi_slave_monitor_c extends uvm_monitor;
    
  `uvm_component_utils(spi_slave_monitor_c)

  // Interface and Config handles
  //
  virtual    spi_slave_intf      vif;
  spi_slave_agent_cfg_c          m_cfg;

  // Analysis Ports
  //
  uvm_analysis_port #(spi_item_c) spi_slave_mon_inp_ap;
  uvm_analysis_port #(spi_item_c) spi_slave_mon_out_ap;


  // Variables
  //


  // Counstructor
  function new(string name, uvm_component parent);
      super.new(name,parent);
      spi_slave_mon_inp_ap = new("spi_slave_mon_inp_ap", this);
      spi_slave_mon_out_ap = new("spi_slave_mon_out_ap", this);
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

endclass : spi_slave_monitor_c


// Function: build_phase
function void spi_slave_monitor_c::build_phase(uvm_phase phase);
  // check configuration
  if(!uvm_config_db#(spi_slave_agent_cfg_c)::get(this, "", "spi_slave_agent_cfg", m_cfg))
      `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

  vif = m_cfg.vif;
endfunction: build_phase


// Task: run_phase
task spi_slave_monitor_c::run_phase(uvm_phase phase);
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
//             i_TX_DV:     the TX_Byte is valid and tell the slave to read it
//             i_TX_Byte:   the byte for the slave to serialize over MISO
//             i_SPI_Clk:   generated by master during transmission              (IDLE is "LOW" in SPI mode 1)
//             i_SPI_MOSI:  serialized data from master                          (not currently testing, will edit later)
//             i_SPI_CS_n:  higher logic tells the slave if it is active         (should be always active in this case)
task spi_slave_monitor_c::input_monitor_run();
  forever begin
    spi_item_c    spi_slave_inp_item = spi_item_c::type_id::create("spi_slave_inp_item");
    spi_slave_inp_item.rst_op = 0;

    // if TX_DV is High and master is ready, then it is a usefull input to write
    @(posedge vif.i_Clk);
    if (i_TX_DV && o_TX_Ready) begin
      spi_slave_inp_item.i_TX_Byte = vif.i_TX_Byte;
      spi_slave_mon_inp_ap.write(spi_slave_inp_item);
    end
  end
endtask: input_monitor_run



// Task: output_monitor_run
// outputs are: 
//             o_RX_Byte:   Byte received on MOSI                   (not currently testing, will edit later)
//             o_RX_DV:     if byte recieved from slave is valid    (not currently testing, will edit later)
//             o_SPI_MISO:  slave takes i_TX_Byte then serialize it
task spi_slave_monitor_c::output_monitor_run();
forever begin
  spi_item_c      spi_slave_out_item = spi_item_c::type_id::create("spi_slave_out_item");
  spi_slave_out_item.rst_op = 0;

  // monitor the MISO serialization (LSB first)
  for (int i=0; i<8; ++i) begin
    @(posedge vif.i_SPI_Clk)   // from my understanding, this clock is always low in IDLE unless there is transmission
    spi_slave_out_item.o_SPI_MISO[i] = vif.o_SPI_MISO;
  end
  
  spi_slave_mon_inp_ap.write(spi_slave_out_item);
end
endtask: output_monitor_run


// Function: cleanup
function void spi_slave_monitor_c::cleanup();
// Clear all
spi_item_c    cleanup_item = spi_item_c::type_id::create("cleanup_item");
cleanup_item.rst_op = 1;
spi_slave_mon_inp_ap.write(cleanup_item);
spi_slave_mon_out_ap.write(cleanup_item);

endfunction : cleanup