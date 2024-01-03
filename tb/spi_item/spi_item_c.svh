class spi_item_c extends uvm_sequence_item;

    // Group: Variables
    //
    bit rst_op = 0;

    // tx signals (generated by user)
    rand   bit   [7:0]   i_TX_Byte; // [MASTER] byte to serialize on MOSI || [SLAVE] byte to serialize on MISO

    // rx signals (used if master and slave are connected together)
    bit          [7:0]   o_RX_Byte; // [MASTER] byte recieved on MISO || [SLAVE] byte recieved on MOSI

    // for spi interface communication monitoring
    bit   [7:0]   SPI_MOSI;
    bit   [7:0]   SPI_MISO;

    // if I want to test the recieving end and correct serializing in either master or slave
    rand   bit   [7:0]   data_to_serialize;
    

    rand int delay;


    `uvm_object_utils_begin(spi_item_c)
        `uvm_field_int(i_TX_Byte        , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(o_RX_Byte        , UVM_DEFAULT | UVM_DEC)
        `uvm_field_int(o_SPI_MOSI       , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(o_SPI_MISO       , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(data_to_serialize, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(rst_op           , UVM_DEFAULT | UVM_BIN)    
        `uvm_field_int(delay            , UVM_DEFAULT | UVM_DEC)   
    `uvm_object_utils_end

    // Group: Constraints
    //
    //  Constraint: delay_range_cnstr
    extern constraint delay_range_cnstr;
    //  Constraint: TX_RX_DV_probability_cnstr
    extern constraint TX_RX_DV_probability_cnstr;
    

    //  Group: Functions
    //
    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    
endclass: spi_item_c


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/

//  Constraint: delay_range_cnstr
constraint spi_item_c::delay_range_cnstr {
    delay inside {[0:5]};
}

/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

