//SHAPE
include <libs/shape_ellypse.scad>
include <libs/shape_rounded_rectangle.scad>


//Model of the Rasperry Pi 3 and 5
include <libs/raspberry_pi_3.scad>
//include <libs/rpi_support.scad>
//Model of the servo
include <libs/hs422-servo.scad>
include <libs/servo_holder.scad>
//Holder for a pivot tennis ball
include <libs/ball_holder.scad>

//Model of the batteries
include <battery-18650.scad>
include <battery-18650-holder-1s1p.scad>


module industrious_resonance
(
	//SHOW ELEMENTS
	i_x_show_rpi = true,
	i_x_show_servo = true,
	i_x_show_battery = false,
	i_x_show_pivot = true,
	//Thickness of the base
	i_t_base = 3.5,
	i_e_precision = 0.01,
)
{

	//BASE parameters<
	t_base = i_t_base;
	e_precision = i_e_precision;

	//------------------------------------------------------------------
	// BASE
	//------------------------------------------------------------------

	c_r_base_major = 90.0;
	c_r_base_minor = 55.0;
	c_kr_rounding = 0.4;

	//------------------------------------------------------------------
	//	PIVOT
	//------------------------------------------------------------------

	//Offset of the pivot wheel
	lo_pivot = -60;
	//This is a number to control anchor between pivot mechanism and its base
	//I can't be bothered to work out the angles with the arcsin to make it work without this parameter
	ho_pivot = 10;
	//Diameter of the hole where I'll stot in the pivot wheel mechanism
	d_pivot_cutout = 60;
	//Diameter of the pivot sphere (a tennis ball I had laying around)
	d_pivot_sphere = 40.0;
	//Clearance under the base
	h_pivot_clearance = d_pivot_sphere / 2 - ho_pivot;

	echo("Pivot ball clearance: ",h_pivot_clearance);

	//------------------------------------------------------------------
	//	WHEELS
	//------------------------------------------------------------------

	//Position of the motors on the base
	l_wheel = 40.0;
	w_wheel = 40.0;
	//Specs of the wheels
	d_wheel = 68.0;
	t_wheel = 8.0;
	//Margin to apply to the wheel hole
	wm_wheel = -1.0;
	tm_wheel = 2.5;
	dm_wheel = -5.0;
	//Parameters to adjust the relative position of wheel and servo
	wo_wheel = gh_hs422_flange / 2;

	//Height of the servo from floor of pillar
	//Wheel radious minus half servo thickness minus base thickness MINUS pivot height from floor clearance
	//
	h_floor_servo = d_wheel / 2 - 10 - t_base - h_pivot_clearance;

	//------------------------------------------------------------------
	//	BATTERY
	//------------------------------------------------------------------

	l_battery = -80;
	w_battery = 38;

	//------------------------------------------------------------------
	//	GEOMETRY
	//------------------------------------------------------------------

	difference()
	{
		union()
		{
			//---------------------------------------------------------------------
			//	BASE
			//---------------------------------------------------------------------

			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = c_r_base_major * 2,
				i_w = c_r_base_minor * 2,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = c_r_base_major * c_kr_rounding,
				//Error by the approximation
				i_n_error = e_precision
			);

			//---------------------------------------------------------------------
			//	BATTERY HOLDER
			//---------------------------------------------------------------------

			translate
			([
				l_battery,
				w_battery,
				t_base
			])
			rotate([0,0,-0])
			holder_18650_1s1p( ix_show_battery = false, ix_show_tab = true );

			translate
			([
				l_battery,
				-w_battery,
				t_base
			])
			rotate([0,0,-0])
			holder_18650_1s1p( ix_show_battery = false, ix_show_tab = true );

			//---------------------------------------------------------------------
			//	SBC
			//---------------------------------------------------------------------

			if (i_x_show_rpi == true)
			{
				translate([65,30,t_base+40])
				rotate([0,0,180])
				raspberry_pi_3();
			}

			//---------------------------------------------------------------------
			//	BATTERY
			//---------------------------------------------------------------------

			if (i_x_show_battery == true)
			{

				for (n_cnt =[0:4-1])
				{
					translate([-20,+(n_cnt-1.5)*gd_18650,t_base])
					battery_18650(ix_sideway = 0,in_invert_poles=false );
				}
			}

			if (i_x_show_servo == true)
			{
				//---------------------------------------------------------------------
				//	SERVO WHEEL
				//---------------------------------------------------------------------

				//Right Wheel
				translate
				([
					l_wheel,
					-w_wheel,
					i_t_base
				])
				rotate([0,0,90])
				servo_holder
				(
					//Height of the servo from floor of pillar
					i_ho_servo = h_floor_servo,
					//Wheel
					i_d_wheel = d_wheel,
					i_t_wheel = t_wheel,
					//Visualize components
					i_x_right = true,
					i_x_show_servo = i_x_show_servo,
					i_x_show_wheel = i_x_show_servo
				);

				//Left Wheel
				translate
				([
					l_wheel,
					+w_wheel,
					i_t_base
				])
				rotate([0,0,-90])
				servo_holder
				(
					//Height of the servo from floor of pillar
					i_ho_servo = h_floor_servo,
					//Wheel
					i_d_wheel = d_wheel,
					i_t_wheel = t_wheel,
					//Visualize components
					i_x_right = false,
					i_x_show_servo = i_x_show_servo,
					i_x_show_wheel = i_x_show_servo
				);


			}

		}
		//Extrude
		union()
		{

			//---------------------------------------------------------------------
			//	SERVO WHEEL HOLE
			//---------------------------------------------------------------------

			//Right Wheel Hole
			translate
			([
				l_wheel,
				-w_wheel - wm_wheel - (t_wheel + tm_wheel) * 0.5,
				0
			])
			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = d_wheel + dm_wheel,
				i_w = t_wheel + tm_wheel,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = 2,
				//Error by the approximation
				i_n_error = i_e_precision
			);

			//Left Wheel Hole
			translate
			([
				l_wheel,
				+w_wheel + wm_wheel + (t_wheel + tm_wheel) * 0.5,
				0
			])
			shape_rounded_rectangle
			(
				//Dimensions of the rectangle
				i_l = d_wheel+dm_wheel,
				i_w = t_wheel+tm_wheel,
				i_h = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = 2,
				//Error by the approximation
				i_n_error = i_e_precision
			);


			//---------------------------------------------------------------------
			//	PIVOT HOLE
			//---------------------------------------------------------------------
			
			//An hole where I'll slot in the pivot wheel
			translate([lo_pivot,0,0])
			cylinder(h=i_t_base,d=d_pivot_cutout, $fn=80);
			

		}
	}

	//---------------------------------------------------------------------
	//	PIVOT
	//---------------------------------------------------------------------

	translate([lo_pivot,0,0])
	ball_holder
	(
		//Ball
		i_d_ball = 40.0,
		i_d_base = d_pivot_cutout,
		//Structural Strength
		i_t_structure = 4.0,
		i_t_hold = 3.0,
		//Height margin of the base
		i_ho_base = ho_pivot,
		//Thickness of the base
		i_t_base = i_t_base,
		//Show ball
		i_x_show_ball = i_x_show_pivot
	);

	//---------------------------------------------------------------------
	//	PIVOT BALL
	//---------------------------------------------------------------------

	if (i_x_show_pivot==true)
	{
		color("#ffffff")
		translate([lo_pivot,0,ho_pivot])
		sphere(d=gd_ball,$fn=100);
	}

	/*
	//RPI Support
	translate([5,-20,t_base+30])
	rpi_support_pillars
	(
		i_d_top = 6,
		i_d_bot = 10,
		i_h_pillar = 20,
		i_h_vertical = 4
	);
	*/

}

industrious_resonance();