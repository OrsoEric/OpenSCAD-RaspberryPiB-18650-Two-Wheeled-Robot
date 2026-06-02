include <shape_cylinder.scad>

module shape_arch
(
	//Outer dimensions
	i_l=50,
	i_h=100,
	i_w=10,
	//Thickness of the pillar
	i_t=20,
	//thickness of the keystone
	i_h_keystone = 15,
	//precision of circles
	i_e_precision = 0.1,
)
{

	//diameter of the circle of the arch
	d_circle = i_l-i_t*2;

	//height of the center of the circle of the arch
	h_circle = i_h-i_h_keystone-d_circle/2;


	translate([0,-i_w/2,0])
	difference()
	{

		union()
		{
			translate([-i_l/2,0,0])
			cube([i_l,i_w,i_h]);


			
		}
		union()
		{

				//color("red")
			translate([0,0,h_circle])
			rotate([-90,0,0])
			shape_cylinder
			(
				i_d = d_circle,
				i_h = i_w,
				i_e = i_e_precision
			);		

			translate([-i_l/2+i_t,0,0])
			cube([i_l-i_t*2,i_w,h_circle]);


		}
	}


}

if (false)
shape_arch
(
	//Outer dimensions
	i_l=50,
	i_h=100,
	i_w=10,
	//Thickness of the pillar
	i_t=20,
	//thickness of the keystone
	i_h_keystone = 15,
	//precision of circles
	i_e_precision = 0.1,
);