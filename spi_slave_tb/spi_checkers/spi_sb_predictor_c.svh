// Class: spi_sb_predictor_c
//
// read MOSI    (spi slave interface side)   -> predict RX_Byte (controller side)
// read TX_Byte (controller side)             -> predict MISO    (spi slave interface side)
class spi_sb_predictor_c extends uvm_component;
    `uvm_component_utils(spi_sb_predictor_c);

    // Analysis Implementations
    //
    // connected with spi slave monitor to get MOSI and predict RX_Byte
    `uvm_analysis_imp_decl(_spi_m)
    uvm_analysis_imp_spi_m    #(spi_item_c, spi_sb_predictor_c)      spi_slave_imp;
    // connected with spi controller monitor to get TX_Byte and predict MISO
    `uvm_analysis_imp_decl(_spi_cont)
    uvm_analysis_imp_spi_cont #(spi_item_c, spi_sb_predictor_c)      spi_cont_imp;

    // Analysis Ports
    //
    uvm_analysis_port #(spi_item_c) spi_slave_predicted_miso_ap;
    uvm_analysis_port #(spi_item_c) spi_slave_predicted_rxbyte_ap;


    // Variables
    //


    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Class Methods
    //
    // Subscriber Implimintation Functions
    extern   function    void          write_spi_m     (input spi_item_c t);
    extern   function    void          write_spi_cont  (input spi_item_c t);
    // Function: miso_predictor
    extern   function    spi_item_c    miso_predictor  (input spi_item_c t);
    // Function: rxbyte_predictor
    extern   function    spi_item_c    rxbyte_predictor(input spi_item_c t);
    // Function: build_phase
    extern   function    void          build_phase(uvm_phase phase);
    
endclass: spi_sb_predictor_c


// Function: build_phase
function void spi_sb_predictor_c::build_phase(uvm_phase phase);
    spi_slave_imp                  = new("spi_slave_imp",this);
    spi_cont_imp                    = new("spi_cont_imp",this);
    spi_slave_predicted_miso_ap    = new("spi_slave_predicted_miso_ap",this);
    spi_slave_predicted_rxbyte_ap  = new("spi_slave_predicted_rxbyte_ap",this);
endfunction: build_phase


// Function: write_spi_m
function void spi_sb_predictor_c::write_spi_m(input spi_item_c t);
    spi_item_c     exp_tr;
    //-------------------------
    exp_tr = rxbyte_predictor(t);
    spi_slave_predicted_rxbyte_ap.write(exp_tr);
endfunction : write_spi_m


// Function: rxbyte_predictor
// check the value driven on SPI_MOSI which the dut should read and report on RX_Byte
function spi_item_c spi_sb_predictor_c::rxbyte_predictor(input spi_item_c t);
    static bit  [7:0]  predicted_rxbyte;

    spi_item_c    tr;
    tr = spi_item_c::type_id::create("tr");
    //-------------------------
    `uvm_info(get_type_name(), t.sprint(), UVM_HIGH)

    // prediction: RX_Byte should be equal to what was driven on MISO
    predicted_rxbyte = t.SPI_MOSI;
    // copy all sampled inputs & outputs
    tr.copy(t);
    // overwrite the RX_Byte values with the calculated values
    tr.o_RX_Byte = predicted_rxbyte;
    return(tr);
endfunction: rxbyte_predictor


// Function: write_spi_cont
function void spi_sb_predictor_c::write_spi_cont(input spi_item_c t);
    spi_item_c     exp_tr;
    //-------------------------
    exp_tr = miso_predictor(t);
    spi_slave_predicted_miso_ap.write(exp_tr);
endfunction : write_spi_cont


// Function: miso_predictor
// check the value driven on i_TX_Byte which the dut should serialize on SPI_MISO
function spi_item_c spi_sb_predictor_c::miso_predictor(input spi_item_c t);
    static bit  [7:0]  predicted_spi_miso;

    spi_item_c    tr;
    tr = spi_item_c::type_id::create("tr");
    //-------------------------
    `uvm_info(get_type_name(), t.sprint(), UVM_HIGH)

    // prediction: Miso should equal to TX_Byte
    predicted_spi_miso = t.i_TX_Byte;
    // copy all sampled inputs & outputs
    tr.copy(t);
    // overwrite the SPI_MISO values with the calculated values
    tr.SPI_MISO = predicted_spi_miso;
    return(tr);
endfunction: miso_predictor


