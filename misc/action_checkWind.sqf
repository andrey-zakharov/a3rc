//  [target, caller, ID, arguments] 
private ["_windDir"];

if ( windStr < 0.2 ) then {
	hint format [ localize "STR_WIND_INFO_NO" ];
} else {
	switch true do {
		case (windDir >= 340 && windDir <= 360 || windDir >= 0 && windDir <= 20): {_windDir = "STR_WIND_INFO_NORTH";};
		case (windDir >= 20 && windDir <= 60): {_windDir = "STR_WIND_INFO_NORTH_EAST";};
		case (windDir >= 60 && windDir <= 110): {_windDir = "STR_WIND_INFO_EAST";};
		case (windDir >= 110 && windDir <= 160): {_windDir = "STR_WIND_INFO_SOUTH_EAST";};
		case (windDir >= 160 && windDir <= 200): {_windDir = "STR_WIND_INFO_SOUTH";};
		case (windDir >= 200 && windDir <= 250): {_windDir = "STR_WIND_INFO_SOUTH_WEST";};
		case (windDir >= 250 && windDir <= 290): {_windDir = "STR_WIND_INFO_WEST";};
		case (windDir >= 290 && windDir <= 340):  {_windDir = "STR_WIND_INFO_NORTH_WEST";};
	};

	hint format [localize "STR_WIND_INFO", localize _windDir, (floor (windStr * 10)) / 10];
};