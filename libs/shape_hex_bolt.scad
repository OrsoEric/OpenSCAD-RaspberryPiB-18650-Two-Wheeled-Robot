include <shape_cylinder.scad>
include <shape_hexagon.scad>

//M3 HEX = 6+margin

//bolt stacked on top of a hex nut
module shape_hex_bolt
(
	//Bolt
	i_d_bolt = 2,
	i_h_bolt = 20,
	//Hex Head
	i_d_hex = 6,
	i_h_hex = 2,
	//Bolt angular offset, it may be convenient to orient the hex
	i_or = 0,
	//Precision
	i_e_precision = 0.01,
)
{
	union()
	{
		translate
		([
			0,
			0,
			i_h_hex
		])
		shape_cylinder
		(
			i_d = i_d_bolt,
			i_h = i_h_bolt,
			i_e = i_e_precision
		);
		rotate([0,0,i_or])
		shape_hexagon
		(
			i_d = i_d_hex,
			i_h = i_h_hex
		);
	}
}

//shape_hex_bolt();