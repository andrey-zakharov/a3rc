/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.8 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/
while {true} do{waitUntil {sleep 0.5; alive player};if (typeOf player == "B_engineer_F") then{onEachFrame{{if (side _x == WEST || side _x == CIVILIAN) then{if (damage _x > 0.02 && damage _x < 1) then{if ((player distance _x) < 700) then{_red = 0;_green = 0;_blueDec = 0;_vehDamage = damage _x;if (_vehDamage <= 0.5) then{_green = 255;_red = ((_vehDamage * 100) * 5.1);} else {_red = 255;_green = 255 - ((_vehDamage * 100) * 2.55 )};_redDec = _red / 255;_greenDec = _green / 255;_vehName = getText(configFile>>"CfgVehicles">>typeOf vehicle _x>>"DisplayName");drawIcon3D["a3\ui_f\data\map\markers\nato\b_maint.paa",[_redDec,_greenDec,_blueDec,1],_x,1,1,0,format["%1 needs repairing (%2m)", _vehName, ceil (player distance _x)],1];};};};} forEach vehicles;if (!alive player) then { onEachFrame {}; };};};if (typeOf player == "B_officer_F") then{onEachFrame{{if (side _x == WEST || side _x == CIVILIAN) then{if (damage _x > 0.02 && damage _x < 1) then{if ((player distance _x) < 700) then{_red = 0;_green = 0;_blueDec = 0;_vehDamage = damage _x;if (_vehDamage <= 0.5) then{_green = 255;_red = ((_vehDamage * 100) * 5.1);} else {_red = 255;_green = 255 - ((_vehDamage * 100) * 2.55 )};_redDec = _red / 255;_greenDec = _green / 255;_vehName = getText(configFile>>"CfgVehicles">>typeOf vehicle _x>>"DisplayName");drawIcon3D["a3\ui_f\data\map\markers\nato\b_maint.paa",[_redDec,_greenDec,_blueDec,1],_x,1,1,0,format["%1 needs repairing (%2m)", _vehName, ceil (player distance _x)],1];};};};} forEach vehicles;if (!alive player) then { onEachFrame {}; };};};if (typeOf player == "B_soldier_repair_F") then{onEachFrame{{if (side _x == WEST || side _x == CIVILIAN) then{if (damage _x > 0.02 && damage _x < 1) then{if ((player distance _x) < 700) then{_red = 0;_green = 0;_blueDec = 0;_vehDamage = damage _x;if (_vehDamage <= 0.5) then{_green = 255;_red = ((_vehDamage * 100) * 5.1);} else {_red = 255;_green = 255 - ((_vehDamage * 100) * 2.55 )};_redDec = _red / 255;_greenDec = _green / 255;_vehName = getText(configFile>>"CfgVehicles">>typeOf vehicle _x>>"DisplayName");drawIcon3D["a3\ui_f\data\map\markers\nato\b_maint.paa",[_redDec,_greenDec,_blueDec,1],_x,1,1,0,format["%1 needs repairing (%2m)", _vehName, ceil (player distance _x)],1];};};};} forEach vehicles;if (!alive player) then { onEachFrame {}; };};};waitUntil {sleep 0.5; !alive player};};


