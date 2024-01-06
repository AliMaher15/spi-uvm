#***************************************************#
# Set the Project Folder Path
#***************************************************#
set PRJ_PATH "D:/Ali/Courses/Verification-Projects/SPI-uvm"

vlog  $PRJ_PATH/spi_master_tb/rst_intf.sv \
$PRJ_PATH/spi_master_tb/spi_global_params_pkg.sv \
$PRJ_PATH/spi_master_tb/spi_item/spi_item_pkg.sv \
$PRJ_PATH/spi_master_tb/spi_master_agent/spi_master_agent_pkg.sv \
$PRJ_PATH/spi_master_tb/spi_master_agent/spi_master_intf.sv \
$PRJ_PATH/spi_master_tb/spi_controller_agent/spi_controller_agent_pkg.sv \
$PRJ_PATH/spi_master_tb/spi_controller_agent/spi_controller_intf.sv \
$PRJ_PATH/spi_master_tb/spi_tb_pkg.sv \
$PRJ_PATH/spi_master_tb/seq_lib/spi_seq_pkg.sv \
$PRJ_PATH/spi_master_tb/test_lib/spi_test_pkg.sv \
$PRJ_PATH/spi_master_tb/spi_tb_top.sv \
+incdir+$PRJ_PATH/spi_master_tb \
+incdir+$PRJ_PATH/spi_master_tb/spi_master_agent/ \
+incdir+$PRJ_PATH/spi_master_tb/spi_controller_agent/ \
+incdir+$PRJ_PATH/spi_master_tb/spi_item/ \
+incdir+$PRJ_PATH/spi_master_tb/seq_lib/ \
+incdir+$PRJ_PATH/spi_master_tb/spi_checkers/ \
+incdir+$PRJ_PATH/spi_master_tb \
+incdir+$PRJ_PATH/spi_master_tb/test_lib/ \
+define+def_spi_CLK_PERIOD=10