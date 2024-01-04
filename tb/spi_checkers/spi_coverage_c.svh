// Class: spi_coverage_c
//
// subscribe to SPI Master Monitor    : SPI_MISO
// subscribe to SPI Controller Monitor: i_TX_Byte
class spi_coverage_c extends uvm_component;
    `uvm_component_utils(spi_coverage_c)

    // Analysis Implementations
    //
    `uvm_analysis_imp_decl(_spi_master_mon_in)
    uvm_analysis_imp_spi_master_mon_in #(spi_item_c, spi_coverage_c)     spi_master_mon_in_imp;
    `uvm_analysis_imp_decl(_spi_cont_mon_in)
    uvm_analysis_imp_spi_cont_mon_in   #(spi_item_c, spi_coverage_c)     spi_cont_mon_in_imp;


    spi_item_c   spi_master_item;
    spi_item_c   spi_cont_item;


    covergroup spi_byte_cg;

        user_byte_cp: coverpoint spi_master_item.i_TX_Byte {
            bins all_zeros              = {'h00};
            bins all_ones               = {'hFF};
            bins one_zero_switch        = {8'b10101010, 8'b01010101};
            bins all_ones_to_all_zeros  = ('hFF => 'h00);
            bins all_zeros_to_all_ones  = ('h00 => 'hFF);
            bins back_to_back_all_zeros = ('h00 [*2]);
            bins back_to_back_all_ones  = ('hFF [*2]);
        }

        if_serialized_byte_cp: coverpoint spi_cont_item.SPI_MISO {
            bins all_zeros              = {'h00};
            bins all_ones               = {'hFF};
            bins one_zero_switch        = {8'b10101010, 8'b01010101};
            bins all_ones_to_all_zeros  = ('hFF => 'h00);
            bins all_zeros_to_all_ones  = ('h00 => 'hFF);
            bins back_to_back_all_zeros = ('h00 [*2]);
            bins back_to_back_all_ones  = ('hFF [*2]);
        }
        
    endgroup: spi_byte_cg

    
    // Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
        spi_byte_cg = new();
    endfunction


    // Class Methods
    //
    // Implementations Functions
    extern function void write_spi_master_mon_in(input spi_item_c t);
    extern function void write_spi_cont_mon_in  (input spi_item_c t);
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    


endclass : spi_coverage_c


// Function: build_phase
function void spi_coverage_c::build_phase(uvm_phase phase);
    spi_master_mon_in_imp = new("spi_master_mon_in_imp", this);
    spi_cont_mon_in_imp   = new("spi_cont_mon_in_imp"  , this);
endfunction: build_phase


// Function: write_spi_master_mon_in
function void spi_coverage_c::write_spi_master_mon_in(input spi_item_c t);
    if (!t.rst_op) begin
        spi_master_item = spi_item_c::type_id::create("spi_master_item");
        spi_master_item.copy(t);
        spi_byte_cg.sample();
    end 
endfunction : write_spi_master_mon_in


// Function: write_spi_cont_mon_in
function void spi_coverage_c::write_spi_cont_mon_in(input spi_item_c t);
    if (!t.rst_op) begin
        spi_cont_item = spi_item_c::type_id::create("spi_cont_item");
        spi_cont_item.copy(t);
        spi_byte_cg.sample();
    end
endfunction : write_spi_cont_mon_in