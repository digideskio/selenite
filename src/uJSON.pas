unit uJSON;

{
  Selenite Lua Library - JSON Object
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
  Classes, SysUtils, Lua, LuaObject, SuperObject, CatStrings, Variants,
  CatJSON;

type
  TSeleniteJSON = class(TLuaObject)
  private
  public
    obj: TCatJSON;
    function GetPropValue(propName: String): Variant; override;
    function SetPropValue(propName: String; const AValue: Variant)
      : Boolean; override;
    constructor Create(LuaState: PLua_State; AParent: TLuaObject = nil);
      overload; override;
    destructor Destroy; override;
  end;

procedure RegisterSeleniteJSON(L: PLua_State);

implementation

uses pLua;

function method_settext(L: PLua_State): Integer; cdecl;
var
  o: TSeleniteJSON;
begin
  o := TSeleniteJSON(LuaToTLuaObject(L, 1));
  o.obj.text := lua_tostring(L, 2);
  result := 1;
end;

function method_gettext(L: PLua_State): Integer; cdecl;
var
  o: TSeleniteJSON;
begin
  o := TSeleniteJSON(LuaToTLuaObject(L, 1));
  lua_pushstring(L, o.obj.text);
  result := 1;
end;

function method_gettext_withunquotedkeys(L: PLua_State): Integer; cdecl;
var
  o: TSeleniteJSON;
begin
  o := TSeleniteJSON(LuaToTLuaObject(L, 1));
  lua_pushstring(L, o.obj.TextUnquoted);
  result := 1;
end;

procedure register_methods(L: PLua_State; classTable: Integer);
begin
  RegisterMethod(L, '__tostring', @method_gettext, classTable);
  RegisterMethod(L, 'getjson', @method_gettext, classTable);
  RegisterMethod(L, 'getjson_unquoted', @method_gettext_withunquotedkeys,
    classTable);
  RegisterMethod(L, 'load', @method_settext, classTable);
end;

const
  cObjectName = 'sel_json';

function new_callback(L: PLua_State; AParent: TLuaObject = nil): TLuaObject;
begin
  result := TSeleniteJSON.Create(L, AParent);
end;

function Create(L: PLua_State): Integer; cdecl;
var
  p: TLuaObjectNewCallback;
begin
  p := @new_callback;
  result := new_LuaObject(L, cObjectName, p);
end;

procedure RegisterSeleniteJSON(L: PLua_State);
begin
  RegisterTLuaObject(L, cObjectName, @Create, @register_methods);
end;

constructor TSeleniteJSON.Create(LuaState: PLua_State; AParent: TLuaObject);
begin
  inherited Create(LuaState, AParent);
  obj := TCatJSON.Create;
end;

destructor TSeleniteJSON.Destroy;
begin
  obj.Free;
  inherited Destroy;
end;

function TSeleniteJSON.GetPropValue(propName: String): Variant;
begin
  if obj.sobject.o[propName] <> nil then
  begin
    case obj.sobject.o[propName].DataType of
      stNull:
        result := Null;
      stBoolean:
        result := obj.sobject.b[propName];
      stDouble:
        result := obj.sobject.d[propName];
      stInt:
        result := obj.sobject.i[propName];
      stString:
        result := obj.sobject.s[propName];
      // stObject,stArray, stMethod:
    end;
  end;
end;

function TSeleniteJSON.SetPropValue(propName: String;
  const AValue: Variant): Boolean;
var
  ltype: Integer;
begin
  result := true;
  ltype := lua_type(L, 3);
  case ltype of
    LUA_TSTRING:
      obj.sobject.s[propName] := lua_tostring(L, 3);
    LUA_TBOOLEAN:
      obj.sobject.b[propName] := lua_toboolean(L, 3);
    LUA_TNUMBER:
      begin
        if TVarData(AValue).vType = varDouble then
          obj.sobject.d[propName] := lua_tonumber(L, 3)
        else
          obj.sobject.i[propName] := lua_tointeger(L, 3);
      end;
  else
    obj[propName] := AValue;
  end;
end;

end.
