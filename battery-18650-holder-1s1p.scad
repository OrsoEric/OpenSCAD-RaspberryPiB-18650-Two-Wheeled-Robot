include <battery-18650-holder.scad>


//Instance holder for a signle 18650 battery
module holder_18650_1s1p
(
	//	BATTERY
	//Diameter of the 18650 battery plus tollerance
	id_18650 = 18.4+0.5,
	//Length of the 18650 battery from base to button
	il_18650 = 71.0,

	//	TAB SPRING/BUTTON
	//Dimensions of the tab plate, plus tollerance
	il_tab = 11.0 +0.5,
	iw_tab = 11.0 +0.5,
	//Thickness of plate slot
	it_tab = 1.25,
	//Size of the button of the tab
	it_tab_button_positive = 1.5,
	//Length of the tab spring, uncompressed
	il_tab_spring_unloaded = 8.0,
	//Length of the tab spring, fully compressed
	il_tab_spring_loaded = 3.0,
	//How much to compress the spring 0 = unloaded, 1 = loaded
	ilk_tab_spring_compression = 0.75,
	//Rails
	iw_tab_rail = 1.75,

	//	STRUCTURE
	//Thickness of the Holder walls
	it_wall = 2.0,
	//Length factor of the wings 10 means 1/10 of length. 5 mean 1/5 of length
	ilk_wing = 6,

	//Angle of the cradle where the battery rests
	ia_cradle = 90,
	//Angle of the wings keeping the battery in place
	ia_wing = 110,
	
	//Thickness of the cap plus rails
	it_cap = 4.0,
	//thickness of the cap back
	it_cap_back = 2.0,

	//	WIRE
	//Lentgh of the wire slot
	il_slot_wire = 6,
	//Width of the wire slot
	iw_slot_wire = 5,

	//	SHOW EXTRA ELEMENTS
	//Show the battery model
	ix_show_battery = false,
	//Show battery tab spring
	ix_show_tab = false,

	ix_battery_invert = false,
)
{
    nl_base = 50;

	//Compute the spring compression length when battery is placed
	il_tab_spring = il_tab_spring_loaded + (il_tab_spring_unloaded -il_tab_spring_loaded)*(1-ilk_tab_spring_compression);
	
	echo("Spring loading",il_tab_spring);
	//Total length of the battery holder. account for the full stack
	l_total = il_18650 + it_cap_back + it_tab_button_positive + il_tab_spring + it_cap_back;

    //battery
    if (ix_show_battery == true)
    {
        //translate([(l_total-il_18650)/2,0,it_wall])
		translate([it_cap_back+it_tab_button_positive,0,it_wall])
        battery_18650
		(
			// Barrel Dimensions
			i_l_18650 = il_18650,
			i_d_18650 = id_18650-0.5,
			ix_sideway = 1,
			in_invert_poles = ix_battery_invert
		);
    }
    
    //I use two sets of wings
    //short wings to retain the battery aligned
    //Tall wings to clip the battery in place

	difference()
	{
		union()
		{
			//Retaining wing butt
			color("red")
			full_support_18650
			(
				id_18650 / 2,
				it_wall,
				l_total / ilk_wing,
				ia_wing
			);

			//Retaining wing front
			color("red")
			translate([l_total *(1 -1/ilk_wing),0,0])
			full_support_18650
			(
				id_18650 / 2,
				it_wall,
				l_total / ilk_wing,
				ia_wing
			);

			//Retaining wing center
			if (false)
			color("red")
			translate([l_total *(2.5/6),0,0])
			full_support_18650
			(
				id_18650 / 2,
				it_wall,
				l_total / 6,
				ia_wing
			);

			//Support wing
			color("red")
			full_support_18650
			(
				id_18650/2,
				it_wall,
				l_total,
				ia_cradle
			);

			//POSITIVE TAB BUTTON 
			translate([0,0,it_wall])
			battery_18650_contact_holder
			(
				//Size of the cylindrical endcap of the holder
				id_18650_cap = id_18650,
				it_18650_cap = it_cap,
				//Thickness of the material behind the cap
				it_cap_back = it_cap_back,
				//Size of the backplate of the tab with spring, this should include the tollerance
				il_tab = il_tab,
				iw_tab = iw_tab,
				//Size of the spring or button
				it_tab_spring = it_tab_button_positive,
				//Size of the rails where the tab slots in. This should leave space for the spring itself
				iw_tab_rail = iw_tab_rail,
				//Thickness of the plate of the tab with spring, this should include the tollerance
				//There are two tiny inserts to lock the plate and need to slide in
				it_tab = it_tab,
				//Slot carved in the back to expose the plate for soldering
				il_slot_wire = il_slot_wire,
				iw_slot_wire = iw_slot_wire,
				//Show the model of the tab spring
				ib_show_tab = ix_show_tab,
				//Precision of the circle
				ie_error = 0.01
			);

			//NEGATIVE TABSPRING
			translate([l_total,0,it_wall])
			rotate([0,0,180])
			battery_18650_contact_holder
			(
				//Size of the cylindrical endcap of the holder
				id_18650_cap = id_18650,
				it_18650_cap = it_cap,
				//Thickness of the material behind the cap
				it_cap_back = it_cap_back,
				//Size of the backplate of the tab with spring, this should include the tollerance
				il_tab = il_tab,
				iw_tab = iw_tab,
				//Size of the spring or button
				it_tab_spring = il_tab_spring_unloaded,
				//Size of the rails where the tab slots in. This should leave space for the spring itself
				iw_tab_rail = iw_tab_rail,
				//Thickness of the plate of the tab with spring, this should include the tollerance
				//There are two tiny inserts to lock the plate and need to slide in
				it_tab = it_tab,
				//Slot carved in the back to expose the plate for soldering
				il_slot_wire = 5.5,
				iw_slot_wire = iw_slot_wire,
				//Show the model of the tab spring
				ib_show_tab = ix_show_tab,
				//Precision of the circle
				ie_error = 0.01
			);
		}	//End Sum

		union()
		{
			//FRONT
			//Drill from the back space to solder the wire
			translate([0,0,it_wall*1.5/2])
			rotate([0,-90,180])
			linear_extrude(it_cap_back)
			square([it_wall*1.5,iw_slot_wire],center=true);

			//REAR
			//Drill from the back space to solder the wire
			translate([l_total+0.01,0,it_wall*1.5/2])
			rotate([0,-90,0])
			linear_extrude(it_cap_back)
			square([it_wall*1.5,iw_slot_wire],center=true);

		} //End Subtract

	} //End difference
	
}



///	HOLDER ONE BATTERY 1S 1P

//holder_18650_1s1p();

//holder_18650_1s1p( ix_show_battery = true, ix_show_tab = true );