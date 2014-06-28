################################################################################################
#
# Set default values
#
################################################################################################

var set_defaults = func (device){

  if(device == "aerotow") {
    setprop("sim/hitches/aerotow/tow/length", 60.);
    setprop("sim/hitches/aerotow/tow/brake-force", 1000.);
    setprop("sim/hitches/aerotow/tow/elastic-constant", 9000.);
    setprop("sim/hitches/aerotow/rope/rope-diameter-mm", 8.);
    # setprop("sim/hitches/aerotow/tow/weight-per-m-kg-m", 0.035);

    setprop("sim/hitches/aerotow/force_name_jsbsim","chest");
    setprop("sim/hitches/winch/force_name_jsbsim","chest");    
  }

  if(device == "winch") {
    setprop("sim/hitches/winch/tow/initial-tow-length-m", 800.);
    setprop("sim/hitches/winch/tow/max-tow-length-m", 1500.);
    setprop("sim/hitches/winch/tow/break-force-N", 1500.);
    setprop("sim/hitches/winch/tow/elastic-constant", 40000.);
    setprop("sim/hitches/winch/rope/rope-diameter-mm", 20.);
    setprop("sim/hitches/winch/tow/weight-per-m-kg-m", 0.01);

    setprop("sim/hitches/winch/winch/initial-tow-length-m", 800.);
    setprop("sim/hitches/winch/winch/max-tow-length-m", 1500.);
    setprop("sim/hitches/winch/winch/max-power-kW", 10.);
    setprop("sim/hitches/winch/winch/max-force-N", 800.);
    setprop("sim/hitches/winch/winch/max-spool-speed-m-s", 20.);
    setprop("sim/hitches/winch/winch/max-unspool-speed-m-s", 20.);
    setprop("sim/hitches/winch/winch/spool-acceleration-m-s-s", 5.);

    setprop("sim/hitches/winch/force_name_jsbsim","belly");    
    setprop("sim/hitches/aerotow/force_name_jsbsim","belly");    
  }
  
  setprop("fdm/jsbsim/external_reactions/belly/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/x", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/y", 0.);
  setprop("fdm/jsbsim/external_reactions/belly/z", 0.);

  setprop("fdm/jsbsim/external_reactions/chest/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/x", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/y", 0.);
  setprop("fdm/jsbsim/external_reactions/chest/z", 0.);

  setprop("fdm/jsbsim/external_reactions/drop/magnitude", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/x", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/y", 0.);
  setprop("fdm/jsbsim/external_reactions/drop/z", 0.);
  
}




