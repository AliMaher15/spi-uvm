#***************************************************#
# Set the Project Folder Path
#***************************************************#
set PRJ_PATH "D:/Ali/Courses/Verification-Projects/SPI-uvm/spi_slave_tb"

vlog  $PRJ_PATH/rst_intf.sv \
$PRJ_PATH/spi_global_params_pkg.sv \
$PRJ_PATH/spi_item/spi_item_pkg.sv \
$PRJ_PATH/spi_slave_agent/spi_slave_agent_pkg.sv \
$PRJ_PATH/spi_slave_agent/spi_slave_intf.sv \
$PRJ_PATH/spi_controller_agent/spi_controller_agent_pkg.sv \
$PRJ_PATH/spi_controller_agent/spi_controller_intf.sv \
$PRJ_PATH/spi_tb_pkg.sv \
$PRJ_PATH/seq_lib/spi_seq_pkg.sv \
$PRJ_PATH/test_lib/spi_test_pkg.sv \
$PRJ_PATH/spi_tb_top.sv \
+incdir+$PRJ_PATH \
+incdir+$PRJ_PATH/spi_slave_agent/ \
+incdir+$PRJ_PATH/spi_controller_agent/ \
+incdir+$PRJ_PATH/spi_item/ \
+incdir+$PRJ_PATH/seq_lib/ \
+incdir+$PRJ_PATH/spi_checkers/ \
+incdir+$PRJ_PATH/test_lib/ \
+define+def_spi_CLK_PERIOD=10