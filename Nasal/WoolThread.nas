# Deflecting wool-thread
# Status: January 9, 2015
#
# 1. deflection due to flow direction
# 2. deflection due to flow strength
# 3. deflection due to gravity

var woolthread = func {

 if( getprop("sim/model/airwaveXtreme150/wool-thread" ) ) {

   var airspeed = getprop("velocities/airspeed-kt");

   var severity1 = (airspeed / 20) * ( rand() - 0.5 ) ;
   var severity2 = (airspeed / 20) * ( rand() - 0.5 ) ;
   		
   #var alpha_aero_deg  = getprop("orientation/alpha-deg");    not initialized at beginning? Doesn't work!
   var alpha_aero_deg  = getprop("fdm/jsbsim/aero/alpha-deg");
   var beta_aero_deg   = getprop("fdm/jsbsim/aero/beta-deg");
   
   # influence of gravity on wool-thread only for low airspeed
   # deflection_gravity:  0:= no deflection due to gravity / 1:= only deflection due to gravity       
   var deflection_aero = airspeed / 10. ; # gravity omitted for airspeed > 10kt / airspeed is always positive

   if( deflection_aero < 1 ) {

     deflection_gravity = 1 - deflection_aero ;

     var nx = getprop("accelerations/pilot/x-accel-fps_sec");
     var ny = getprop("accelerations/pilot/y-accel-fps_sec");
     var nz = getprop("accelerations/pilot/z-accel-fps_sec");
     
     var alpha_gravity_deg = math.atan2(nz,nx) * 180. / math.pi;
     
     var nxz = math.sqrt( nx * nx + nz * nz );
     var beta_gravity_deg = math.atan2(ny,nxz) * 180. / math.pi;

     # -90 < beta_aero < 90 / alpha_aero = alpha_aero + 180 instead of beta_aero > -90 or > +90 !
     # Hence, alpha_gravity has to be adapted to prevent wrong "intermediat"-values for the mixed aero-gravity calculation!
     if      ( alpha_aero_deg >  90. ) { alpha_gravity_deg = - alpha_gravity_deg + 180 ; }
     else if ( alpha_aero_deg < -90. ) { alpha_gravity_deg = - alpha_gravity_deg - 180 ; }

     var alpha_woolthread = (1 - deflection_gravity ) * alpha_aero_deg +
   		            deflection_gravity   * alpha_gravity_deg ;

     var beta_woolthread  = (1 - deflection_gravity ) * beta_aero_deg +
   		            deflection_gravity   * beta_gravity_deg ;
		       
   }
   else {
     var alpha_woolthread = alpha_aero_deg ;
     var beta_woolthread  =  beta_aero_deg ;
   }

   setprop("instrumentation/woolthread/alpha-woolthread-deg", alpha_woolthread );
   setprop("instrumentation/woolthread/beta-woolthread-deg" , beta_woolthread  );

   setprop("instrumentation/woolthread/severity1",severity1);
   setprop("instrumentation/woolthread/severity2",severity2);		   

 }
 
 settimer(woolthread,0);

}

# Start the woolthread ASAP
woolthread();

