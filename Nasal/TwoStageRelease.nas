# ######################################################################################################################
#                                      place winch model and close two-stage release
#                                                 (also emergency release)
# ######################################################################################################################

var setWinchPositionTwoStageRelease = func {

  var open = getprop("sim/hitches/winch/open");
  if ( open ) {
    setprop("sim/hitches/winch/open-toprope", 1);
    setprop("sim/hitches/winch/open-bottomrope", 1);
  }
  else { 
    # emergency release
    setprop("sim/hitches/winch/open-toprope","true");
    setprop("sim/hitches/winch/open-bottomrope","true");
    towing.releaseHitch("winch");
    return;  
  }
    
  var open_toprope = getprop("sim/hitches/winch/open-toprope");
  var open_bottomrope = getprop("sim/hitches/winch/open-bottomrope");

  if ( open_toprope and open_bottomrope ) {
    towing.setWinchPositionAuto();
    setprop("sim/hitches/winch/open-toprope","false");
    setprop("sim/hitches/winch/open-bottomrope","false");
  }

}


# ######################################################################################################################
#                                                     release hitch       
# ######################################################################################################################

var releaseHitch = func {
  
  var open_toprope = getprop("sim/hitches/winch/open-toprope");
  var open_bottomrope = getprop("sim/hitches/winch/open-bottomrope");
  
    #--------------------------------------------------------------------------------
    # 2-stage-release deactivated! 
    var open_toprope = 1;    # Comment this line to activate the 2-stage release
    #--------------------------------------------------------------------------------
  
  if (!open_toprope and !open_bottomrope ) {
    setprop("sim/hitches/winch/open-toprope","true");
    setprop("sim/hitches/winch/tow/length", getprop("sim/hitches/winch/tow/length")+ 2. );
  }
  else if ( open_toprope and !open_bottomrope ) {
    setprop("sim/hitches/winch/open-bottomrope","true");
    towing.releaseHitch("winch");
  }
 
} # End function releaseHitch
