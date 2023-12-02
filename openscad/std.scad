include <BOSL2/std.scad>

module rot_copy(n){
    dtheta = 360/n;
    for(theta=[0:dtheta:359.99])
        rotate([0,0,theta])
        children();
}
module translate_(x,y,z){
    translate([x,y,z])
        children();
}
module rotate_(x,y,z){
    rotate([x,y,z])
        children();
}