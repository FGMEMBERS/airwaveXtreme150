var RunningAnimation = func {
#
# ---------------------------------------------------------------------------------
#                        Running Animation                      Status: 24.06.2014
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
  var prone_pos = prone_pos_norm;
    									 #		+0.05 := -25deg prone
  if ( prone_pos_norm < 0.0 ) 
  	  {
  	    if ( prone_pos_norm < -0.05 ) { var prone_pos = -0.05 } # clamp to -0.05 (-25deg)
  	    var prone_pos_deg = prone_pos * 65. / 0.05;
  	  }
  if ( prone_pos_norm >=  0.0 )
  	  {
  	    if ( prone_pos_norm >  0.05 ) { var prone_pos =  0.05}  # clamp to 0.05
  	    var prone_pos_deg = prone_pos * 25. / 0.05;
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

  var altitude   = getprop("position/altitude-agl-ft");
  var brake	 = getprop("controls/gear/brake-parking");
  var u_fps	 = getprop("/fdm/jsbsim/velocities/u-fps");

  if(altitude < 10. ) { 						 

    var groundspeed = getprop("velocities/groundspeed-kt");

    var direction = 1;
    if ( u_fps < 0. ) {var direction = -1; }

    var omega = 0.;
    if      ( groundspeed < .25 ) { var omega = 0; }
    else if ( groundspeed <  5  ) { var omega = 2. * math.pi / 4 * direction; }
    else if ( groundspeed <  20 ) { var omega = 2. * math.pi / 2 * direction; } 	  
    else if ( groundspeed <  40 ) { var omega = 2. * math.pi	 * direction; }
    else			  { var omega = 2. * math.pi * 2 * direction;}

    var legs_pos_run = 30. * math.sin( omega * time );
    var position_dot_sign = math.cos( omega * time );
    
    if ( groundspeed < .25  )
      { var legs_pos_run = 0. ;
  	var position_dot_sign = 0.;
  	var position_lower_leg = 30; }
    else
      { var position_lower_leg = legs_pos_run; }
  }    # end altitude<10
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

  var leg_pos_left  = legs_pos_gear + legs_pos_run * gear_pos_norm;
  var leg_pos_right = legs_pos_gear - legs_pos_run * gear_pos_norm;

  setprop("animation/running_leg_left" ,leg_pos_left);      
  setprop("animation/running_leg_right",leg_pos_right);
    	    
  settimer(RunningAnimation,0);

#
# -------------------------------------------------------------
#             groundhandling/walking         Status: 30.06.2013
# -------------------------------------------------------------
#  
  var wow0 = getprop("gear/gear[0]/wow");
  var wow1 = getprop("gear/gear[1]/wow");
  var wow2 = getprop("gear/gear[2]/wow");
  var wow3 = getprop("gear/gear[3]/wow");
  if ( wow0 or wow1 or wow2 or wow3 ){var on_ground = 1;}
  else                               {var on_ground = 0;}
  setprop("sim/model/airwaveXtreme150/on_ground",on_ground);

  if ( ( on_ground > 0 ) and ( prone_pos_norm < 0.05 ) ){
     Walking();
   }
   else{
      setprop("animation/ahead",0.);
      setprop("animation/side",0.);
   }
#
# -------------------------------------------------------------

}

# Start the running animation delayed to ensure that all necessary variables are initialized
setprop("animation/running_leg",30);	   # 30 -> deflection lower leg is 0
setprop("animation/running_leg_sign",0);

settimer(RunningAnimation,1);



#########################################################################
#########################################################################
#
# -------------------------------------------------------------
#                              walking 
# -------------------------------------------------------------
#
var Walking = func(){
     
  var heading_deg = getprop("orientation/heading-deg"); 

  # --- enforce turning ---
  var pitch_deg   = getprop("orientation/pitch-deg"); 
  var roll_deg    = getprop("orientation/roll-deg");

  var step_deg = 1.;
  
  var turning = getprop("fdm/jsbsim/fcs/turning-moment-norm");

  if(turning != 0.){
    
    if ( turning < 0. ) step_deg = - step_deg ;
    var heading_deg = heading_deg + step_deg ;

    setprop("orientation/heading-deg",heading_deg); 
    setprop("fdm/jsbsim/fcs/turning-moment-norm",0);

    var delta_heading_rad = step_deg * 0.0174532;
    var sin_delta_heading = math.sin( delta_heading_rad );
    var cos_delta_heading = math.cos( delta_heading_rad );

    var pitch = pitch_deg * cos_delta_heading - roll_deg * sin_delta_heading;
    var roll  = pitch_deg * sin_delta_heading + roll_deg * cos_delta_heading;
    setprop("orientation/pitch-deg",pitch);
    setprop("orientation/roll-deg",roll); 
  
  }
  
  # --- enforce walking ---
  var heading_rad = heading_deg * 0.0174532;
  var sin_heading = math.sin( heading_rad );
  var cos_heading = math.cos( heading_rad );

  var step_size = 0.0000005;
  
  var side    = getprop("animation/side");
  var step_side_deg = side * step_size;

  var ahead  = getprop("animation/ahead");
  var step_ahead_deg = ahead * step_size;

  var longitude_deg = getprop("position/longitude-deg");
  var latitude_deg  = getprop("position/latitude-deg"); 

  var latitude_deg  = latitude_deg  + step_ahead_deg * cos_heading - step_side_deg * sin_heading;
  var longitude_deg = longitude_deg + step_ahead_deg * sin_heading + step_side_deg * cos_heading;
         
  setprop("position/longitude-deg",longitude_deg); 
  setprop("position/latitude-deg" ,latitude_deg);

}

