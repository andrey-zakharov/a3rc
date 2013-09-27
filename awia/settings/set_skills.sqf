//setSkill for ai on map from editor
//AI Skill  

diag_log format ["%1 - starting set skills", time];
diag_log "-----------------";

while { true } do  
{
	
	{
		if ( !( isPlayer _x ) && (_x getVariable ["skillAdjust", 0] == 0) ) then
		{
			_aA = _x skill "aimingAccuracy";
			_aS = _x skill "aimingShake";
			_aSp = _x skill "aimingSpeed";
			_e = _x skill "Endurance";
			_sD = _x skill "spotDistance";
			_sT = _x skill "spotTime";
			_c = _x skill "courage";
			_rS =_x skill "reloadSpeed";
			_cm =_x skill "commanding";
		
			//diag_log format [
			//				"unit: %1 - ORGSKILL: aimingAccuracy: %2 aimingShake: %3 aimingSpeed: %4 Endurance: %5 spotDistance: %6 spotTime: %7 courage: %8 reloadSpeed: %9 commanding: %10"
			//				,_x,_aA,_aS,_aSp,_e,_sD,_sT,_c,_rS, _cm];
							
			_x setUnitAbility 0.85;
			_x setskill ["aimingAccuracy",0.30 + random 0.25];
			_x setskill ["aimingShake",0.45 + random 0.90];
			_x setskill ["aimingSpeed",0.30 + random 0.80];
			_x setskill ["Endurance",0.60 + random 0.70];
			_x setskill ["spotDistance",0.85 + random 0.95];
			_x setskill ["spotTime",0.50 + random 0.95];
			_x setskill ["courage",0.75 + random 0.80];
			_x setskill ["reloadSpeed",0.30 + random 0.60];
			_x setskill ["general",0.55 + random 0.75];
			
			if ( isFormationLeader _x ) then {
				_x setskill ["commanding",0.65 + random 0.70];
			} else {
				_x setskill ["commanding",0.60 + random 0.70];
			};

			_aA = _x skill "aimingAccuracy";
			_aS = _x skill "aimingShake";
			_aSp = _x skill "aimingSpeed";
			_e = _x skill "Endurance";
			_sD = _x skill "spotDistance";
			_sT = _x skill "spotTime";
			_c = _x skill "courage";
			_rS =_x skill "reloadSpeed";
			_cm =_x skill "commanding";

			//diag_log format [
			//				"unit: %1 - NEWSKILL: aimingAccuracy: %2 aimingShake: %3 aimingSpeed: %4 Endurance: %5 spotDistance: %6 spotTime: %7 courage: %8 reloadSpeed: %9 commanding: %10"
			//				,_x,_aA,_aS,_aSp,_e,_sD,_sT,_c,_rS, _cm];
			//diag_log "-----------------";				
			
			_x setVariable ["skillAdjust", 1];
		};
		
		sleep 0.1;
		
	} forEach allUnits;

	sleep 26;
};