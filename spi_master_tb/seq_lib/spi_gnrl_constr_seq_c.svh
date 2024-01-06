// Class: spi_gnrl_constr_seq_c
//
// generate a fully random spi_item then add constraints
class spi_gnrl_constr_seq_c extends spi_base_seq_c;
    `uvm_object_utils(spi_gnrl_constr_seq_c);

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
    
endclass: spi_gnrl_constr_seq_c


// Task: body
task spi_gnrl_constr_seq_c::body();
    m_item = spi_item_c::type_id::create("m_item");
    //----------------------------------------------
    //communicate with driver
    start_item(m_item);
    // randomize
    Randomize_spi_item_with_data_constr : assert (m_item.randomize() with {data_to_serialize dist {'h00 := 5, 'hFF := 5};
                                                                           i_TX_Byte         dist {'h00 := 5, 'hFF := 5};});
    finish_item(m_item);
endtask: body