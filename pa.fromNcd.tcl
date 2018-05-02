
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name new -dir "E:/Projects/exp_with_task_2/new/planAhead_run_1" -part xc3s500efg320-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "E:/Projects/exp_with_task_2/new/karat_16.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/Projects/exp_with_task_2/new} }
set_property target_constrs_file "karat_16.ucf" [current_fileset -constrset]
add_files [list {karat_16.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "E:/Projects/exp_with_task_2/new/karat_16.ncd"
if {[catch {read_twx -name results_1 -file "E:/Projects/exp_with_task_2/new/karat_16.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"E:/Projects/exp_with_task_2/new/karat_16.twx\": $eInfo"
}
