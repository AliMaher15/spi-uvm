// Class: spi_env_cfg_c
//
class spi_env_cfg_c extends uvm_object;

    `uvm_object_utils(spi_env_cfg_c);

    //  Variables
    //
    // rand bit flag = 0;

    
    //  Constraints
    //

    // agents configurations
    spi_slave_agent_cfg_c          m_spi_slave_agent_cfg;
    spi_controller_agent_cfg_c      m_spi_controller_agent_cfg;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: spi_env_cfg_c