include <primitive_pillar.scad>

include <shape_cylinder.scad>
include <shape_hexagon.scad>

//M3 hole = 2.75
//M3 nut = 6.5

module sbc_support_pillars
(
	i_d_top = 6,
	i_d_bot = 10,
	i_h_pillar = 20,
	i_h_vertical = 4,
	//Interaxis between holes
	i_li_sbc = 50,
	i_wi_sbc = 30
)
{
	for (lo_temp = [-i_li_sbc,0])
	{
		for (wo_temp = [-i_wi_sbc/2,i_wi_sbc/2])
		{
			translate([lo_temp,wo_temp,0])
			pillar
			(
				i_d_hole = 2.75,
				i_d_top = i_d_top,
				i_d_base = i_d_bot,
				i_h_slot = 6,
				i_h_pillar = i_h_pillar,
				//Vertical sections
				i_h_vertical = i_h_vertical,
				i_n_resolution = 60,
				//NUT at the base
				i_d_nut = 6.5,
				i_h_nut = 3.0
			);
		}
	}

}

module sbc_bolt
(
	i_d_pillar = 2,
	i_h_pillar = 20,
	i_d_hex = 6,
	i_h_hex = 2,
	//Interaxis between holes
	i_li_sbc = 50,
	i_wi_sbc = 30,
	//Bolt angular offset, it may be convenient to orient the hex
	i_or = 90,
	//Precision
	i_e_precision = 0.1,
)
{
	for (lo_temp = [-i_li_sbc,0])
	{
		for (wo_temp = [-i_wi_sbc/2,i_wi_sbc/2])
		{
			translate
			([
				lo_temp,
				wo_temp,
				0
			])
			shape_cylinder
			(
				i_d = i_d_pillar,
				i_h = i_h_pillar,
				i_e = i_e_precision
			);

			translate
			([
				lo_temp,
				wo_temp,
				0
			])
			rotate([0,0,i_or])
			shape_hexagon
			(
				i_d = i_d_hex,
				i_h = i_h_hex
			);
		}
	}

}

//sbc_support_pillars();

//sbc_bolt();