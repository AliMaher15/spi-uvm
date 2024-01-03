class spi_controller_agent_cfg_c extends uvm_object;

    // Interface handle
    //
    virtual     spi_controller_intf       vif;

    // Variables
    //
    uvm_active_passive_enum     active = UVM_ACTIVE;
    // bit     has_functional_coverage = 1
    // bit     has_Scoreboard = 1
    

    //Constraints
    //


    //  Constructor
    function new(string name = "");
        super.new(name);
    endfunction: new


    // Class Methods
    //

    `uvm_object_utils_begin(spi_controller_agent_cfg_c)
    `uvm_object_utils_end
    
endclass : spi_controller_agent_cfg_c
