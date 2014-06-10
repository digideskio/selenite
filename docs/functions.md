## File System Functions

### File Functions (slx.file.*)

* **canopen** ( filename ): Returns true if a file can be opened. If the file is locked, returns false.
* **copy** ( source, dest ): Copies a file to a new file.
* **delete** ( filename ): Deletes a file.
* **exec** ( filename ): Executes a file.
* **exechide** ( filename ): Executes a file in hidden state.
* **exists** ( filename ): Returns true if a file exists, and false otherwise.
* **getcontents** ( filename ): Returns the contents of a local file.
* **getext** ( filename ): Gets the extension part of a filename.
* **getname** ( filename ): Gets the name and extension part of a filename.

### Directory Functions (slx.dir.*)

* **create** ( dirname ): Recursively creates a directory.
* **delete** ( dirname ): Deletes a directory and its subdirectories.
* **getdirlist** ( dirname ): Returns the list of sub directories of a directory.
* **getfilelist** ( dirname ): Returns the list of files of a directory.

## String Operations (slx.string.*)

* **after** ( s, sub ): Returns the portion of the string after a specific sub-string.
* **before** ( s, sub ): Returns the portion of the string before a specific sub-string.
* **between** ( s, start, stop ): Returns a string between 2 strings.
* **gettoken** ( s, delim, int ): Returns what comes after a delimiter.
* **lastchar** ( s ): Returns the last character of a string.
* **occur** ( s, sub ): Returns the count of the occurrence of a particular string or character.
* **random** ( int ): Returns a random string that is the length of your choosing.
* **replace** ( s, find, rep ): Replaces a string. 
* **stripquotes** ( s ): Returns a string with removed quotes.
* **trim** ( s ): Returns a string without redundant whitespace.

### String Matching Functions

* **beginswith** ( s, prefix ): Checks if a string begins with a specific string.
* **endswith** ( s, termination ): Checks if a string ends with a string.
* **ishex** ( s ): Checks if a string is a hexadecimal representation.
* **isint** ( s ): Checks if a string is integer.
* **match** ( s, pattern ): Wildcard matching (* and ?).

These will return a boolean value.

### String Classes

* **list**: Returns a stringlist object (see `classes.stringlist.md`).
* **loop**: Returns a stringloop object (see `classes.stringloop.md`).

## Regular Expression Functions (slx.re.*)

* **find** ( s, regex): Regular expression finder. Returns a string.
* **match** ( s, regex): Returns true if it matches a regular expression, false otherwise.
* **replace** ( s, regex, rep ): Finds a string using a regular expression and replaces it. Returns a new string.

## Web Functions

### HTML Functions (slx.html.*)

* **escape** ( s ): Escapes HTML tag characters.
* **gettagcontents** ( html, tag ): Extracts the content of HTML tags.
* **parser**: Returns a HTML parser object (see `classes.htmlparser.md`).
* **striptags** ( s ): Removes tags from a string.
* **unescape** ( s ): Unescapes HTML tag characters.

### URL Functions (slx.url.*)

* **changepath** ( url, newpath ): Changes the path of an URL.
* **combine** ( url, path ): Combines a path to a URL.
* **crack** ( url ) : Returns the main components of an URL as a table.
 * fileext - filename extension (eg: .lp)
 * filename - filename (eg: index.lp)
 * host - host name (eg: www.lua.org)
 * path - location (eg: demo/index.lp)
 * port - port number (eg: 80)
 * proto - protocol (eg: https)
* **decode** ( s ): Decodes an URL.
* **encode** ( s ): Encodes an URL.
* **encodefull** ( s ): Full URL Encode.
* **genfromhost** ( hostname , port ): Generates an URL from a hostname and a port.
* **getfileext** ( url ): Returns the extension from an URL filename.
* **getfilename** ( url ): Returns the URL filename.

### JSON Functions (slx.json.*)

* **object**: Returns a JSON object (see `classes.jsonobject.md`).

### HTTP Functions (slx.http.*)

* **crackrequest** ( headers ): Returns the main components of the headers of a HTTP request as a table.
 * data - Request/POST data (if any)
 * method' - Request method (GET, POST, HEAD, etc...)
 * path - URL path
* **getheader** ( headers, fieldname ): Returns the value of a header field.

## Miscellaneous

### Net Functions (slx.net.*)

* **nametoip** ( name ): Converts host name to IP address.
* **iptoname** ( ip ): Converts IP address to host name.

### Base64 Functions (slx.base64.*)

* **encode** ( s ): Returns a string converted to a base64 string.
* **decode** ( s ): Converts a base64 string to a string.

### Conversion Functions (slx.convert.*)

* **commastrtostr** ( s ): Converts a comma string to a string.
* **strtoalphanum** ( s ): Converts a string to alphanumeric string.
* **strtocommastr** ( s ): Converts a string to a comma string.
* **strtohex** ( s ): Converts a string to a hexadecimal string.
* **hextoint** ( s ): Converts a hex string to integer.
* **hextostr** ( s ): Converts a hexadecimal string to string.

### Crypto Functions (slx.crypto.*)

* **md5** ( s ): Returns the MD5 hash of a given string.
* **sha1** ( s ): Returns the SHA-1 hash of a given string.

### Task Functions (slx.task.*)

* **isrunning** ( exefilename ): Returns true if a process is running, false otherwise.
* **kill** ( exefilename ): Closes a running process by its executable name.

### Utils (slx.utils.*)

* **delay** ( ms ): Waits a specific number of milliseconds before proceeding.