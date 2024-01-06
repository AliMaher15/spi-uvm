// Class: spi_env_c
//
class spi_env_c extends uvm_env;

    // register in factory 
    `uvm_component_utils(spi_env_c)

    // Components in hierarchy
    //    
    spi_vsequencer_c              m_vseqr;
    spi_env_cfg_c                 m_cfg;
    spi_slave_agent_c            m_spi_slave_agent;
    spi_controller_agent_c        m_spi_controller_agent;
    spi_scoreboard_c              m_scoreboard;
    spi_coverage_c                m_coverage;
    

    // Constructor: new
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new


    // Class Methods
    //
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase);

endclass : spi_env_c


// Function: build_phase
function void spi_env_c::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(spi_env_cfg_c)::get(this, "", "m_spi_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get env_cfg from database")

    // path configuration to agents
    uvm_config_db#(spi_slave_agent_cfg_c)     ::set(this, "m_spi_slave_agent*"     , "spi_slave_agent_cfg"     , m_cfg.m_spi_slave_agent_cfg);
    uvm_config_db#(spi_controller_agent_cfg_c)::set(this, "m_spi_controller_agent*", "spi_controller_agent_cfg", m_cfg.m_spi_controller_agent_cfg);
    
    // create objects
    m_spi_slave_agent      = spi_slave_agent_c     ::type_id::create("m_spi_slave_agent",this);
    m_spi_controller_agent = spi_controller_agent_c::type_id::create("m_spi_controller_agent",this);
    m_vseqr                = spi_vsequencer_c      ::type_id::create("m_vseqr",this);
    m_scoreboard           = spi_scoreboard_c      ::type_id::create("m_scoreboard",this);
    m_coverage             = spi_coverage_c        ::type_id::create("m_coverage",this);
  
endfunction: build_phase


// Function: connect_phase
function void spi_env_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the agent sequencer
    m_vseqr.m_spi_slave_agent_seqr       = m_spi_slave_agent    .m_seqr;
    m_vseqr.m_spi_controller_agent_seqr  = m_spi_controller_agent.m_seqr;

    // Connect Coverage
    m_spi_slave_agent     .spi_slave_agent_inp_ap     .connect(m_coverage.spi_slave_mon_in_imp);
    m_spi_controller_agent.spi_controller_agent_inp_ap.connect(m_coverage.spi_cont_mon_in_imp);
    
    // Connect Scoreboard
    m_spi_slave_agent    .spi_slave_agent_inp_ap    .connect(m_scoreboard.axp_miso_in);
    m_spi_slave_agent    .spi_slave_agent_out_ap    .connect(m_scoreboard.axp_mosi_out);

    m_spi_controller_agent.spi_controller_agent_inp_ap.connect(m_scoreboard.axp_txbyte_in);
    m_spi_controller_agent.spi_controller_agent_out_ap.connect(m_scoreboard.axp_rxbyte_out);
    
endfunction: connect_phase
