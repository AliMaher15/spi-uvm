// Class: spi_sb_comparator_c
//
// compare:
    // predicted MOSI vs actual MOSI
    // predicted RX_Byte vs actual RX_Byte
class spi_sb_comparator_c extends uvm_component;

    `uvm_component_utils(spi_sb_comparator_c);


    // Analysis Exports
    //
    // actual outputs
    uvm_analysis_export   #(spi_item_c)       axp_rxbyte_out; // controller 
    uvm_analysis_export   #(spi_item_c)       axp_mosi_out;   // master interface
    // predicted outputs
    uvm_analysis_export   #(spi_item_c)       axp_rxbyte_in;  // controller
    uvm_analysis_export   #(spi_item_c)       axp_mosi_in;    // master interface
    
    
    
    // TLM FIFOs
    //
    // fifo to extract MOSI writes one by one
    uvm_tlm_analysis_fifo #(spi_item_c)       mosi_expfifo;
    uvm_tlm_analysis_fifo #(spi_item_c)       mosi_outfifo;
    // fifo to extract RX_Byte writes one by one
    uvm_tlm_analysis_fifo #(spi_item_c)       rxbyte_expfifo;
    uvm_tlm_analysis_fifo #(spi_item_c)       rxbyte_outfifo;

    // Variables
    //
    int VECT_CNT_mosi, PASS_CNT_mosi, ERROR_CNT_mosi;
    int VECT_CNT_rxbyte, PASS_CNT_rxbyte, ERROR_CNT_rxbyte;
    

    // Constructor: new
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    // Class Methods
    //
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    // Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Function: report_phase
    extern function void report_phase(uvm_phase phase); 
    // Task: compare_mosi
    extern task compare_mosi(input spi_item_c exp_mosi  , spi_item_c out_mosi);
    // Task: compare_rxbyte
    extern task compare_rxbyte(input spi_item_c exp_rxbyte, spi_item_c out_rxbyte);
    // Functions: PASS
    extern function void PASS_mosi(); 
    extern function void PASS_rxbyte();
    // Functions: ERROR
    extern function void ERROR_mosi(); 
    extern function void ERROR_rxbyte(); 
    
endclass : spi_sb_comparator_c


// Function: build_phase
function void spi_sb_comparator_c::build_phase(uvm_phase phase);
    axp_mosi_in     = new("axp_mosi_in"    , this);
    axp_mosi_out    = new("axp_mosi_out"   , this); 
    axp_rxbyte_in   = new("axp_rxbyte_in"  , this);
    axp_rxbyte_out  = new("axp_rxbyte_out" , this); 

    mosi_expfifo    = new("mosi_expfifo"   , this); 
    mosi_outfifo    = new("mosi_outfifo"   , this); 
    rxbyte_expfifo  = new("rxbyte_expfifo" , this); 
    rxbyte_outfifo  = new("rxbyte_outfifo" , this); 
endfunction : build_phase


// Function: connect_phase
function void spi_sb_comparator_c::connect_phase(uvm_phase phase); 
    super.connect_phase(phase);
    axp_mosi_in    .connect(mosi_expfifo  .analysis_export); 
    axp_mosi_out   .connect(mosi_outfifo  .analysis_export); 
    axp_rxbyte_in  .connect(rxbyte_expfifo.analysis_export); 
    axp_rxbyte_out .connect(rxbyte_outfifo.analysis_export);
endfunction : connect_phase


// Task: run_phase
task spi_sb_comparator_c::run_phase(uvm_phase phase);
    spi_item_c     exp_mosi, out_mosi;
    spi_item_c     exp_rxbyte, out_rxbyte;
    fork
        compare_mosi  (exp_mosi  , out_mosi);
        compare_rxbyte(exp_rxbyte, out_rxbyte); 
    join
endtask: run_phase


// Task: compare_mosi
task spi_sb_comparator_c::compare_mosi(input spi_item_c exp_mosi  , spi_item_c out_mosi);
    forever begin 
        `uvm_info("sb_comparator run task", "WAITING for expected mosi output", UVM_DEBUG)
        mosi_expfifo.get(exp_mosi); 
        if(exp_mosi.rst_op) continue;
        `uvm_info("sb_comparator run task", "WAITING for actual mosi output"  , UVM_DEBUG)
        mosi_outfifo.get(out_mosi); 
        if(out_mosi.rst_op) continue;
        if (exp_mosi.SPI_MOSI == out_mosi.SPI_MOSI) begin
            PASS_mosi();
            `uvm_info ("PASS ", $sformatf("\nmosi\nActual=%s\nExpected=%s \n",
                                out_mosi.sprint(), 
                                exp_mosi.sprint()), UVM_HIGH)
        end
        else begin 
            ERROR_mosi();
            `uvm_error("ERROR", $sformatf("\nmosi\nActual=%s\nExpected=%s \n",  
                                out_mosi.sprint(),
                                exp_mosi.sprint()))
        end
    end
endtask: compare_mosi


// Task: compare_rxbyte
task spi_sb_comparator_c::compare_rxbyte(input spi_item_c exp_rxbyte, spi_item_c out_rxbyte);
    forever begin 
        `uvm_info("sb_comparator run task", "WAITING for expected rx_byte output", UVM_DEBUG)
        rxbyte_expfifo.get(exp_rxbyte); 
        if(exp_rxbyte.rst_op) continue;
        `uvm_info("sb_comparator run task", "WAITING for actual rx_byte output"  , UVM_DEBUG)
        rxbyte_outfifo.get(out_rxbyte); 
        if(out_rxbyte.rst_op) continue;
        if (exp_rxbyte.o_RX_Byte == out_rxbyte.o_RX_Byte) begin
            PASS_rxbyte();
            `uvm_info ("PASS ", $sformatf("\nrxbyte\nActual=%s\nExpected=%s \n",
                                out_rxbyte.sprint(), 
                                exp_rxbyte.sprint()), UVM_HIGH)
        end
        else begin 
            ERROR_rxbyte();
            `uvm_error("ERROR", $sformatf("\nrxbyte\nActual=%s\nExpected=%s \n",  
                                out_rxbyte.sprint(),
                                exp_rxbyte.sprint()))
        end
    end
endtask: compare_rxbyte


// Function: report_phase
function void spi_sb_comparator_c::report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    if (VECT_CNT_mosi && !ERROR_CNT_mosi) begin
        `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST PASSED - txbyte vs mosi - %0d vectors ran, %0d vectors passed ***\n", 
                                            VECT_CNT_mosi, PASS_CNT_mosi), UVM_LOW) 
    end else begin
        `uvm_info(get_type_name(), $sformatf("\n\n\n*** TEST FAILED - txbyte vs mosi - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                                             VECT_CNT_mosi, PASS_CNT_mosi, ERROR_CNT_mosi), UVM_LOW)
    end

    if (VECT_CNT_rxbyte && !ERROR_CNT_rxbyte) begin
        `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST PASSED - miso vs rxbyte - %0d vectors ran, %0d vectors passed ***\n", 
                                            VECT_CNT_rxbyte, PASS_CNT_rxbyte), UVM_LOW) 
    end else begin
        `uvm_info(get_type_name(), $sformatf("\n\n\n*** TEST FAILED - miso vs rxbyte - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                                             VECT_CNT_rxbyte, PASS_CNT_rxbyte, ERROR_CNT_rxbyte), UVM_LOW)
    end
endfunction: report_phase


// Functions: PASS
function void spi_sb_comparator_c::PASS_mosi(); 
    VECT_CNT_mosi++;
    PASS_CNT_mosi++;
endfunction: PASS_mosi

function void spi_sb_comparator_c::PASS_rxbyte();
    VECT_CNT_rxbyte++;
    PASS_CNT_rxbyte++;
endfunction: PASS_rxbyte



// Functions: ERROR
function void spi_sb_comparator_c::ERROR_mosi();
    VECT_CNT_mosi++;
    ERROR_CNT_mosi++;
endfunction: ERROR_mosi

function void spi_sb_comparator_c::ERROR_rxbyte();
    VECT_CNT_rxbyte++;
    ERROR_CNT_rxbyte++;
endfunction: ERROR_rxbyte
