unit uStrListParser;

{
  Selenite Lua Library - String List Parser Object
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
  Classes, SysUtils, Lua, LuaObject, CatStringLoop;

type
  { TSeleniteStrListParser }
  TSeleniteStrListParser = class(TLuaObject)
  private
    constructor Create(LuaState: PLua_State;
      AParent: TLuaObject = nil); overload;
    function GetPropValue(propName: String): Variant; override;
    function SetPropValue(propName: String; const AValue: Variant)
      : Boolean; override;
  public
    obj: TStringLoop;
    destructor Destroy; override;
  end;

procedure RegisterSeleniteStrListParser(L: PLua_State);

implementation

uses pLua;

function method_parsing(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  lua_pushboolean(L, ht.obj.found);
  result := 1;
end;

function method_clear(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.clear;
  result := 1;
end;

function method_stop(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.stop;
  result := 1;
end;

function method_reset(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.reset;
  result := 1;
end;

function method_delete(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.delete;
  result := 1;
end;

function method_add(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.List.add(lua_tostring(L, 2));
  result := 1;
end;

function method_loadfromstr(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.loadfromstring(lua_tostring(L, 2));
  result := 1;
end;

function method_loadfromfile(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.loadfromfile(lua_tostring(L, 2));
  result := 1;
end;

function method_savetofile(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  ht.obj.List.savetofile(lua_tostring(L, 2));
  result := 1;
end;

function method_getvalue(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  plua_pushstring(L, ht.obj.getvalue(lua_tostring(L, 2)));
  result := 1;
end;

function method_indexof(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteStrListParser;
begin
  ht := TSeleniteStrListParser(LuaToTLuaObject(L, 1));
  lua_pushinteger(L, ht.obj.indexof(lua_tostring(L, 2)));
  result := 1;
end;

procedure RegisterSeleniteStrListParser(L: PLua_State);
const
  objname = 'sel_listparser';
  procedure register_methods(L: PLua_State; classTable: Integer);
  begin
    RegisterMethod(L, 'indexof', @method_indexof, classTable);
    RegisterMethod(L, 'load', @method_loadfromstr, classTable);
    RegisterMethod(L, 'loadfromfile', @method_loadfromfile, classTable);
    RegisterMethod(L, 'parsing', @method_parsing, classTable);
    RegisterMethod(L, 'savetofile', @method_savetofile, classTable);
    RegisterMethod(L, 'stop', @method_stop, classTable);
    RegisterMethod(L, 'reset', @method_reset, classTable);
    RegisterMethod(L, 'clear', @method_clear, classTable);
    RegisterMethod(L, 'curgetvalue', @method_getvalue, classTable);
    RegisterMethod(L, 'curdelete', @method_delete, classTable);
    RegisterMethod(L, 'add', @method_add, classTable);
  end;
  function new_callback(L: PLua_State; AParent: TLuaObject = nil): TLuaObject;
  begin
    result := TSeleniteStrListParser.Create(L, AParent);
  end;
  function Create(L: PLua_State): Integer; cdecl;
  var
    p: TLuaObjectNewCallback;
  begin
    p := @new_callback;
    result := new_LuaObject(L, objname, p);
  end;

begin
  RegisterTLuaObject(L, objname, @Create, @register_methods);
end;

constructor TSeleniteStrListParser.Create(LuaState: PLua_State;
  AParent: TLuaObject);
begin
  inherited Create(LuaState, AParent);
  obj := TStringLoop.Create;
end;

function TSeleniteStrListParser.GetPropValue(propName: String): Variant;
begin
  if CompareText(propName, 'commatext') = 0 then
    result := obj.List.CommaText
  else if CompareText(propName, 'count') = 0 then
    result := obj.Count
  else if CompareText(propName, 'current') = 0 then
    result := obj.Current
  else if CompareText(propName, 'curindex') = 0 then
    result := obj.Index(false)
  else if CompareText(propName, 'text') = 0 then
    result := obj.List.Text
  else
    result := inherited GetPropValue(propName);
end;

function TSeleniteStrListParser.SetPropValue(propName: String;
  const AValue: Variant): Boolean;
begin
  result := true;
  if CompareText(propName, 'commatext') = 0 then
  begin
    obj.List.CommaText := AValue;
    obj.reset;
  end
  else if CompareText(propName, 'current') = 0 then
    obj.Current := AValue
  else if CompareText(propName, 'iscsv') = 0 then
    obj.iscsv := AValue
  else if CompareText(propName, 'text') = 0 then
    obj.loadfromstring(AValue)
  else
    result := inherited SetPropValue(propName, AValue);
end;

destructor TSeleniteStrListParser.Destroy;
begin
  obj.free;
  inherited Destroy;
end;

end.
