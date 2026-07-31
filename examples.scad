






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



// ============================================ [ IT ] ============================================
// ==================================== [ IT / Mobile Phone ] =====================================
// ==================== [ IT / Mobile Phone / phoneholder_car_headrest.scad ] =====================
use <Models/IT/Mobile Phone/phoneholder_car_headrest.scad>;
T(100)phoneholder_car_headrest();
T(210)_hText("Models/IT/Mobile Phone/phoneholder_car_headrest.scad");




// ========================================== [ Tools ] ===========================================
// =================================== [ Tools / Consumables ] ====================================
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