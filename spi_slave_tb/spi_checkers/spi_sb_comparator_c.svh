// Class: spi_sb_comparator_c
//
// compare:
    // predicted MISO vs actual MISO
    // predicted RX_Byte vs actual RX_Byte
class spi_sb_comparator_c extends uvm_component;

    `uvm_component_utils(spi_sb_comparator_c);


    // Analysis Exports
    //
    // actual outputs
    uvm_analysis_export   #(spi_item_c)       axp_rxbyte_out; // controller 
    uvm_analysis_export   #(spi_item_c)       axp_miso_out;   // master interface
    // predicted outputs
    uvm_analysis_export   #(spi_item_c)       axp_rxbyte_in;  // controller
    uvm_analysis_export   #(spi_item_c)       axp_miso_in;    // master interface
    
    
    
    // TLM FIFOs
    //
    // fifo to extract MISO writes one by one
    uvm_tlm_analysis_fifo #(spi_item_c)       miso_expfifo;
    uvm_tlm_analysis_fifo #(spi_item_c)       miso_outfifo;
    // fifo to extract RX_Byte writes one by one
    uvm_tlm_analysis_fifo #(spi_item_c)       rxbyte_expfifo;
    uvm_tlm_analysis_fifo #(spi_item_c)       rxbyte_outfifo;

    // Variables
    //
    int VECT_CNT_miso, PASS_CNT_miso, ERROR_CNT_miso;
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
    // Task: compare_miso
    extern task compare_miso(input spi_item_c exp_miso  , spi_item_c out_miso);
    // Task: compare_rxbyte
    extern task compare_rxbyte(input spi_item_c exp_rxbyte, spi_item_c out_rxbyte);
    // Functions: PASS
    extern function void PASS_miso(); 
    extern function void PASS_rxbyte();
    // Functions: ERROR
    extern function void ERROR_miso(); 
    extern function void ERROR_rxbyte(); 
    
endclass : spi_sb_comparator_c


// Function: build_phase
function void spi_sb_comparator_c::build_phase(uvm_phase phase);
    axp_miso_in     = new("axp_miso_in"    , this);
    axp_miso_out    = new("axp_miso_out"   , this); 
    axp_rxbyte_in   = new("axp_rxbyte_in"  , this);
    axp_rxbyte_out  = new("axp_rxbyte_out" , this); 

    miso_expfifo    = new("miso_expfifo"   , this); 
    miso_outfifo    = new("miso_outfifo"   , this); 
    rxbyte_expfifo  = new("rxbyte_expfifo" , this); 
    rxbyte_outfifo  = new("rxbyte_outfifo" , this); 
endfunction : build_phase


// Function: connect_phase
function void spi_sb_comparator_c::connect_phase(uvm_phase phase); 
    super.connect_phase(phase);
    axp_miso_in    .connect(miso_expfifo  .analysis_export); 
    axp_miso_out   .connect(miso_outfifo  .analysis_export); 
    axp_rxbyte_in  .connect(rxbyte_expfifo.analysis_export); 
    axp_rxbyte_out .connect(rxbyte_outfifo.analysis_export);
endfunction : connect_phase


// Task: run_phase
task spi_sb_comparator_c::run_phase(uvm_phase phase);
    spi_item_c     exp_miso, out_miso;
    spi_item_c     exp_rxbyte, out_rxbyte;
    fork
        compare_miso  (exp_miso  , out_miso);
        compare_rxbyte(exp_rxbyte, out_rxbyte); 
    join
endtask: run_phase


// Task: compare_miso
task spi_sb_comparator_c::compare_miso(input spi_item_c exp_miso  , spi_item_c out_miso);
    forever begin 
        `uvm_info("sb_comparator run task", "WAITING for expected miso output", UVM_DEBUG)
        miso_expfifo.get(exp_miso); 
        if(exp_miso.rst_op) continue;
        `uvm_info("sb_comparator run task", "WAITING for actual miso output"  , UVM_DEBUG)
        miso_outfifo.get(out_miso); 
        if(out_miso.rst_op) continue;
        if (exp_miso.SPI_MISO == out_miso.SPI_MISO) begin
            PASS_miso();
            `uvm_info ("PASS ", $sformatf("\nmiso\nActual=%s\nExpected=%s \n",
                                out_miso.sprint(), 
                                exp_miso.sprint()), UVM_HIGH)
        end
        else begin 
            ERROR_miso();
            `uvm_error("ERROR", $sformatf("\nmiso\nActual=%s\nExpected=%s \n",  
                                out_miso.sprint(),
                                exp_miso.sprint()))
        end
    end
endtask: compare_miso


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
    if (VECT_CNT_miso && !ERROR_CNT_miso) begin
        `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST PASSED - txbyte vs miso - %0d vectors ran, %0d vectors passed ***\n", 
                                            VECT_CNT_miso, PASS_CNT_miso), UVM_LOW) 
    end else begin
        `uvm_info(get_type_name(), $sformatf("\n\n\n*** TEST FAILED - txbyte vs miso - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                                             VECT_CNT_miso, PASS_CNT_miso, ERROR_CNT_miso), UVM_LOW)
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
function void spi_sb_comparator_c::PASS_miso(); 
    VECT_CNT_miso++;
    PASS_CNT_miso++;
endfunction: PASS_miso

function void spi_sb_comparator_c::PASS_rxbyte();
    VECT_CNT_rxbyte++;
    PASS_CNT_rxbyte++;
endfunction: PASS_rxbyte



// Functions: ERROR
function void spi_sb_comparator_c::ERROR_miso();
    VECT_CNT_miso++;
    ERROR_CNT_miso++;
endfunction: ERROR_miso

function void spi_sb_comparator_c::ERROR_rxbyte();
    VECT_CNT_rxbyte++;
    ERROR_CNT_rxbyte++;
endfunction: ERROR_rxbyte
