// Class: spi_master_agent_c
//
class spi_master_agent_c extends uvm_agent;

    `uvm_component_utils(spi_master_agent_c)

    // Agent Components
    //
    spi_master_agent_cfg_c                      m_cfg;
    spi_master_driver_c                         m_driver;
    spi_master_monitor_c                        m_monitor;
    spi_master_agent_seqr_c                     m_seqr;

    // Agent Analysis Ports
    //
    uvm_analysis_port #(spi_item_c)             spi_master_agent_inp_ap;
    uvm_analysis_port #(spi_item_c)             spi_master_agent_out_ap;

    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    //
    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    //  Task: pre_reset_phase
    extern virtual task pre_reset_phase(uvm_phase phase);
    
endclass : spi_master_agent_c


//  Task: pre_reset_phase
task spi_master_agent_c::pre_reset_phase(uvm_phase phase);
    if (m_seqr && m_driver) begin
        m_seqr.stop_sequences();
        ->m_driver.reset_driver;
    end
endtask : pre_reset_phase


//  Function: build_phase
function void spi_master_agent_c::build_phase(uvm_phase phase);
    // get configuration
    if(!uvm_config_db#(spi_master_agent_cfg_c)::get(this, "", "spi_master_agent_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    // build monitor
    m_monitor       = spi_master_monitor_c          ::type_id::create("m_monitor",this);
    m_monitor.m_cfg = m_cfg;

    // build driver and sequencer if required
    if (m_cfg.active == UVM_ACTIVE) begin
        m_seqr         = spi_master_agent_seqr_c    ::type_id::create("m_seqr", this);
        m_driver       = spi_master_driver_c        ::type_id::create("m_driver",this);
        m_driver.m_cfg = m_cfg;
    end
    
    spi_master_agent_inp_ap  = new("spi_master_agent_inp_ap", this);
    spi_master_agent_out_ap  = new("spi_master_agent_out_ap", this);
endfunction: build_phase


//  Function: connect_phase
function void spi_master_agent_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor analysis ports with agent's analysis ports
    m_monitor.spi_master_mon_inp_ap.connect(spi_master_agent_inp_ap);
    m_monitor.spi_master_mon_out_ap.connect(spi_master_agent_out_ap);

    // Connect driver and sequencer if required
    if (m_cfg.active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_seqr.seq_item_export);
    end
    
endfunction: connect_phase
