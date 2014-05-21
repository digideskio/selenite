library Selenite;

{
  Selenite Lua Library
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

uses
  Lua,
  uMain in 'uMain.pas';

{$R *.res}

function luaopen_Selenite(L: plua_State): integer; cdecl;
begin
  Result := RegisterSelenite(L);
end;

Exports
  luaopen_Selenite;

begin

end.
