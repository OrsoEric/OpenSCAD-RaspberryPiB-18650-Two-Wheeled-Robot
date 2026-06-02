include <libs/polyround.scad>

include <libs/shape_petal.scad>

include <battery-18650.scad>

//Include the geometry for the tab that contact with the battery, and the endcap of the battery holder
include <battery-18650-tabs.scad>

//	2024-06-23
//	Printed but too short for the batteries

//ia_section = controls the strength of the support. 0 is none. 90 comes up to half battery. the more up the more it retains, but the harder it is to insert
//Fixed the shape of the base to be more scalable with wall thickness, now works from 1 to 3
module half_support_18650
(
	ir_inner,
	ir_thickness,
	il_support,
	ia_section
)
{
    aan_points =
	([
        //Origin
        [0,0,0],
        [0,ir_thickness,0],
		[-ir_inner*0.5 -ir_thickness*0.7,ir_thickness,3],
        [-ir_inner*0.6 -ir_thickness*0.9,-0.2*ir_inner,0],
		[-ir_inner*0.3 -ir_thickness*0.4,-0.0*ir_inner,0],
        [-ir_inner*0.5 -ir_thickness*0.7,-0.0*ir_inner,0],
    ]);  

    //Place the base under the battery housing
    translate([0,0,ir_thickness])
    rotate([-90,0,-90])
    //Construct base
    linear_extrude(il_support)
    polygon(polyRound(aan_points,100));

	shape_petal
	(
		i_r_inner = ir_inner,
		i_r_thickness = ir_thickness,
		i_l_length =il_support,
		i_a_angle = ia_section,
		i_e = 0.01
	);
}

if (false)
half_support_18650
(
	ir_inner = (18.4+0.5)/2,
	ir_thickness = 1.0,
	il_support = 20,
	ia_section = 60
);


//Support around a full battery
module full_support_18650
(
	ir_inner,
	ir_thickness,
	il_support,
	ia_section,
)
{
    half_support_18650(ir_inner, ir_thickness, il_support, ia_section);

    //left wing
    translate([il_support,0,0])
    rotate([0,0,180])
    half_support_18650(ir_inner, ir_thickness, il_support, ia_section);
}

//Support around a full battery
module full_support_18650_asymmetric
(
	ir_inner,
	ir_thickness,
	il_support,
	ia_section_right,
	ia_section_left
)
{
    half_support_18650(ir_inner, ir_thickness, il_support, ia_section_right);

    //left wing
    translate([il_support,0,0])
    rotate([0,0,180])
    half_support_18650(ir_inner, ir_thickness, il_support, ia_section_left);
}


//----------------------------------------------------------------------------
//	2S 1P
//----------------------------------------------------------------------------



//----------------------------------------------------------------------------
//	TESTS
//----------------------------------------------------------------------------

///	HOLDER ONE BATTERY 1S 1P

//holder_18650_1s1p();

//holder_18650_1s1p( ix_show_battery = true, ix_show_tab = true );



