var RunningAnimation = func {
#
# ---------------------------------------------------------------------------------
#                        Running Animation                      Status: 09.06.2012
# ---------------------------------------------------------------------------------
#
# Variables:
# ----------
# running_leg_left/right := entire leg (LegUpper+LegLower+Shoe)
# running_leg            := only lower leg + shoe
#
#
# -------------------------------------------------------------
#                            gear and prone
# -------------------------------------------------------------
#
  var gear_pos_norm   = getprop("gear/gear[1]/position-norm");  	 # gear in-out (0-1)
  var prone_pos_norm  = getprop("controls/flight/elevator-trim");	 # inclination (-0.05 :=  65deg erected
  									 #		+0.05 := -25deg prone
  if ( prone_pos_norm < 0.0 ) 
  	  {
  	    if ( prone_pos_norm < -0.05 ) { var prone_pos_norm = -0.05 } # clamp to -0.05 (-25deg)
  	    var prone_pos_deg = prone_pos_norm * 65. / 0.05;
  	  }
  if ( prone_pos_norm >=  0.0 )
  	  {
  	    if ( prone_pos_norm >  0.05 ) { var prone_pos_norm =  0.05}  # clamp to 0.05
  	    var prone_pos_deg = prone_pos_norm * 25. / 0.05;
  	  }

  var delta_pos_gear_prone_deg  = ( 90. + prone_pos_deg );
  var legs_pos_gear = gear_pos_norm * delta_pos_gear_prone_deg;

#
# -------------------------------------------------------------
#                              running
# -------------------------------------------------------------
#
  var legs_pos_run = 0 ;    #initializing
  var time	   = getprop("sim/time/elapsed-sec");

  if(time > 1){
    var altitude   = getprop("position/altitude-agl-ft");
    var brake      = getprop("controls/gear/brake-parking");
    var u_fps      = getprop("/fdm/jsbsim/velocities/u-fps");

    if(altitude < 10. ) {						   

      var groundspeed = getprop("velocities/groundspeed-kt");

      var direction = 1;
      if ( u_fps < 0. ) {var direction = -1; }

      var omega = 0.;
      if      ( groundspeed < .25 ) { var omega = 0; }
      else if ( groundspeed <  5  ) { var omega = 2. * math.pi / 4 * direction; }
      else if ( groundspeed <  20 ) { var omega = 2. * math.pi / 2 * direction; }	    
      else if ( groundspeed <  40 ) { var omega = 2. * math.pi     * direction; }
      else			    { var omega = 2. * math.pi * 2 * direction;}

      var legs_pos_run = 30. * math.sin( omega * time );
      var position_dot_sign = math.cos( omega * time );
      
      if ( groundspeed < .25  )
        { var legs_pos_run = 0. ;
    	  var position_dot_sign = 0.;
          var position_lower_leg = 30; }
      else
        { var position_lower_leg = legs_pos_run; }
    }	 # end altitude<10
    else # above altitude 10
    { 
    #  var legs_pos_run = 0.; # straight
      var legs_pos_run = 7.5;
      var position_dot_sign = 0.;
    #  var position_lower_leg = 30;  # straight
      var position_lower_leg = 15;
    }
    var position2 = position_lower_leg *  gear_pos_norm + 30 * (  1 - gear_pos_norm ) ; 
    setprop("animation/running_leg",position2);
    setprop("animation/running_leg_sign",position_dot_sign);
  }   # end time>1
  else   # time <1  defaults
  { 
    setprop("animation/running_leg",30);	# 30 -> deflection lower leg is 0
    setprop("animation/running_leg_sign",0);
  }

  var leg_pos_left  = legs_pos_gear + legs_pos_run * gear_pos_norm;
  var leg_pos_right = legs_pos_gear - legs_pos_run * gear_pos_norm;


  setprop("animation/running_leg_left" ,leg_pos_left);      
  setprop("animation/running_leg_right",leg_pos_right);
    	    
  settimer(RunningAnimation,0);
}

# Start the running animation ASAP
RunningAnimation();


