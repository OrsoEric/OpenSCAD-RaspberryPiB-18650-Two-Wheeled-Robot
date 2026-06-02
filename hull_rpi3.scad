//SHAPE
include <libs/shape_ellypse.scad>
include <libs/shape_rounded_rectangle.scad>
include <libs/shape_flange.scad>
include <libs/shape_rounded_rectangle_tub.scad>

include <libs/shape_hex_bolt.scad>

//Model of the Rasperry Pi 3 and 5
include <libs/raspberry_pi_3.scad>
include <libs/sbc_support.scad>
//Model of the servo
include <libs/hs422-servo.scad>
include <libs/servo_holder.scad>
//Holder for a pivot tennis ball
include <libs/ball_holder.scad>

//Model of the batteries
//include <battery-18650.scad>
include <battery-18650-holder-1s1p.scad>
//include <battery-18650-holder-1s2p.scad>


include <raspicam_holder.scad>


//Model of the regulator
include <pcb_regulator.scad>

include <board_at324.scad>



module MOUSE_Multispectral_Observer_Upling_Streaming_Enology
(
	//SHOW ELEMENTS
	i_x_show_rpi = false,
	i_x_show_servo = false,
	i_x_show_battery_tab = false,
	i_x_show_battery = false,
	i_x_show_pivot = false,
	i_x_show_raspicam_holder = false,
	i_x_show_raspicam = false,
	i_x_show_regulator = false,
	//Thickness of the base
	i_t_base = 3.5,
	i_e_precision = 0.01,
)
{
	e_precision = i_e_precision;

	//------------------------------------------------------------------
	// BASE
	//------------------------------------------------------------------

	t_base = i_t_base;
	c_r_base_major = 100.0;
	c_r_base_minor = 55.0;
	c_kr_rounding = 0.4;
	//Height of the Tub
	h_tub = 30;


	//------------------------------------------------------------------
	//	PIVOT
	//------------------------------------------------------------------

	//Offset of the pivot wheel
	lo_pivot = -70;
	//This is a number to control anchor between pivot mechanism and its base
	//I can't be bothered to work out the angles with the arcsin to make it work without this parameter
	ho_pivot = 10;
	//Diameter of the hole where I'll stot in the pivot wheel mechanism
	d_pivot_cutout = 60;
	//Diameter of the pivot sphere (a tennis ball I had laying around)
	d_pivot_sphere = 40.0;
	//Clearance under the base
	h_pivot_clearance = d_pivot_sphere / 2 - ho_pivot;
	//Height from base to top of pivot
	h_pivot_top = 32.7;

	echo("Pivot ball clearance: ",h_pivot_clearance);

	//------------------------------------------------------------------
	//	WHEELS
	//------------------------------------------------------------------

	//Position of the motors on the base
	l_wheel = 45.0;
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
	//	SBC
	//------------------------------------------------------------------

	//SBC offset position
	lo_sbc = 82;
	wo_sbc = 0;
	to_sbc = 33;

	//Holes for SBC bolts
	d_sbc_bolt = 2.5 + 0.6;
	d_sbc_bolt_nut = 5.0 + 0.9;

	//------------------------------------------------------------------
	//	BATTERY
	//------------------------------------------------------------------

	lo_battery = -75;
	wo_battery = 37;


	//------------------------------------------------------------------
	//	RASPCIAM
	//------------------------------------------------------------------

	l_raspicam_bolt = 26;
	d_raspicam_bolt = 3.0+0.5;
	d_raspicam_hex = 6.0+0.9;

	g_wo_raspicam_flap_hole = 34.0;

	//------------------------------------------------------------------
	//	PCB REGULATOR
	//------------------------------------------------------------------

	//Size
	l_regulator = 55;
	w_regulator = 30;
	h_regulator = 15;
	//Holes
	li_regulator_hole = 50.0;
	wi_regulator_hole = 25.0;
	//Offset
	lo_regulator = 12;
	wo_regulator = 0;
	ho_regulator = 10;
	//Regulator Bolt
	d_regulator_hole = 3.0+0.6;
	d_regulator_hex_hole = 6.0+0.9;

	//------------------------------------------------------------------
	//	AT324 CONTROLLER
	//------------------------------------------------------------------

	lo_at324 = -50;
	wo_at324 = 0;
	ho_at324 = 40;


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

			//if(false)
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

			if(false)
			color("#888888")
			shape_rounded_rectangle_tub
			(
				//Dimensions of the rectangle
				i_l = c_r_base_major * 2,
				i_w = c_r_base_minor * 2,
				i_h = h_tub,
				i_t_base = i_t_base,
				i_t_wall = i_t_base,
				//Rounding of the corners in the XY direction
				i_r_rounding = c_r_base_major * c_kr_rounding,
				//Error by the approximation
				i_e_precision = i_e_precision
			);

			//---------------------------------------------------------------------
			//	BATTERY HOLDER
			//---------------------------------------------------------------------

			translate
			([
				lo_battery,
				wo_battery,
				t_base
			])
			//rotate([0,0,-180])
			holder_18650_1s1p
			(
				ix_show_battery = i_x_show_battery,
				ix_show_tab = i_x_show_battery_tab,
				ix_battery_invert = false,
			);

			translate
			([
				lo_battery,
				-wo_battery,
				t_base
			])
			rotate([0,0,-0])
			holder_18650_1s1p
			(
				ix_show_battery = i_x_show_battery,
				ix_show_tab = i_x_show_battery_tab,
				ix_battery_invert = true,
			);

			//---------------------------------------------------------------------
			//	SBC
			//---------------------------------------------------------------------

			if (i_x_show_rpi == true)
			{
				translate
				([
					lo_sbc,
					wo_sbc+gw_pi3/2,
					t_base+to_sbc
				])
				rotate([0,0,180])
				raspberry_pi_3();
			}

			//---------------------------------------------------------------------
			//	SBC PILLARS
			//---------------------------------------------------------------------

			translate
			([
				lo_sbc-glm_pi3_hole,
				0,
				0
			])
			sbc_support_pillars
			(
				i_d_top = 6,
				i_d_bot = 8,
				i_h_pillar = t_base+to_sbc,
				i_h_vertical = 4,
				//Interaxis between holes
				i_li_sbc = gli_pi3_hole,
				i_wi_sbc = gwi_pi3_hole
			);

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

			//---------------------------------------------------------------------
			//	RASPICAM
			//---------------------------------------------------------------------

			if (i_x_show_raspicam_holder == true)
			//Move forward
			translate
			([
				c_r_base_major-4,
				0,
				gn_rpicam_height/2+t_base+0.5
			])
			//Turn upward
			rotate([0,90,0])
			//Invert cable direction
			rotate([0,0,180])
			color("gray")
			rpi_holder
			(
				i_r_screw_holes = d_raspicam_bolt,
				i_wo_flap_hole = g_wo_raspicam_flap_hole,
				i_x_flaps = true,
				i_x_raspicam = i_x_show_raspicam,
			);

			//---------------------------------------------------------------------
			//	PCB REGULATOR
			//---------------------------------------------------------------------

			if (i_x_show_regulator == true)
			translate
			([
				lo_regulator,
				wo_regulator,
				t_base+ho_regulator
			])
			shape_pcb
			(
				//Size
				i_l = l_regulator,
				i_w = w_regulator,
				i_h = h_regulator,
				//Hole
				i_d = 3.0 + 0.5,
				i_li = li_regulator_hole,
				i_wi = wi_regulator_hole,
			);

			//---------------------------------------------------------------------
			//	REGULATOR PILLARS
			//---------------------------------------------------------------------

			translate
			([
				lo_regulator,
				wo_regulator,
				0
			])
			sbc_support_pillars
			(
				i_d_top = 6,
				i_d_bot = 7,
				i_h_pillar = t_base+ho_regulator,
				i_h_vertical = 4,
				//Interaxis between holes
				i_li_sbc = li_regulator_hole,
				i_wi_sbc = wi_regulator_hole
			);

			//---------------------------------------------------------------------
			//	CONTROLLER
			//---------------------------------------------------------------------

			translate
			([
				lo_at324,
				wo_at324,
				ho_at324
			])
			rotate([0,0,180])
			at324_board();

			//---------------------------------------------------------------------
			//	SWITCH FLANGE
			//---------------------------------------------------------------------
			// meant for a power switch

			translate
			([
				lo_pivot-4/2,
				0,
				t_base+h_pivot_top
			])
			//Bring it up and facing X
			rotate([90,0,90])
			shape_flange
			(
				i_h_flange = 8,
				i_w_flange = 12,
				i_d_hole = 6.0+0.8,
				i_t_flange = 4,
				i_e_precision = 0.01,
			);



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
			
			//---------------------------------------------------------------------
			// SBC BOLT HOLE
			//---------------------------------------------------------------------

			translate
			([
				lo_sbc-glm_pi3_hole,
				0,
				0
			])
			sbc_bolt
			(
				i_d_pillar = d_sbc_bolt,
				i_h_pillar = t_base+to_sbc,
				i_d_hex = d_sbc_bolt_nut,
				i_h_hex = 2,
				//Interaxis between holes
				i_li_sbc = gli_pi3_hole,
				i_wi_sbc = gwi_pi3_hole,
			);


			//---------------------------------------------------------------------
			// REGULATOR HOLE
			//---------------------------------------------------------------------

			translate
			([
				lo_regulator,
				wo_regulator,
				0
			])
			sbc_bolt
			(
				i_d_pillar = d_regulator_hole,
				i_h_pillar = t_base+to_sbc,
				i_d_hex = d_regulator_hex_hole,
				i_h_hex = 2,
				//Interaxis between holes
				i_li_sbc = li_regulator_hole,
				i_wi_sbc = wi_regulator_hole,
			);
 
			//---------------------------------------------------------------------
			//	RASPICAM BOLTS
			//---------------------------------------------------------------------

			//if (false)
			for (wo=[g_wo_raspicam_flap_hole/2,-g_wo_raspicam_flap_hole/2])
			{
				translate
				([
					c_r_base_major-l_raspicam_bolt,
					wo,
					t_base+gn_rpicam_height/2+0.5
				])
				rotate([0,90,0])
				shape_hex_bolt
				(
					//Bolt
					i_d_bolt = d_raspicam_bolt,
					i_h_bolt = l_raspicam_bolt,
					//Hex Head
					i_d_hex = d_raspicam_hex,
					i_h_hex = 4,
					//Precision
					i_e_precision = 0.01,
				);
			}

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

	//---------------------------------------------------------------------
	//	RASPICAM HOLDER PRINT
	//---------------------------------------------------------------------

	translate([c_r_base_major+50,0,0])
	rpi_holder
	(
		i_r_screw_holes = d_raspicam_bolt,
		i_wo_flap_hole = g_wo_raspicam_flap_hole,
		i_x_flaps = true,
		i_x_raspicam = i_x_show_raspicam,
	);


}

if(false)
MOUSE_Multispectral_Observer_Upling_Streaming_Enology
(
	//SHOW ELEMENTS
	i_x_show_rpi = false,
	i_x_show_servo = false,
	i_x_show_battery_tab = false,
	i_x_show_battery = false,
	i_x_show_pivot = false,
	i_x_show_raspicam_holder = false,
	i_x_show_raspicam = false,
	i_x_show_regulator = false,
);

//if(false)
MOUSE_Multispectral_Observer_Upling_Streaming_Enology
(
	//SHOW ELEMENTS
	i_x_show_rpi = true,
	i_x_show_servo = true,
	i_x_show_battery_tab = true,
	i_x_show_battery = true,
	i_x_show_pivot = true,
	i_x_show_raspicam_holder = true,
	i_x_show_raspicam = true,
	i_x_show_regulator = true,
);
