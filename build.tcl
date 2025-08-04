# Set project variables
set project_name "bobby_matcher"
set top_module "pattern_matcher"
set part "xc7a100tcsg324-1"

# Create project
create_project $project_name . -part $part

# Add Verilog sources
add_files ./pattern_matcher.v
# Add more sources if needed: add_files ./module1.v ./module2.v ...

# Add constraints file
add_files -fileset constrs_1 ./Arty-A7-100-Master.xdc

# Set top module
set_property top $top_module [current_fileset]

# Run synthesis
launch_runs synth_1
wait_on_run synth_1

# Run implementation
launch_runs impl_1
wait_on_run impl_1

# Generate bitstream
launch_runs write_bitstream -jobs 4
wait_on_run write_bitstream

# Exit Vivado
exit