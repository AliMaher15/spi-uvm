// Class: spi_scoreboard_c
//
// subscribe to actual inputs to dut, connect it to predictor
// subscribe to actual outputs from dut, connect to comparator
// predictor's predicted outputs with comparator
class spi_scoreboard_c extends uvm_scoreboard;

    `uvm_component_utils(spi_scoreboard_c)
  
    // Analysis Exports
    //
    // connected with spi master monitor
    uvm_analysis_export #(spi_item_c)     axp_miso_in;
    uvm_analysis_export #(spi_item_c)     axp_mosi_out;
    // connected with spi controller monitor
    uvm_analysis_export #(spi_item_c)     axp_txbyte_in;
    uvm_analysis_export #(spi_item_c)     axp_rxbyte_out;

    // Predictor and Comparator
    //
    spi_sb_predictor_c             prd;
    spi_sb_comparator_c            cmp;
  
    // Constructor: new
    function new(string name, uvm_component parent);
      super.new( name, parent );
    endfunction 
  

    // Class Methods
    //
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase); 

endclass: spi_scoreboard_c


// Function: build_phase
function void spi_scoreboard_c::build_phase(uvm_phase phase);
    axp_miso_in    = new("axp_miso_in",    this);
    axp_mosi_out   = new("axp_mosi_out",   this); 
    axp_txbyte_in  = new("axp_txbyte_in",  this); 
    axp_rxbyte_out = new("axp_rxbyte_out", this); 
    prd            =  spi_sb_predictor_c ::type_id::create("prd", this);
    cmp            =  spi_sb_comparator_c::type_id::create("cmp", this); 
endfunction: build_phase


// Function: connect_phase
function void spi_scoreboard_c::connect_phase( uvm_phase phase ); 
    // Connect predictor & comparator to respective analysis exports
    axp_miso_in   .connect     (prd.spi_master_imp); 
    axp_mosi_out  .connect     (cmp.axp_mosi_out); 
    axp_txbyte_in .connect     (prd.spi_cont_imp); 
    axp_rxbyte_out.connect     (cmp.axp_rxbyte_out); 
    // Connect predictor to comparator
    prd.spi_master_predicted_mosi_ap  .connect(cmp.axp_mosi_in); 
    prd.spi_master_predicted_rxbyte_ap.connect(cmp.axp_rxbyte_in); 
endfunction: connect_phase