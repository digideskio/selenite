unit uFunctions;

{
  Selenite Lua Library
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
{$IF CompilerVersion >= 23} // XE2 or higher
  Winapi.Windows, System.Classes, System.SysUtils, Winapi.ShellAPI,
  System.Win.Registry,
{$ELSE}
  Windows, Classes, SysUtils, ShellAPI, Registry,
{$IFEND}
  Lua;

function str_beginswith(L: plua_State): integer; cdecl;
function str_endswith(L: plua_State): integer; cdecl;
function str_regexfind(L: plua_State): integer; cdecl;
function str_regexreplace(L: plua_State): integer; cdecl;
function str_regexmatch(L: plua_State): integer; cdecl;
function str_base64enc(L: plua_State): integer; cdecl;
function str_base64dec(L: plua_State): integer; cdecl;
function str_trim(L: plua_State): integer; cdecl;
function str_after(L: plua_State): integer; cdecl;
function str_before(L: plua_State): integer; cdecl;
function str_random(L: plua_State): integer; cdecl;
function str_lastchar(L: plua_State): integer; cdecl;
function str_extracttagcontent(L: plua_State): integer; cdecl;
function str_gettoken(L: plua_State): integer; cdecl;
function str_replace(L: plua_State): integer; cdecl;
function str_replace_first(L: plua_State): integer; cdecl;
function str_between(L: plua_State): integer; cdecl;
function str_ishex(L: plua_State): integer; cdecl;
function str_isint(L: plua_State): integer; cdecl;
function str_occur(L: plua_State): integer; cdecl;
function str_wildmatch(L: plua_State): integer; cdecl;
function str_toalphanum(L: plua_State): integer; cdecl;
function str_beautifyjs(L: plua_State): integer; cdecl;
function str_beautifycss(L: plua_State): integer; cdecl;
function str_stripquotes(L: plua_State): integer; cdecl;
function str_stripblanklines(L: plua_State): integer; cdecl;
function str_increase(L: plua_State): integer; cdecl;
function str_decrease(L: plua_State): integer; cdecl;

function file_getdirfiles(L: plua_State): integer; cdecl;
function file_getdirs(L: plua_State): integer; cdecl;
function file_extractname(L: plua_State): integer; cdecl;
function file_getext(L: plua_State): integer; cdecl;
function file_getversion(L: plua_State): integer; cdecl;
function file_exists(L: plua_State): integer; cdecl;
function file_canopen(L: plua_State): integer; cdecl;
function file_mkdir(L: plua_State): integer; cdecl;
function file_copy(L: plua_State): integer; cdecl;
function file_gettostr(L: plua_State): integer; cdecl;
function file_exec(L: plua_State): integer; cdecl;
function file_exechidden(L: plua_State): integer; cdecl;
function file_delete(L: plua_State): integer; cdecl;
function file_deldir(L: plua_State): integer; cdecl;
function file_fileurltofilename(L: plua_State): integer; cdecl;

function url_crack(L: plua_State): integer; cdecl;
function url_getfilename(L: plua_State): integer; cdecl;
function url_getfileext(L: plua_State): integer; cdecl;
function url_encode(L: plua_State): integer; cdecl;
function url_encodefull(L: plua_State): integer; cdecl;
function url_decode(L: plua_State): integer; cdecl;
function url_gethost(L: plua_State): integer; cdecl;
function url_getpath(L: plua_State): integer; cdecl;
function url_combine(L: plua_State): integer; cdecl;
function url_getport(L: plua_State): integer; cdecl;
function url_gettiny(L: plua_State): integer; cdecl;
function url_changepath(L: plua_State): integer; cdecl;

function conv_inttohex(L: plua_State): integer; cdecl;
function conv_hextoint(L: plua_State): integer; cdecl;
function conv_hextostr(L: plua_State): integer; cdecl;
function conv_strtohex(L: plua_State): integer; cdecl;
function conv_strtomd5(L: plua_State): integer; cdecl;
function conv_strtosha1(L: plua_State): integer; cdecl;
function conv_strtocommatext(L: plua_State): integer; cdecl;
function conv_commatexttostr(L: plua_State): integer; cdecl;

function html_escape(L: plua_State): integer; cdecl;
function html_unescape(L: plua_State): integer; cdecl;
function html_striptags(L: plua_State): integer; cdecl;

function http_crackrequest(L: plua_State): integer; cdecl;
function http_postdatatojson(L: plua_State): integer; cdecl;
function http_gethdrfield(L: plua_State): integer; cdecl;

function net_iptoname(L: plua_State): integer; cdecl;
function net_nametoip(L: plua_State): integer; cdecl;

function task_isrunning(L: plua_State): integer; cdecl;
function task_kill(L: plua_State): integer; cdecl;

function hostporttourl(L: plua_State): integer; cdecl;

function utils_delay(L: plua_State): integer; cdecl;
function utils_hassoftwareinstalled(L: plua_State): integer; cdecl;

implementation

uses
  pLua, ExtPascalUtils, synacode,
  uStrList, uStrListParser, uHTMLParser, uJSON, uTarman,
  CatStrings, CatLuaUtils, CatJSON, CatRegex, CatFiles, CatHTTP, CatUtils,
  CatInet, CatTasks;

function str_beginswith(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, beginswith(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_endswith(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, endswith(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_regexfind(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, RegExpFind(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_regexreplace(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, RegExpReplace(lua_tostring(L, 1), lua_tostring(L, 2),
    lua_tostring(L, 3)));
  result := 1;
end;

function str_regexmatch(L: plua_State): integer; cdecl;
begin
  if RegExpFind(lua_tostring(L, 1), lua_tostring(L, 2)) <> '' then
    lua_pushboolean(L, true)
  else
    lua_pushboolean(L, false);
  result := 1;
end;

function str_base64enc(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, Base64Encode(lua_tostring(L, 1)));
  result := 1;
end;

function str_base64dec(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, Base64Decode(lua_tostring(L, 1)));
  result := 1;
end;

function str_trim(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, trim(lua_tostring(L, 1)));
  result := 1;
end;

function str_after(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, after(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_before(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, before(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_random(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, RandomString(lua_tointeger(L, 1)));
  result := 1;
end;

function str_lastchar(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, lastchar(lua_tostring(L, 1)));
  result := 1;
end;

function str_extracttagcontent(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, extractfromtag(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function file_gettostr(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, getfiletostr(lua_tostring(L, 1)));
  result := 1;
end;

function str_gettoken(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, gettoken(lua_tostring(L, 1), lua_tostring(L, 2),
    lua_tointeger(L, 3)));
  result := 1;
end;

function str_replace(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, replacestr(lua_tostring(L, 1), lua_tostring(L, 2),
    lua_tostring(L, 3)));
  result := 1;
end;

function str_replace_first(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, stringreplace(lua_tostring(L, 1), lua_tostring(L, 2),
    lua_tostring(L, 3), []));
  result := 1;
end;

function str_between(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, ExtractFromString(lua_tostring(L, 1), lua_tostring(L, 2),
    lua_tostring(L, 3)));
  result := 1;
end;

function utils_delay(L: plua_State): integer; cdecl;
begin
  CatDelay(lua_tointeger(L, 1));
  result := 1;
end;

function url_crack(L: plua_State): integer; cdecl;
var
  url: TURLParts;
begin
  lua_newtable(L);
  url := CrackURL(lua_tostring(L, 1));
  pLua_SetFieldStr(L, 'fileext', url.fileext);
  pLua_SetFieldStr(L, 'filename', url.filename);
  pLua_SetFieldStr(L, 'host', url.host);
  pLua_SetFieldStr(L, 'path', url.path);
  pLua_SetFieldInt(L, 'port', url.port);
  pLua_SetFieldStr(L, 'proto', url.protocol);
  result := 1;
end;

function url_getfilename(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, ExtractUrlFileName(lua_tostring(L, 1)));
  result := 1;
end;

function url_getfileext(L: plua_State): integer; cdecl;
var
  ext: string;
begin
  ext := ExtractUrlFileExt(lua_tostring(L, 1));
  if lua_isnone(L, 2) = false then
  begin
    if lua_toboolean(L, 2) = false then
    begin
      if beginswith(ext, '.') then
        ext := after(ext, '.');
    end;
  end;
  plua_pushstring(L, ext);
  result := 1;
end;

function html_escape(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, CatHTTP.htmlescape(lua_tostring(L, 1)));
  result := 1;
end;

function html_unescape(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, CatHTTP.htmlunescape(lua_tostring(L, 1)));
  result := 1;
end;

function html_striptags(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, StripHtml(lua_tostring(L, 1)));
  result := 1;
end;

function str_stripquotes(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, RemoveQuotes(lua_tostring(L, 1)));
  result := 1;
end;

function str_stripblanklines(L: plua_State): integer; cdecl;
var
  sl: tstringlist;
  s: string;
begin
  sl := tstringlist.create;
  sl.text := lua_tostring(L, 1);
  StripBlankLines(sl);
  s := sl.text;
  sl.Free;
  plua_pushstring(L, s);
  result := 1;
end;

function url_encode(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, URLencode(lua_tostring(L, 1), lua_toboolean(L, 2)));
  result := 1;
end;

function url_encodefull(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, URLencodefull(lua_tostring(L, 1)));
  result := 1;
end;

function url_decode(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, URLDecode(lua_tostring(L, 1)));
  result := 1;
end;

function url_gethost(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, ExtractUrlHost(lua_tostring(L, 1)));
  result := 1;
end;

function url_getpath(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, ExtractUrlPath(lua_tostring(L, 1)));
  result := 1;
end;

function url_combine(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, getabsoluteurl(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function url_getport(L: plua_State): integer; cdecl;
begin
  lua_pushinteger(L, extracturlport(lua_tostring(L, 1)));
  result := 1;
end;

function net_iptoname(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, IPAddrToName(lua_tostring(L, 1)));
  result := 1;
end;

function net_nametoip(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, NameToIPAddr(lua_tostring(L, 1)));
  result := 1;
end;

function conv_inttohex(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, IntToHex(lua_tointeger(L, 1), 1));
  result := 1;
end;

function conv_hextoint(L: plua_State): integer; cdecl;
begin
  lua_pushinteger(L, HexToInt(lua_tostring(L, 1)));
  result := 1;
end;

function str_ishex(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, IsHexStr(lua_tostring(L, 1)));
  result := 1;
end;

function str_isint(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, IsInteger(lua_tostring(L, 1)));
  result := 1;
end;

function str_occur(L: plua_State): integer; cdecl;
begin
  lua_pushinteger(L, Occurs(lua_tostring(L, 2), lua_tostring(L, 1)));
  result := 1;
end;

function str_wildmatch(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, MatchStrings(lua_tostring(L, 1), lua_tostring(L, 2)));
  result := 1;
end;

function str_toalphanum(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, StrToAlphaNum(lua_tostring(L, 1)));
  result := 1;
end;

function conv_hextostr(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, HexToStr(lua_tostring(L, 1)));
  result := 1;
end;

function conv_strtohex(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, StrToHex(lua_tostring(L, 1)));
  result := 1;
end;

function conv_strtomd5(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, MD5hash(lua_tostring(L, 1)));
  result := 1;
end;

function conv_strtosha1(L: plua_State): integer; cdecl;
  function StrToHex(const Value: AnsiString): string;
  var
    n: integer;
  begin
    result := '';
    for n := 1 to Length(Value) do
      result := result + IntToHex(Byte(Value[n]), 2);
  end;

begin
  plua_pushstring(L, lowercase(StrToHex(SHA1(lua_tostring(L, 1)))));
  result := 1;
end;

function conv_strtocommatext(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, StrToCommaText(lua_tostring(L, 1)));
  result := 1;
end;

function conv_commatexttostr(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, CommaTextToStr(lua_tostring(L, 1)));
  result := 1;
end;

function file_getversion(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, GetFileVersion(lua_tostring(L, 1)));
  result := 1;
end;

function file_getdirfiles(L: plua_State): integer; cdecl;
var
  d: string;
  function getdirfiles(dir: string): string;
  var
    list: tstringlist;
  begin
    list := tstringlist.create;
    getfiles(dir, list);
    result := list.text;
    list.Free;
  end;

begin
  d := getdirfiles(lua_tostring(L, 1));
  plua_pushstring(L, d);
  result := 1;
end;

function file_getdirs(L: plua_State): integer; cdecl;
  function GetDirs(dir: widestring): widestring; StdCall;
  var
    search: TSearchRec;
    ts: tstringlist;
    resultstr: string;
  begin
    ts := tstringlist.create;
    try
      if FindFirst(dir + '*.*', faDirectory, search) = 0 then
      begin
        repeat
          if ((search.Attr and faDirectory) = faDirectory) and
            (search.Name <> '.') and (search.Name <> '..') then
            ts.Add(search.Name);
        until FindNext(search) <> 0;
        FindClose(search);
      end;
      ts.sort;
      resultstr := ts.text;
    finally
      ts.Free;
    end;
    result := resultstr;
  end;

var
  d: string;
begin
  d := GetDirs(lua_tostring(L, 1));
  plua_pushstring(L, d);
  result := 1;
end;

function file_extractname(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, extractfilename(lua_tostring(L, 1)));
  result := 1;
end;

function file_getext(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, extractfileext(lua_tostring(L, 1)));
  result := 1;
end;

function file_exists(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, fileexists(lua_tostring(L, 1)));
  result := 1;
end;

function file_canopen(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, filecanbeopened(lua_tostring(L, 1)));
  result := 1;
end;

function file_mkdir(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, ForceDir(lua_tostring(L, 1)));
  result := 1;
end;

function file_copy(L: plua_State): integer; cdecl;
begin
  FileCopy(lua_tostring(L, 1), lua_tostring(L, 2));
  result := 1;
end;

function file_exec(L: plua_State): integer; cdecl;
var
  DocFileName, DocFileDir, Params: string;
begin
  DocFileName := (lua_tostring(L, 1));
  DocFileDir := ExtractFileDir(DocFileName);
  Params := lua_tostring(L, 2);
  if lua_isnone(L, 3) = false then
    DocFileDir := lua_tostring(L, 3);
  ShellExecute(0, nil, pWideChar(DocFileName), pWideChar(Params),
    pWideChar(DocFileDir), SW_SHOWNORMAL);
  result := 1;
end;

function file_exechidden(L: plua_State): integer; cdecl;
var
  DocFileName, DocFileDir, Params: string;
begin
  DocFileName := (lua_tostring(L, 1));
  DocFileDir := ExtractFileDir(DocFileName);
  Params := lua_tostring(L, 2);
  if lua_isnone(L, 3) = false then
    DocFileDir := lua_tostring(L, 3);
  ShellExecute(0, nil, pWideChar(DocFileName), pWideChar(Params),
    pWideChar(DocFileDir), SW_HIDE);
  result := 1;
end;

function file_delete(L: plua_State): integer; cdecl;
begin
  DeleteFile(lua_tostring(L, 1));
  result := 1;
end;

function file_deldir(L: plua_State): integer; cdecl;
begin
  DeleteFolder(lua_tostring(L, 1));
  result := 1;
end;

function file_fileurltofilename(L: plua_State): integer; cdecl;
var
  f: string;
begin
  f := lua_tostring(L, 1);
  f := after(f, 'file://');
  f := replacestr(f, '/', '\\');
  plua_pushstring(L, f);
  result := 1;
end;

function hostporttourl(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, generateurl(lua_tostring(L, 1), lua_tointeger(L, 2)));
  result := 1;
end;

function http_crackrequest(L: plua_State): integer; cdecl;
var
  request: THTTPRequestParts;
begin
  lua_newtable(L);
  request := CrackHTTPRequest(lua_tostring(L, 1));
  pLua_SetFieldStr(L, 'method', request.method);
  pLua_SetFieldStr(L, 'path', request.path);
  pLua_SetFieldStr(L, 'data', request.Data);
  result := 1;
end;

function http_postdatatojson(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, postdatatojson(lua_tostring(L, 1)));
  result := 1;
end;

function http_gethdrfield(L: plua_State): integer; cdecl;
var
  s: string;
begin
  s := getfield(lua_tostring(L, 2), lua_tostring(L, 1));
  s := trim(s);
  plua_pushstring(L, s);
  result := 1;
end;

function str_increase(L: plua_State): integer; cdecl;
var
  s: string;
  step: integer;
begin
  step := 1;
  if lua_isnone(L, 2) = false then
    step := lua_tointeger(L, 2);
  s := strincrease(lua_tostring(L, 1), step);
  plua_pushstring(L, s);
  result := 1;
end;

function url_gettiny(L: plua_State): integer; cdecl;
var
  s: string;
begin
  s := lua_tostring(L, 1);
  try
    s := gettinyurl(s);
  except
  end;
  plua_pushstring(L, s);
  result := 1;
end;

function str_decrease(L: plua_State): integer; cdecl;
var
  s: string;
  step: integer;
begin
  step := 1;
  if lua_isnone(L, 2) = false then
    step := lua_tointeger(L, 2);
  s := strdecrease(lua_tostring(L, 1), step);
  plua_pushstring(L, s);
  result := 1;
end;

function url_changepath(L: plua_State): integer; cdecl;
var
  url, oldpath, newpath: string;
begin
  url := lua_tostring(L, 1);
  oldpath := '/' + ExtractUrlPath(url);
  newpath := lua_tostring(L, 2);
  newpath := replacestr(url + ' ', oldpath + ' ', newpath);
  plua_pushstring(L, newpath);
  result := 1;
end;

function task_isrunning(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, taskrunning(lua_tostring(L, 1)));
  result := 1;
end;

function str_beautifyjs(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, BeautifyJS(lua_tostring(L, 1)));
  result := 1;
end;

function str_beautifycss(L: plua_State): integer; cdecl;
begin
  plua_pushstring(L, BeautifyCSS(lua_tostring(L, 1)));
  result := 1;
end;

function task_kill(L: plua_State): integer; cdecl;
begin
  KillEXE(lua_tostring(L, 1));
  result := 1;
end;

// Usage example: HasSoftwareInstalled('Python')
function HasSoftwareInstalled(s: string): Boolean;
var
  reg: TRegistry;
begin
  result := false;
  reg := TRegistry.create;
  try
    reg.Rootkey := HKEY_CURRENT_USER;
    if reg.OpenKey('Software\' + s, false) then
      result := true;
    reg.Rootkey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('Software\' + s, false) then
      result := true;
  finally
    reg.Free;
  end;
end;

function utils_hassoftwareinstalled(L: plua_State): integer; cdecl;
begin
  lua_pushboolean(L, HasSoftwareInstalled(lua_tostring(L, 1)));
  result := 1;
end;

end.
