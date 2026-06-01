include <shape_cylinder.scad>

//flange meant to attach holes to straight surfaces

module shape_flange
(
	i_h_flange = 40,
	i_w_flange = 60,
	i_d_hole = 10,
	i_t_flange = 2,
	i_e_precision = 0.1,
)
{
	translate([0,i_h_flange/2,0])
	difference()
	{
		union()
		{
			linear_extrude(i_t_flange)
			square([i_w_flange,i_h_flange], center=true);
			translate([0,i_h_flange/2,0])
			shape_cylinder
			(
				i_h = i_t_flange,
				i_d = i_w_flange,
				i_e = i_e_precision
			);
		}
		union()
		{
			translate([0,i_h_flange/2,0])
			shape_cylinder
			(
				i_h = i_t_flange,
				i_d = i_d_hole,
				i_e = i_e_precision
			);

		}
	}
}

//shape_flange();