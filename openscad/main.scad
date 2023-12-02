include <BOSL2/std.scad>
include <std.scad>

sr = 2.4/2;
sr2 = 2.8/2;
ssr = 1.5/2;
svr = 4.7/2;

br = 25.4*9/2;

pm = 8;
pm2 = 8;

module frames(){
    difference(){
        union(){
            rot_copy(3)
            translate([430/3-10,0,0])
            rotate([0,-30,0])
            translate([0,0,-430/3])
            cylinder(430*(2/3), 12/2, 12/2, $fn=48);

            rot_copy(6)
            translate([430/3+2*pm,0,0])
            rotate([0,0,120])
            rotate([0,90,0])
            translate([0,0,pm])
            cylinder(430/3, 12/2, 12/2, $fn=48);
        }
        
        #
        translate([0,0,0])
        cylinder(20, br, br, $fn=48, center=true);
        #
        translate([0,0,0])
        cylinder(140, 20, 20, $fn=48);
    }
}
module wing2(){
    L = 80;
    R = L/2;
    h = 20;
    m = 0.5;
    h1 = 5;
    difference(){
        union(){
            hull(){
                mirror_copy([0,1,0])
                translate([20+R,10,-h+h1])
                cylinder(h, R, R, $fn=6);

                mirror_copy([0,1,0])
                translate([20+R-35,10,-h+h1])
                cylinder(h, R, R, $fn=6);
            }
        }
        translate([0,0,-m])
        hull(){
            mirror_copy([0,1,0])
            translate([100-5,svr+2+sr,0])
            cylinder(100, 5, 5, $fn=48);
            mirror_copy([0,1,0])
            translate([100,svr+2+sr,0])
            cylinder(100, 5, 5, $fn=48);
        }
        translate([90,0,0])
        rotate([0,90,0])
        cylinder(100, svr, svr, $fn=48);

        mirror_copy([0,1,0])
        translate([100-5,svr+2+sr,0])
        cylinder(100, sr, sr, $fn=48, center=true);
        rotate([0,90,0])
        cylinder(1000, 2.1/cos(30)/2, 2.1/cos(30)/2, $fn=6, center=true);
    }
    difference(){
        translate([100+7/2,0, -h+h1 +10/2])
        cube([7, 20, 10], center=true);
        rotate([0,90,0])
        cylinder(1000,  12.1/2*sqrt(2)+0.2, 12.1/2*sqrt(2)+0.2, $fn=48);
    }
}

module wing2_mask(){
    L = 80;
    R = L/2;
    h = 20;
    m = 0.5;
    difference(){
        union(){
            hull(){
                mirror_copy([0,1,0])
                translate([20+R,10,-20+5])
                cylinder(h, R, R, $fn=6);

                mirror_copy([0,1,0])
                translate([20+R-35,10,-20+5])
                cylinder(h, R, R, $fn=6);
            }
        }
        translate([0,0,-20])
        hull(){
            mirror_copy([0,1,0])
            translate([100-5,svr+2+sr,0])
            cylinder(100, 5, 5, $fn=48);
            mirror_copy([0,1,0])
            translate([100,svr+2+sr,0])
            cylinder(100, 5, 5, $fn=48);
        }
    }
}
module wing2_connector(){
    L = 80;
    R = L/2;
    h = 20;
    m = 0.5;
    difference(){
        translate([0,0,m])
        hull(){
            mirror_copy([0,1,0])
            translate([100-5,svr+2+sr,0])
            cylinder(5-m, 5, 5, $fn=48);
        }
        translate([90,0,0])
        rotate([0,90,0])
        cylinder(100, svr, svr, $fn=48);

        mirror_copy([0,1,0])
        translate([100-5,svr+2+sr,0])
        cylinder(100, sr, sr, $fn=48, center=true);
    }
}
module connector(){
    half_of([0,0,1], [0,0,-4])
    difference(){
        union(){
            mirror_copy([1,0,0])
            rotate([0,60,0])
            cylinder(pm+15, 12/2+4, 12/2+4, $fn=6);

            hull(){
                translate([0,0,-4])
                cylinder(5, 14, 14, $fn=48);

                hull(){
                    mirror_copy([1,0,0])
                    rotate([0,60,0])
                    translate([-12/2-4+5/cos(30),0,0])
                    cylinder(pm+15, 5/cos(30), 5/cos(30), $fn=6);
                }
            }
        }
        

        #
        hull()
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 0.3, 0.3, $fn=48);

        #mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 12/2, 12/2, $fn=48);
        
        #
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([-12/2-sr-2,0,pm+15/2])
        rotate([90,0,0])
        {
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }
        
        rotate([0,0,90])
        rot_copy(2)
        {
            translate([12/2+3+2,0,0])
            {
                cylinder(100, sr,sr,$fn=48, center=true);
                translate([0,0,1])
                #cylinder(100, 3,3,$fn=48);
            }
        }
    }
}

module connector2(){
    difference(){
        union(){
            mirror_copy([1,0,0])
            rotate([0,60,0])
            cylinder(pm+15, 9, 9, $fn=48);

            sphere(9, $fn=48);
            hull(){
                mirror_copy([1,0,0])
                rotate([0,60,0])
                translate([-9/2,0, (pm+15)/2])
                cube([9, 10, pm+15], center=true);

            }
        }
        

        #
        hull()
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 0.3, 0.3, $fn=48);

        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 12/2, 12/2, $fn=48);
        
        #
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([-12/2-sr-2,0,pm+15/2])
        rotate([90,0,0])
        {
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }
        
    }
}
module connector3(){
    pitch = 50;
    h = 20;
    half_of([0,0,-1], [0,0,22])
    difference(){
        union(){
            mirror_copy([1,0,0])
            rotate([0,60,0])
            cylinder(pm+h, 9, 9, $fn=48);

            rotate([pitch,0,0])
            cylinder(pm2+h, 9, 9, $fn=48);

            sphere(9, $fn=48);

            hull(){
                mirror_copy([1,0,0])
                rotate([0,60,0])
                translate([-9/2,0, (pm+h)/2])
                cube([10, 10, pm+h], center=true);

            }
            half_of([0,-1,0])
            hull(){
                rotate([0,0,90])
                mirror_copy([1,0,0])
                rotate([0,pitch,0])
                translate([-10/2,0, (pm2+h)/2])
                cube([10, 10, pm2+h], center=true);

            }
        }
        

        
        hull()
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 0.3, 0.3, $fn=48);

        #
        hull()
        {
            rotate([0,0,-90])
            rotate([0,pitch,0])
            cylinder(100, 0.3, 0.3, $fn=48);
            translate([0,100,0])
            cylinder(100, 0.3, 0.3, $fn=48);
        }

        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 12/2, 12/2, $fn=48);

        rotate([pitch,0,0])
        translate([0,0,pm2])
        cylinder(100, 12/2, 12/2, $fn=48, center=true);
        
        
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([-12/2-sr-2,0,pm+h/2])
        rotate([90,0,0])
        {
            cylinder(11, sr, sr, $fn=48, center=true);
            mirror([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }
        
        #
        rotate([0,0,-90])
        rotate([0,pitch,0])
        translate([-12/2-sr-2,0,pm2+h/2])
        rotate([90,0,0])
        {
            cylinder(11, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5]){
                cylinder(5, 3, 3, $fn=48);
                cylinder(100, 2, 2, $fn=48);
            }
        }
    }
}

module connector4(){
    R=25;
    pitch = atan2(15,21);
    half_of([0,0,1], [0,0,-20])
    half_of([0,0,-1])
    difference(){
        union(){
            difference(){
                union(){
                    translate([0,0,-20])
                    cylinder(20, 20, 20, $fn=48);
                    
                    rot_copy(3)
                    half_of([0,0,1], [0,0,-20])
                    hull(){
                        translate([R,0,0])
                        rotate([0,-pitch,0])
                        translate([0,0,-20])
                        cylinder(60, 12/2+3, 12/2+3, $fn=48);

                        translate([0,0,-20])
                        cylinder(20, 12/2+3, 12/2+3, $fn=48);
                    }
                }
                cylinder(100, 10, 10, $fn=48, center=true);
            }
            rot_copy(3)
            translate([R,0,0])
            rotate([0,-pitch,0])
            translate([0,0,-25])
            cylinder(60, 12/2+3, 12/2+3, $fn=48);


            rot_copy(3)
            chain_hull(){
                translate([15,0,0])
                translate([0,0,-10])
                cylinder(10, 5,5,$fn=48);

                translate([R,0,0])
                rotate([0,-pitch,0])
                translate([-(12/2+3)+5,0,-25])
                cylinder(30+10, 5,5,$fn=48);

                translate([R,0,0])
                rotate([0,-pitch,0])
                translate([0,0,-25])
                cylinder(30, 5,5,$fn=48);
            }

        }

        rotate([0,0,360/12])
        rot_copy(6)
        translate([30/2, 0, 0]){
            cylinder(100, sr, sr, $fn=48, center=true);
            translate([0,0,-15])
            hull(){
                cylinder(100, 3, 3, $fn=48);
                translate([0,0,-3])
                cylinder(100, 0.1, 0.1, $fn=48);
            }
        }
        rot_copy(6)
        translate([0,0,-20/2])
        mirror([0,0,1])
        translate([0,0,20/2])
        translate([30/2, 0, 0]){
            cylinder(100, sr, sr, $fn=48, center=true);
            translate([0,0,-15])
            hull(){
                cylinder(100, 3, 3, $fn=48);
                translate([0,0,-3])
                cylinder(100, 0.1, 0.1, $fn=48);
            }
        }

        
        rot_copy(3)
        translate([R,0,0])
        rotate([0,-pitch,0])
        translate([0,0,-100-12/2*tan(30)-3])
        cylinder(100, 12/2+0.1, 12/2+0.1, $fn=48);

        #rot_copy(3)
        translate([R,0,0])
        rotate([0,-pitch,0])
        translate([-12/2-2-sr,0,-12/2*tan(30)-3-5-2])
        rotate([90,0,0]){
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }

        #
        rot_copy(3)
        chain_hull(){
            translate([R,0,0])
            rotate([0,-pitch,0])
            translate([0,0,-30-12/2*tan(30)-3])
            cylinder(30, 0.5,0.5,$fn=48);

            translate([R,0,0])
            rotate([0,-pitch,0])
            translate([-11,0,-30-12/2*tan(30)-3])
            cylinder(30, 0.5,0.5,$fn=48);

            translate([R,0,0])
            rotate([0,-pitch,0])
            translate([-20,0,-30-12/2*tan(30)-3-13])
            cylinder(30, 0.5,0.5,$fn=48);
        }
    }
}
module connector5(){
    difference(){
        union(){
            translate([0,0,-40])
            cylinder(40, 20, 30, $fn=48);
        }
        translate([0,0,-40.1])
        cylinder(40.2, 10, 20, $fn=48);
        rot_copy(12)
        translate([25,0,0])
        cylinder(100, sr, sr, $fn=48, center=true);

        rot_copy(12)
        translate([30/2,0,0])
        cylinder(100, sr, sr, $fn=48, center=true);

        rot_copy(12)
        hull(){
            translate([25,0,-100-5])
            cylinder(100, 3, 3, $fn=48);
            translate([25+10,0,-100-5])
            cylinder(100, 3, 3, $fn=48);
        }
        rot_copy(12)
        hull(){
            translate([30/2,0,-40+5])
            cylinder(100, 3, 3, $fn=48);
            translate([30/2-10,0,-40+5])
            cylinder(100, 3, 3, $fn=48);
        }
    }
}
module connector6(){
    pm = 9;
    //pitch = 50;
    pitch = 90-atan2(15,21);
    h = 20;
    half_of([0,0,-1], [0,0,22])
    difference(){
        union(){
            mirror_copy([1,0,0])
            rotate([0,60,0])
            cylinder(pm+h, 9, 9, $fn=48);

            rotate([pitch,0,0])
            cylinder(pm2+h, 9, 9, $fn=48);

            sphere(9, $fn=48);

            hull(){
                mirror_copy([1,0,0])
                rotate([0,60,0])
                translate([-9/2,0, (pm+h)/2])
                cube([10, 10, pm+h], center=true);

            }
            half_of([0,-1,0])
            hull(){
                rotate([0,0,90])
                mirror_copy([1,0,0])
                rotate([0,pitch,0])
                translate([-10/2,0, (pm2+h)/2])
                cube([10, 10, pm2+h], center=true);

            }
            hull(){
                mirror_copy([1,0,0])
                translate([12.1/2, 22.85+15, -10+22])
                cylinder(10, 3, 3, $fn=48);

                mirror_copy([1,0,0])
                translate([12.1/2, 0, -10+22])
                cylinder(10, 3, 3, $fn=48);
            }
        }
        

        
        hull()
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 0.3, 0.3, $fn=48);

        #
        hull()
        {
            rotate([0,0,-90])
            rotate([0,pitch,0])
            cylinder(100, 0.3, 0.3, $fn=48);
            translate([0,20,0])
            cylinder(100, 0.3, 0.3, $fn=48);
        }

        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([0,0,pm])
        cylinder(100, 12/2, 12/2, $fn=48);

        rotate([pitch,0,0])
        translate([0,0,pm2])
        cylinder(100, 12/2, 12/2, $fn=48, center=true);
        
        
        mirror_copy([1,0,0])
        rotate([0,60,0])
        translate([-12/2-sr-2,0,pm+h/2])
        rotate([90,0,0])
        {
            cylinder(11, sr, sr, $fn=48, center=true);
            mirror([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }
        
        #
        rotate([0,0,-90])
        rotate([0,pitch,0])
        translate([-12/2-sr-2,0,pm2+h/2])
        rotate([90,0,0])
        {
            cylinder(11, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5]){
                cylinder(5, 3, 3, $fn=48);
                cylinder(100, 2, 2, $fn=48);
            }
        }

        #
        translate([0,10,22-5])
        rotate([0,90,0])
        {
            cylinder(11, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5]){
                cylinder(5, 3, 3, $fn=48);
                cylinder(100, 2, 2, $fn=48);
            }
        }

        #
        translate([0, 22.85/2+15,-20/2+22])
        cube([12.1, 22.85, 20], center=true);
    }
}
module blade_servo_adapter(){
    _br = br+8;
    m = 12;
    h = 12;
    theta3 = atan2(15,21);
    difference(){
        union(){
            hull(){
                rotate([0,theta3,0])
                translate([0,0,15])
                cylinder(15, 12/2+3, 12/2+3, $fn=48);

                translate([20/2+12+10-3,0,(22.85+6)/2-8/2])
                cube([6, 12.1+6, 8], center=true);
            }

            translate([20/2+12+10-3,0,0])
            cube([6, 12.1+6, 22.85+6], center=true);
        }
        #
        translate([20/2+12,0,0])
        cube([20, 12.1, 22.85], center=true);
        #
        rotate([0,theta3,0])
        cylinder(100, 12/2, 12/2, $fn=48, center=true);

        #
        hull()
        rotate([0,theta3,0]){
            cylinder(100, 0.3, 0.3, $fn=48, center=true);
            translate([26,0,0])
            cylinder(100, 0.3, 0.3, $fn=48, center=true);
        }
        
        
        #
        translate([17,0,19])
        rotate([90,0,0]){
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }

        #
        translate([25,0,17])
        rotate([90,0,0])
        {
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            hull(){
                translate([0,0,5])
                cylinder(100, 3, 3, $fn=48);
                translate([0,10,5])
                cylinder(100, 3, 3, $fn=48);
            }
        }
    }
}
module foot(){
    difference(){
        hull(){
            cylinder(20, 12/2+3, 12/2+3, $fn=48);
            translate([100,0,0])
            cylinder(3, 5, 5, $fn=48);
        }
        translate([0,0,2])
        cylinder(20, 12/2, 12/2, $fn=48);
        
        translate([12/2+3,0,2+18/2])
        rotate([90,0,0])
        {
            cylinder(100, sr, sr, $fn=48, center=true);
            mirror_copy([0,0,1])
            translate([0,0,5])
            cylinder(100, 3, 3, $fn=48);
        }
        translate([10,0,0])
        cube([20, 1, 100], center=true);
    }
}
module foot2(){
    half_of([0,0,1])
    difference(){
        hull(){
            rotate([0,-50,0])
            cylinder(20, 12/2+3, 12/2+3, $fn=48);
            translate([50,0,0])
            sphere(5, $fn=48);
        }
        rotate([0,-50,0])
        translate([0,0,2])
        {
            cylinder(30, 12/2, 12/2, $fn=48);
            hull(){
                translate([20,0,0])
                cylinder(100, 0.5, 0.5, $fn=48, center=true);
                translate([-5,0,0])
                cylinder(100, 0.5, 0.5, $fn=48, center=true);
            }
            translate([12/2+3,0,8])
            rotate([90,0,0])
            {
                cylinder(100, sr, sr, $fn=48, center=true);
                mirror_copy([0,0,1])
                translate([0,0,5])
                cylinder(100, 3, 3, $fn=48);
            }
        }
        
    }
}
module foot3(){
    half_of([0,0,1])
    difference(){
        chain_hull(){
            translate([50,50,0])
            sphere(5, $fn=48);

            rotate([0,-50,0])
            cylinder(20, 12/2+3, 12/2+3, $fn=48);

            translate([50,-50,0])
            sphere(5, $fn=48);
        }
        rotate([0,-50,0])
        translate([0,0,2])
        {
            cylinder(30, 12/2, 12/2, $fn=48);
            hull(){
                translate([20,0,0])
                cylinder(100, 0.5, 0.5, $fn=48, center=true);
                translate([-5,0,0])
                cylinder(100, 0.5, 0.5, $fn=48, center=true);
            }
            translate([12/2+3,0,8])
            rotate([90,0,0])
            {
                cylinder(100, sr, sr, $fn=48, center=true);
                mirror_copy([0,0,1])
                translate([0,0,5])
                cylinder(100, 3, 3, $fn=48);
            }
        }
        
    }
}
module foot4_1(){
    difference(){
        union(){
            cylinder(2, 20/2 + 2,20/2 + 2,$fn=48);
            translate([0,0,2])
            cylinder(5, 17.5/2+0.3,17.5/2-0.1,$fn=48);
            translate([0,0,-10/2])
            cylinder(10, 12/2+3,20/2 + 2,$fn=48, center=true);
        }
        cylinder(100, 9/2,9/2,$fn=48, center=true);

        hull(){
            translate([0,0,-10.1/2 + (12/2)/cos(30)])
            cylinder(10.2, 0.1, 0.1,$fn=6, center=true);
            translate([0,0,-10.1/2])
            cylinder(10.2, (12/2)/cos(30)+0.1,(12/2)/cos(30) - 0.3,$fn=6, center=true);
        }

        translate([0,0,2+2])
        rotate([90,0,0])
        cylinder(100, ssr, ssr, $fn=48, center=true);
    }
}
module foot4_2(){
    difference(){
        union(){
            cylinder(2, 20/2 + 2,20/2 + 2,$fn=48);
            translate([0,0,2])
            cylinder(5, 17.5/2+0.3,17.5/2-0.1,$fn=48);
            hull(){
                cylinder(2, 20/2 + 2,20/2 + 2,$fn=48);

                translate([0,0,20])
                half_of([0,0,-1], [0,0,-30*cos(45)])
                sphere(30, $fn=48);

                translate([0,0,20])
                translate([0,0,2])
                half_of([0,0,-1], [0,0,-30*cos(45)])
                sphere(30, $fn=48);
            }
        }
        #translate([0,0,-15+7])
        cylinder(15.1, 8/2/cos(30)-0.3,8/2/cos(30)+0.1,$fn=6);


        translate([0,0,2+2])
        rotate([0,90,0])
        cylinder(100, ssr, ssr, $fn=48, center=true);
    }
}

module wind_center_connector(){
    half_of([0,0,1], [0,0,0.2])
    difference(){
        cylinder(5,10,10,$fn=48);
        rotate([0,0,60])
        rot_copy(3)
        translate([5,0,0])
        cylinder(100, sr, sr, $fn=48);
        
        rot_copy(3)
        rotate([0,90,0])
        cylinder(100, 1,1,$fn=48);
    }
}
module battery_board_adapter(){
    difference(){
        h = 40;
        mirror_copy([0,1,0])
        chain_hull(){
            
            translate([4,0,0])
            cylinder(h, 4, 4, center=true);
            translate([4,-25+7,0])
            cylinder(h, 4, 4, center=true);

            translate([4+7,-25,0])
            cylinder(h, 4, 4, center=true);

            translate([5+25,-25,0])
            cylinder(h, 4, 4, center=true);

            translate([4+30+4,-34/2,0])
            cylinder(h, 4, 4, center=true);
            translate([4+30+4,0,0])
            cylinder(h, 4, 4, center=true);

            translate([4+30+4,-34/2,0])
            cylinder(h, 4, 4, center=true);


            translate([88+3-4,-34/2,0])
            cylinder(h, 4, 4, center=true);
            translate([88+3-4,0,0])
            cylinder(h, 4, 4, center=true);
        }

        // board
//        #translate([25+5,0,0]){
//            translate([-10,0,0])
//            rotate([90,0,0])
//            rotate([0,0,90])
//            cylinder(100, 12, 12, $fn=6, center=true);
//
//            cube([1.5, 47, 100], center=true);
//            translate([-10,0,0])
//            hull(){
//                cube([30, 47-4-7*2, 100], center=true);
//
//                translate([7/2,0,0])
//                cube([30-7, 47-4, 100], center=true);
//            }
//            rotate([0,-90,0])
//            rot_copy(12)
//            translate([15, 0, 0])
//            cylinder(100, sr, sr, $fn=48);
//        }
        
        #translate([5,0,0]){
            // side big hole
            translate([15,0,0])
            rotate([90,0,0])
            rotate([0,0,90])
            cylinder(100, 12, 12, $fn=6, center=true);

            // board base
            translate([25,0,0])
            cube([1.5, 47, 100], center=true);

            translate([0,0,0])
            hull(){
                translate([30/2,0,0])
                cube([30, 47-4-7*2, 100], center=true);

                translate([(30-7-5)/2+7,0,0])
                cube([30-7-5, 47-4, 100], center=true);
            }
        }
        
        // upper screw hole
        rotate([0,-90,0])
        rot_copy(12)
        translate([15, 0, -10])
        cylinder(100, sr, sr, $fn=48);
        
        #translate([88-17-32/2,0,0]){
            difference(){
                cube([32,34,100], center=true);
                mirror_copy([0,1,0])
                translate([0, 34/2+19, 0])
                cylinder(100, 20, 20, center=true);
            }
            rotate([90,0,0])
            rotate([0,0,90])
            cylinder(100, 12, 12, $fn=6, center=true);
        }

        translate([15,0,0])
        rotate([90,0,0])
        {
            cylinder(100, sr, sr, $fn=48, center=true);
            
            mirror_copy([0,0,1])
            translate([0,0,8])
            cylinder(100, 3, 3, $fn=48);
        }
        
        rotate([0,-90,0])
        cylinder(100, 10, 10, $fn=6);

        // motor
        translate([88-10, 0, 0])
        #rotate([0,90,0])
        rotate([0,0,45])
        rot_copy(4)
        translate([43/2, 0, 0])
        cylinder(100, sr, sr, $fn=48);

        // long hole
        translate([30, 0, 0])
        #rotate([0,90,0])
        cylinder(200, 12, 12, $fn=6, center=true);
        

    }
}


!battery_board_adapter();
wind_center_connector();
foot4_2();
foot4_1();
blade_servo_adapter();
connector6();
connector5();
!connector4();
connector2();
connector3();
wing2_mask();
!wing2();
wing2_connector();
foot();
foot2();
!foot3();
!union(){
    frames();
    translate([0,0,-40])
    rot_copy(3)
    rotate([30,0,0]){
        wing2();
        wing2_connector();
    }
}
