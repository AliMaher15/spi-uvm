// Class: spi_general_seq_c
//
// generate a fully random spi_item
class spi_general_seq_c extends spi_base_seq_c;
    `uvm_object_utils(spi_general_seq_c);

    // Item handle
    spi_item_c       m_item;


    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    // Class Methods
    //
    // Task: body
    extern virtual task body();
    
endclass: spi_general_seq_c


// Task: body
task spi_general_seq_c::body();
    m_item = spi_item_c::type_id::create("m_item");
    //----------------------------------------------
    //communicate with driver
    start_item(m_item);
    // randomize
    Randomize_spi_item_with_no_constr : assert (m_item.randomize() with {});
    finish_item(m_item);
endtask: body