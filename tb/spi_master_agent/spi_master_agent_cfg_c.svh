class spi_master_agent_cfg_c extends uvm_object;

    // Interface handle
    //
    virtual     spi_master_intf.mon_mp       mon_vif;
    virtual     spi_master_intf.drv_mp       drv_vif;

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

    `uvm_object_utils_begin(spi_master_agent_cfg_c)
    `uvm_object_utils_end
    
endclass : spi_master_agent_cfg_c
