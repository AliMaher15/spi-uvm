// Class: spi_vsequencer_c
//
// holds handles to all agents' sequencers below in the hierarchy
class spi_vsequencer_c extends uvm_sequencer;

    // register in factory
    `uvm_component_utils(spi_vsequencer_c)

    // contains the following sequencers
    spi_slave_agent_seqr_c            m_spi_slave_agent_seqr;
    spi_controller_agent_seqr_c        m_spi_controller_agent_seqr;
    // env config
    spi_env_cfg_c                 m_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);  
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(spi_env_cfg_c)::get(this, "","m_spi_env_cfg", m_cfg))
       `uvm_fatal(get_full_name(), "Failed to get env_cfg from database")
    endfunction: build_phase
    

endclass : spi_vsequencer_c