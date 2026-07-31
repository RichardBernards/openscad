//
//    OpenSCAD model example file
// examples.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-07-31    Initial version
//






/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;
//use <threads-scad/threads.scad>;
//use <knurledFinishLib_v2.scad>;



// =========================================== [ Home ] ===========================================
// ======================================= [ Home / Games ] =======================================
// =============================== [ Home / Games / cardbox.scad ] ================================
//use <Models/Home/Games/cardbox.scad>;
//RIXTODO convert with UB and check design
// ====================================== [ Home / Storage ] ======================================
// ========================= [ Home / Storage / dialbox_organiser.scad ] ==========================
use <Models/Home/Storage/dialbox_organiser.scad>;
T(50,100)dialbox_organiser();
T(100,100)_hText("Models/Home/Storage/dialbox_organiser.scad");


// ============================================ [ IT ] ============================================
// ==================================== [ IT / Mobile Phone ] =====================================
// ==================== [ IT / Mobile Phone / phoneholder_car_headrest.scad ] =====================
use <Models/IT/Mobile Phone/phoneholder_car_headrest.scad>;
T(100)phoneholder_car_headrest();
T(210)_hText("Models/IT/Mobile Phone/phoneholder_car_headrest.scad");




// ========================================== [ Tools ] ===========================================
// =================================== [ Tools / Consumables ] ====================================
// ========================== [ Tools / Consumables / bowdenplug.scad ] ===========================
use <Models/Tools/Consumables/bowdenplug.scad>;
T(-25,150)bowdenplug();
T(-40,145)_hText("Models/Tools/Consumables/bowdenplug.scad",true);
// ========================== [ Tools / Consumables / cableclamp.scad ] ===========================
use <Models/Tools/Consumables/cableclamp.scad>;
T(-35,125)cableclamp();
T(-60,120)_hText("Models/Tools/Consumables/cableclamp.scad",true);
// ============================= [ Tools / Consumables / knob.scad ] ==============================
use <Models/Tools/Consumables/knob.scad>;
T(-45,70,18)R(180)knob();
T(-95,65)_hText("Models/Tools/Consumables/knob.scad",true);
// ========================== [ Tools / Consumables / trussclamp.scad ] ===========================
use <Models/Tools/Consumables/trussclamp.scad>;
T(-40)trussclamp();
T(-90)_hText("Models/Tools/Consumables/trussclamp.scad",true);




// ==================================== [ Tools / Powertools ] ====================================
// ====================== [ Tools / Powertools / dewalt_batteryholder.scad ] ======================
use <Models/Tools/Powertools/dewalt_batteryholder.scad>;
T(-20,-160)R(0,0,90)dewalt_batteryholder();
T(-275,-120)_hText("Models/Tools/Powertools/dewalt_batteryholder.scad",true);
// ======================== [ Tools / Powertools / dewalt_bitholder.scad ] ========================
use <Models/Tools/Powertools/dewalt_bitholder.scad>;
T(-50,-200)dewalt_bitholder();
T(-100,-205)_hText("Models/Tools/Powertools/dewalt_bitholder.scad",true);















module _hText(t="test",alignRight=false) {
  tm = textmetrics(text=t, font="Agency FB:style=Regular", size=11);
  if(alignRight) {
    T(-tm.size[0])linear_extrude(0.4)text(text=t, font="Agency FB:style=Regular", size=11);
  } else {
    linear_extrude(0.4)text(text=t, font="Agency FB:style=Regular", size=11);
  }
}