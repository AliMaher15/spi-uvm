class spi_master_driver_c extends uvm_driver#(spi_item_c);
    
    `uvm_component_utils(spi_master_driver_c)
    
    // Interface and Config handles
    //
	virtual spi_master_intf         vif;
	spi_master_agent_cfg_c          m_cfg;

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

endclass : spi_master_driver_c


//  Function: build_phase
function void spi_master_driver_c::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(spi_master_agent_cfg_c)::get(this, "", "spi_master_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


// Task : reset_phase
task spi_master_driver_c::reset_phase(uvm_phase phase);
    cleanup();
endtask: reset_phase


//  Task: run_phase
task spi_master_driver_c::run_phase(uvm_phase phase);
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
//             i_TX_Byte:   user byte for the master to serialize to slave
//             i_TX_DV:     user data valid for TX_Byte
//             i_SPI_MISO:  slave's serialized byte to master (not driver's responsibility)
task spi_master_driver_c::run_driver();
    forever begin
        seq_item_port.get_next_item(m_item);
        //****************************************************************//
        while (m_item.delay > 0) begin
            @(posedge vif.i_Clk);
            m_item.delay--;
        end
        // User control
        // set i_TX_Byte & i_TX_DV
        @(posedge vif.i_Clk);
        // wait for the master to be ready to recieve a new byte (a blocking if condition)
        wait(vif.o_TX_Ready);
        vif.i_TX_Byte <= m_item.i_TX_Byte;
        vif.i_TX_DV   <= m_item.i_TX_DV;
        @(posedge vif.i_Clk);
        vif.i_TX_DV   <= 0; // data valid is only up for 1 clock cycle
        // finished, next!!
        //****************************************************************//
        seq_item_port.item_done();
    end
endtask : run_driver


// Function: cleanup
function void spi_master_driver_c::cleanup();
    vif.i_TX_Byte    <= '0;
    vif.i_TX_DV      <= 0;
endfunction : cleanup