class spi_slave_driver_c extends uvm_driver#(spi_item_c);
    
    `uvm_component_utils(spi_slave_driver_c)
    
    // Interface and Config handles
    //
	virtual    spi_slave_intf.drv_mp         vif;
	spi_slave_agent_cfg_c                  m_cfg;

    // Variables
    //
    // reset event activated by agent
    event           reset_driver;
    // item recieved from sequence
    spi_item_c      m_item;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction


    // Class Methods
    //
    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: run_driver
    extern task run_driver();
    // Function: cleanup
    extern function void cleanup();
    // Task : reset_phase
    extern task reset_phase(uvm_phase phase);

endclass : spi_slave_driver_c


//  Function: build_phase
function void spi_slave_driver_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(spi_slave_agent_cfg_c)::get(this, "", "spi_slave_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.drv_vif;
endfunction: build_phase


// Task : reset_phase
task spi_slave_driver_c::reset_phase(uvm_phase phase);
    cleanup();
endtask: reset_phase


//  Task: run_phase
task spi_slave_driver_c::run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.i_Rst_L);

        fork
            run_driver();
        join_none
        @(reset_driver);
        disable fork;
        cleanup();
    end
endtask: run_phase



// Task: run_driver
// inputs are: 
//             i_SPI_MOSI:  master's serialized byte to slave               (this driver's responsibility to act as the master)
//             o_SPI_Clk:   slave clock generated by master                 (this driver's responsibility to act as the master)
task spi_slave_driver_c::run_driver();
    forever begin
        seq_item_port.get_next_item(m_item);
        //****************************************************************//
        `uvm_info(get_full_name(), $sformatf("\n driver, serialize: %b", m_item.data_to_serialize), UVM_HIGH)
        // set i_SPI_MOSI (MSB first)
        for (int i=7; i>=0; --i) begin
            repeat(2)  @(vif.drv_cb);     // i_CLK is 4x faster that SPI_CLK
            vif.drv_cb.i_SPI_Clk <= ~vif.drv_cb.i_SPI_Clk;
            vif.drv_cb.i_SPI_MOSI <= m_item.data_to_serialize[i];
        end
        // finished, next!!
        //****************************************************************//
        seq_item_port.item_done();
    end
endtask : run_driver


// Function: cleanup
function void spi_slave_driver_c::cleanup();
    vif.drv_cb.i_SPI_MOSI    <= 0;
    vif.drv_cb.i_SPI_Clk     <= 0; // idle = 0, in mode "1"
endfunction : cleanup