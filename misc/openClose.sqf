
private ["_targetChoppa","_animationState","_doorNumber"];
_targetChoppa = _this select 0;

// THIS IS TO MAKE SURE THAT ONLY ONE SCRIPT AT A TIME IS RUNNING
if (isNil{_targetChoppa getVariable "openCloseScriptRunning"}) then
{
         // THIS IS TO PREVENT THE SCRIPT FROM BEING RUN MORE THAN ONCE AT THE SAME TIME
         _targetChoppa setVariable ["openCloseScriptRunning",1,false];
         
         // THIS IS SENT FROM THE ADDACTION TO TELL THIS SCRIPT WHICH ACTION THE PLAYER CLICKED ON
         _doorNumber = _this select 3;
         
         // LEFT FRONT DOOR
         if (_doorNumber == 0) then
         {
                  // CHECK IF DOOR IS OPEN OR CLOSED
                  _animationState = _targetChoppa animationPhase "DoorL_Front_Open";
                  
                  if (_animationState < 1) then
                  {
                           // OPEN THE DOOR
                           _targetChoppa animate ['DoorL_Front_Open', 1];
                           _targetChoppa say3D ["HintExpand",1];
                           waitUntil {(_targetChoppa animationPhase "DoorL_Front_Open") == 1};
                  } else
                  {
                           // CLOSE THE DOOR
                           _targetChoppa animate ['DoorL_Front_Open', 0];
                           _targetChoppa say3D ["HintCollapse",1];
                           waitUntil {(_targetChoppa animationPhase "DoorL_Front_Open") == 0};
                           _targetChoppa say3D ["ClickSoft",1];
                  };
         };
         
         // LEFT REAR DOOR
         if (_doorNumber == 1) then
         {
                  // CHECK IF DOOR IS OPEN OR CLOSED
                  _animationState = _targetChoppa animationPhase "DoorL_Back_Open";
                  
                  if (_animationState < 1) then
                  {
                           // OPEN THE DOOR
                           _targetChoppa animate ['DoorL_Back_Open', 1];
                           _targetChoppa say3D ["HintExpand",1];
                           waitUntil {(_targetChoppa animationPhase "DoorL_Back_Open") == 1};
                  } else
                  {
                           // CLOSE THE DOOR
                           _targetChoppa animate ['DoorL_Back_Open', 0];
                           _targetChoppa say3D ["HintCollapse",1];
                           waitUntil {(_targetChoppa animationPhase "DoorL_Back_Open") == 0};
                           _targetChoppa say3D ["ClickSoft",1];
                  };
         };
         
         // RIGHT FRONT DOOR
         if (_doorNumber == 2) then
         {
                  // CHECK IF DOOR IS OPEN OR CLOSED
                  _animationState = _targetChoppa animationPhase "DoorR_Front_Open";
                  
                  if (_animationState < 1) then
                  {
                           // OPEN THE DOOR
                           _targetChoppa animate ['DoorR_Front_Open', 1];
                           _targetChoppa say3D ["HintExpand",1];
                           waitUntil {(_targetChoppa animationPhase "DoorR_Front_Open") == 1};
                  } else
                  {
                           // CLOSE THE DOOR
                           _targetChoppa animate ['DoorR_Front_Open', 0];
                           _targetChoppa say3D ["HintCollapse",1];
                           waitUntil {(_targetChoppa animationPhase "DoorR_Front_Open") == 0};
                           _targetChoppa say3D ["ClickSoft",1];
                  };
         };
         
         // RIGHT REAR DOOR
         if (_doorNumber == 3) then
         {
                  // CHECK IF DOOR IS OPEN OR CLOSED
                  _animationState = _targetChoppa animationPhase "DoorR_Back_Open";
                  
                  if (_animationState < 1) then
                  {
                           // OPEN THE DOOR
                           _targetChoppa animate ['DoorR_Back_Open', 1];
                           _targetChoppa say3D ["HintExpand",1];
                           waitUntil {(_targetChoppa animationPhase "DoorR_Back_Open") == 1};
                  } else
                  {
                           // CLOSE THE DOOR
                           _targetChoppa animate ['DoorR_Back_Open', 0];
                           _targetChoppa say3D ["HintCollapse",1];
                           waitUntil {(_targetChoppa animationPhase "DoorR_Back_Open") == 0};
                           _targetChoppa say3D ["ClickSoft",1];
                  };
         };
         
         // THIS IS TO PREVENT THE SCRIPT FROM BEING RUN MORE THAN ONCE AT THE SAME TIME
         _targetChoppa setVariable ["openCloseScriptRunning",nil,false];
         
};

