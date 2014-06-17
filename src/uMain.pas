unit uMain;

{
  Selenite Lua Library
  Copyright (c) 2013-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
{$IF CompilerVersion >= 23} // XE2 or higher
  Winapi.Windows, System.Classes, System.SysUtils, Winapi.ShellAPI,
{$ELSE}
  Windows, Classes, SysUtils, ShellAPI,
{$IFEND}
  Lua;

function RegisterSelenite(L: plua_State):integer; cdecl;

implementation

uses
  pLua, uFunctions, uStrList, uStrListParser, uHTMLParser, uJSON,
  uTarman, CatStrings;

function RegisterSelenite(L: plua_State):integer; cdecl;
const
 coreop_table : array[0..0] of luaL_reg =
 (
 (name:nil;func:nil)
 );
const
 base64_table : array[1..3] of luaL_reg =
(
 (name:'encode';func:str_base64enc),
 (name:'decode';func:str_base64dec),
 (name:nil;func:nil)
 );
const
 convert_table : array[1..8] of luaL_reg =
(
 (name:'commastrtostr';func:conv_commatexttostr),
 (name:'hextoint';func:conv_hextoint),
 (name:'hextostr';func:conv_hextostr),
 (name:'inttohex';func:conv_inttohex),
 (name:'strtoalphanum';func:str_toalphanum),
 (name:'strtohex';func:conv_strtohex),
 (name:'strtocommastr';func:conv_strtocommatext),
 (name:nil;func:nil)
 );
const
 crypto_table : array[1..3] of luaL_reg =
(
 (name:'md5';func:conv_strtomd5),
 (name:'sha1';func:conv_strtosha1),
 (name:nil;func:nil)
 );
const
 dir_table : array[1..7] of luaL_reg =
(
 (name:'create';func:file_mkdir),
 (name:'delete';func:file_deldir),
 (name:'getdirlist';func:file_getdirs),
 (name:'getfilelist';func:file_getdirfiles),
 (name:'packtotar';func:Lua_DirToTAR),
 (name:'unpackfromtar';func:Lua_TARToDir),
 (name:nil;func:nil)
 );
const
 file_table : array[1..11] of luaL_reg =
(
 (name:'canopen';func:file_canopen),
 (name:'copy';func:file_copy),
 (name:'delete';func:file_delete),
 (name:'exec';func:file_exec),
 (name:'exechide';func:file_exechidden),
 (name:'exists';func:file_exists),
 (name:'getcontents';func:file_gettostr),
 (name:'getname';func:file_extractname),
 (name:'getext';func:file_getext),
 (name:'getver';func:file_getversion),
 (name:nil;func:nil)
 );
const
  html_table : array[1..7] of luaL_reg =
(
 (name:'beautifycss';func:str_beautifycss),
 (name:'beautifyjs';func:str_beautifyjs),
 (name:'escape';func:html_escape),
 (name:'gettagcontents';func:str_extracttagcontent),
 (name:'striptags';func:html_striptags),
 (name:'unescape';func:html_unescape),
 (name:nil;func:nil)
 );
const
  http_table : array[1..4] of luaL_reg =
(
 (name:'crackrequest';func:http_crackrequest),
 (name:'getheader';func:http_gethdrfield),
 (name:'postdatatojson';func:http_postdatatojson),
 (name:nil;func:nil)
 );
const
  json_table : array[0..0] of luaL_reg =
 (
 (name:nil;func:nil)
 );
const
  regex_table : array[1..4] of luaL_reg =
(
 (name:'find';func:str_regexfind),
 (name:'match';func:str_regexmatch),
 (name:'replace';func:str_regexreplace),
 (name:nil;func:nil)
 );
const
 string_table : array[1..20] of luaL_reg =
(
 (name:'after';func:str_after),
 (name:'before';func:str_before),
 (name:'beginswith';func:str_beginswith),
 (name:'between';func:str_between),
 (name:'decrease';func:str_decrease),
 (name:'endswith';func:str_endswith),
 (name:'gettoken';func:str_gettoken),
 (name:'increase';func:str_increase),
 (name:'ishex';func:str_ishex),
 (name:'isint';func:str_isint),
 (name:'lastchar';func:str_lastchar),
 (name:'match';func:str_wildmatch),
 (name:'occur';func:str_occur),
 (name:'random';func:str_random),
 (name:'replace';func:str_replace),
 (name:'replacefirst';func:str_replace_first),
 (name:'stripblanklines';func:str_stripblanklines),
 (name:'stripquotes';func:str_stripquotes),
 (name:'trim';func:str_trim),
 (name:nil;func:nil)
 );
const
 url_table : array[1..12] of luaL_reg =
(
 (name:'changepath';func:url_changepath),
 (name:'combine';func:url_combine),
 (name:'crack';func:url_crack),
 (name:'decode';func:url_decode),
 (name:'encode';func:url_encode),
 (name:'encodefull';func:url_encodefull),
 (name:'fileurltofilename';func:file_fileurltofilename),
 (name:'genfromhost';func:hostporttourl),
 (name:'getfileext';func:url_getfileext),
 (name:'getfilename';func:url_getfilename),
 (name:'gettiny';func:url_gettiny),
// replaced by url_crack
// (name:'gethost';func:url_gethost),
// (name:'getpath';func:url_getpath),
// (name:'getport';func:url_getport),
 (name:nil;func:nil)
 );
 net_table : array[1..3] of luaL_reg =
(
 (name:'nametoip';func:net_nametoip),
 (name:'iptoname';func:net_iptoname),
 (name:nil;func:nil)
 );
 task_table : array[1..3] of luaL_reg =
(
 (name:'isrunning';func:task_isrunning),
 (name:'kill';func:task_kill),
 (name:nil;func:nil)
 );
 utils_table : array[1..3] of luaL_reg =
(
 (name:'delay';func:utils_delay),
 (name:'hassoftware';func:utils_hassoftwareinstalled),
 (name:nil;func:nil)
 );
 const init=
 'slx.html.parser = sel_htmlparser'+crlf+
 'slx.string.loop = sel_listparser'+crlf+
 'slx.string.list = sel_stringlist'+crlf+
 'slx.json.object = sel_json';
 procedure AddTable(L:plua_State;name:string;table:plual_reg);
 begin
  lua_newtable(L);
  lual_register(L,nil,table);
  lua_setfield(L, -2,name);
 end;
begin
 lual_register(L,'slx',@coreop_table);
 AddTable(L,'base64',@base64_table);
 AddTable(L,'convert',@convert_table);
 AddTable(L,'crypto',@crypto_table);
 AddTable(L,'dir',@dir_table);
 AddTable(L,'file',@file_table);
 AddTable(L,'html',@html_table);
 AddTable(L,'http',@http_table);
 AddTable(L,'json',@json_table);
 AddTable(L,'net',@net_table);
 AddTable(L,'string',@string_table);
 AddTable(L,'task',@task_table);
 AddTable(L,'url',@url_table);
 AddTable(L,'utils',@utils_table);
 AddTable(L,'re',@regex_table);
 RegisterSeleniteStrList(L);
 RegisterSeleniteStrListParser(L);
 RegisterSeleniteHTMLParser(L);
 RegisterSeleniteJSON(L);
 plua_dostring(L, init);
 Result := 0;
end;

end.

