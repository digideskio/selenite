unit uHTMLParser;

{
  Selenite Lua Library - HTML Parser Object
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
  Classes, SysUtils, dLua, LuaObject, CatHTMLParser;

type
  { TSeleniteHTMLParser }
  TSeleniteHTMLParser = class(TLuaObject)
  private
    constructor Create(LuaState: PLua_State;
      AParent: TLuaObject = nil); overload;
    function GetPropValue(propName: AnsiString): Variant; override;
    function SetPropValue(propName: AnsiString; const AValue: Variant)
      : Boolean; override;
  public
    obj: TCatHTMLParser;
    destructor Destroy; override;
  end;

procedure RegisterSeleniteHTMLParser(L: PLua_State);

implementation

uses pLua, CatStrings;

function method_parsing(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  lua_pushboolean(L, ht.obj.NextTag);
  result := 1;
end;

function method_clear(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  ht.obj.text := '';
  result := 1;
end;

function method_stop(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  ht.obj.GotoEnd;
  result := 1;
end;

function method_reset(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  ht.obj.GotoBeginning;
  result := 1;
end;

function method_getattrib(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
  s: string;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  s := ht.obj.tag.params.values[lua_tostring(L, 2)];
  s := removequotes(s);
  plua_pushstring(L, s);
  result := 1;
end;

function method_setattrib(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  ht.obj.tag.params.values[lua_tostring(L, 2)] := lua_tostring(L, 3);
  result := 1;
end;

function method_loadfromstr(L: PLua_State): Integer; cdecl;
var
  ht: TSeleniteHTMLParser;
begin
  ht := TSeleniteHTMLParser(LuaToTLuaObject(L, 1));
  ht.obj.text := lua_tostring(L, 2);
  result := 1;
end;

procedure RegisterSeleniteHTMLParser(L: PLua_State);
const
  objname = 'sel_htmlparser';
  procedure register_methods(L: PLua_State; classTable: Integer);
  begin
    RegisterMethod(L, 'load', @method_loadfromstr, classTable);
    RegisterMethod(L, 'parsing', @method_parsing, classTable);
    RegisterMethod(L, 'stop', @method_stop, classTable);
    RegisterMethod(L, 'reset', @method_reset, classTable);
    RegisterMethod(L, 'clear', @method_clear, classTable);
    RegisterMethod(L, 'getattrib', @method_getattrib, classTable);
    RegisterMethod(L, 'setattrib', @method_setattrib, classTable);
  end;
  function new_callback(L: PLua_State; AParent: TLuaObject = nil): TLuaObject;
  begin
    result := TSeleniteHTMLParser.Create(L, AParent);
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

constructor TSeleniteHTMLParser.Create(LuaState: PLua_State;
  AParent: TLuaObject);
begin
  inherited Create(LuaState, AParent);
  obj := TCatHTMLParser.Create;
end;

function TSeleniteHTMLParser.GetPropValue(propName: AnsiString): Variant;
begin
  if CompareText(propName, 'pos') = 0 then
    result := obj.Pos
  else if CompareText(propName, 'tagpos') = 0 then
    result := obj.TagPos
  else if CompareText(propName, 'tagline') = 0 then
    result := obj.TagLine
  else if CompareText(propName, 'tagcontent') = 0 then
    result := obj.TextBetween
  else if CompareText(propName, 'tagname') = 0 then
    result := lowercase(obj.tag.Name)
  else
    result := inherited GetPropValue(propName);
end;

function TSeleniteHTMLParser.SetPropValue(propName: AnsiString;
  const AValue: Variant): Boolean;
begin
  result := true; // 2013
  if CompareText(propName, 'tagcontent') = 0 then
    obj.TextBetween := AnsiString(AValue)
  else if CompareText(propName, 'tagname') = 0 then
    obj.tag.Name := AnsiString(AValue)
  else
    result := inherited SetPropValue(propName, AValue);
end;

destructor TSeleniteHTMLParser.Destroy;
begin
  obj.free;
  inherited Destroy;
end;

end.
