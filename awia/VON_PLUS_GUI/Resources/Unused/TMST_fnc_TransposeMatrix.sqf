/*
* This function can transpose a 2D array
*
*
*
*/
private["_Matrix"];
_Matrix=_this select 0; 
_TransposeMatrix=_Matrix; 
	try{
	_ilength=(count  _Matrix);
	}catch{
	breakTo "main";
	};
	scopeName "main";
	    if(_ilength>0) then
	    {
		    try{
			_jlength = (count (_Matrix select 0));
			}catch{
			breakTo "main";
			};
			if(_jlength>0) then 
			{
				for[{_i=1},{_i<_ilength},{_i=_i+1}] do{
				   try{
				   _elementlength=(count (_Matrix  select _i))
				   }catch{
				   breakTo "main";
				   };
				   if(_elementlength!=_jlength) then {breakTo "main";};
				};
			    _TransposeMatrix=[];
				for[{_j=0},{_j<_jlength},{_j=_j+1}] do 
				{
					_Array=[];
					for[{_i=0},{_i<_ilength},{_i=_i+1}] do 
					{
						_Array=_Array+[(_Matrix  select _i) select _j];
					};
					_TransposeMatrix=_TransposeMatrix+[_Array];
			    };
			};
		};
		
_TransposeMatrix	  