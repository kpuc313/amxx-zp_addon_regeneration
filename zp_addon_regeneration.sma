/*****************************************************************
*                            MADE BY
*
*   K   K   RRRRR    U     U     CCCCC    3333333      1   3333333
*   K  K    R    R   U     U    C     C         3     11         3
*   K K     R    R   U     U    C               3    1 1         3
*   KK      RRRRR    U     U    C           33333   1  1     33333
*   K K     R        U     U    C               3      1         3
*   K  K    R        U     U    C     C         3      1         3
*   K   K   R         UUUUU U    CCCCC    3333333      1   3333333
*
******************************************************************
*                       AMX MOD X Script                         *
*     You can modify the code, but DO NOT modify the author!     *
******************************************************************
*
* Description:
* ============
* This is a plugin for Counte-Strike 1.6's Zombie Plague Mod which regenerate zombies health points every 'x' seconds.
*
*****************************************************************/

#include <amxmodx>
#include <zombieplague>
#include <hamsandwich>
#include <fakemeta>
#include <fun>

new cvar_health, cvar_time
new Float:g_regendelay[33]

public plugin_init() {
	register_plugin("[ZP] Addon: Regeneration", "1.0", "kpuc313")
	
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn", 1)
	register_forward(FM_PlayerPreThink,"fm_PlayerThink")
	
	cvar_health = register_cvar("zp_regen_health","20")
	cvar_time = register_cvar("zp_regen_time","5.0")
}

public client_connect(id) {
	g_regendelay[id] = 0.0
}

public fw_PlayerSpawn(id) {
	g_regendelay[id] = 0.0
}

public fm_PlayerThink(id) {	
	if(is_user_alive(id) && zp_get_user_zombie(id) && get_user_health(id)<zp_get_zombie_maxhealth(id)) {
		static Float:gametime; gametime = get_gametime()
		if(g_regendelay[id] < gametime)
		{
			set_user_health(id,get_user_health(id) + get_pcvar_num(cvar_health))
			g_regendelay[id] = gametime + get_pcvar_float(cvar_time)
		}
	}
	if(is_user_alive(id) && zp_get_user_zombie(id) && get_user_health(id)>zp_get_zombie_maxhealth(id)) {
		set_user_health(id, zp_get_zombie_maxhealth(id))
	}
}
