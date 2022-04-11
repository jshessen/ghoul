/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  ghoul: string.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/ghoul

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// LibFile: string.scad
//   Functions and modules that provide string manipulations and formatting
// Includes:
//   use <ghoul/string.scad>
// FileGroup: Data Management
// FileSummary: Common string manipulation concepts
/// FileFootnotes: ???
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//  GNU GPLv3
//
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
//
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/





/*#################################################################
## Functions
##
*/
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: String deconstruction
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*#######################################################
## Function: substr()
##
*/
/// echo(help_substr()); //==>
// Usage:
//   substr(str, [start], [length])
// Description:
//   A string manipulation function that extracts characters from a string to create another string.
//   This attempts to emulate the C++ substr function

// Arguments:
//   str|str=           input character string
//   [start|start=]     integer start position of new string [default: 0]
//   [length|length=]   integer number of characters from start to include in new string

// Miscellaneous:
//   [help=true]        display this help and exit [default: false]

// Examples:
//   echo(substr("abcdefg"));
//   // Returns: "abcdefg"
//   echo(substr("abcdefg",4));
//   // Returns: "efg"
//   echo(substr("abcdefg",length=4));
//   // Returns: "abcde"

// Aliases: substring()
/*
##
#######################################################*/
function substr(str="", start=0, length,     help=false) = (
    (help)
    ?   help_substr()
    :   let(length=(!is_undef(length))?length:len(str)-1)
        (start <= length)
        ?   str(str[start],substr(str, start + 1, length))
        :   ""    
);
function substring(str,start,length,    help) = substr(str,start,length,    help);

function help_substr() = (
    let(usage=str("substr(str, [start], [length])"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that extracts characters from a string to create another string","\n",
        prefix,indent,      "This attempts to emulate the C++ substr function","\n","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        prefix,indent,      "[start|start=]     integer start position of new string [default: 0]","\n",
        prefix,indent,      "[length|length=]   integer number of characters from start to include in new string","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(substr(\"abcdefg\"));",           "\n",
        prefix,indent,prefix,   "Returns: \"abcdefg\"",             "\n",
        prefix,indent,      "echo(substr(\"abcdefg\",4));",         "\n",
        prefix,indent,prefix,   "Returns: \"efg\"",                 "\n",
        prefix,indent,      "echo(substr(\"abcdefg\",length=4));",  "\n",
        prefix,indent,prefix,   "Returns: \"abcde\"",               "\n",
        "\n",
        prefix,         "Aliases: substring()",                     "\n",
        "\n"
        )
    )
    help_text
);



//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: String transformation
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*#######################################################
## Function: trim()
##
*/
/// echo(help_trim()); //==>
// Usage:
//   trim(str)
// Description:
//   A string manipulation function that removes leading and trailing spaces from string
// Arguments:
//   str|str=           input character string
// Miscellaneous:
//   [help=true]        display this help and exit [default: false]

// Examples:
//   echo(trim("  A quick brown fox    "));
//   // Returns: "A quick brown fox"
/*
##
#######################################################*/
function trim(str,  help=false) = (
    (help)
    ?   help_trim()
    :   let(i=len(str)-1)
        (str[0] == " ")
        ?   trim(substr(str,1))
        :   (str[i] == " ")
            ?   trim(substr(str, 0, i-1))
            :   str
);

function help_trim() = (
    let(usage=str("trim(str)"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that removes leading and trailing spaces from string","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(trim(\"  A quick brown fox    \"));",           "\n",
        prefix,indent,prefix,   "Returns: \"A quick brown fox\"",                 "\n"
        )
    )
    help_text
);
/*#######################################################
## Function: pad()
##
*/
/// echo(help_pad()); //==>
// Usage:
//   pad(str,length,char)
// Description:
//   A string manipulation function that adds characters to a string up to a given length
// Arguments:
//   str|str=           input character string
//   length|length=     total characters
//   char|char=         character to "pad" the original string up to a given length
// Miscellaneous:
//   [help=true]        display this help and exit [default: false]

// Examples:
//   echo(pad("abcdef",5,"~"));
//   // Returns: "abcdef"
//   echo(pad("abcdef",15,"~"));
//   // Returns: "~~~~~~~~~~abcdef"

// Aliases: lpad(), rpad
/*
##
#######################################################*/
function pad(str,length,char,   help=false) = (
    (help)
    ?   help_pad()
    :   let(str=str(str))
        let(char=(!is_undef(char))?char:" ")
        (len(str) > length)
        ?   str
        :   pad(str(char,str),length,char)
);
function lpad(str,length,char,  help) = pad(str,length,char,    help);
function rpad(str,length,char,  help) = str(str,pad("",length-len(str),char),   help);

function help_pad() = (
    let(usage=str("pad(str,length,char)"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that adds characters to a string up to a given length","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        prefix,indent,      "length|length=     total characters","\n",
        prefix,indent,      "char|char=         character to \"pad\" the original string up to a given length","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(pad(\"abcdef\",5,\"~\"));",       "\n",
        prefix,indent,prefix,   "Returns: \"abcdef\"",              "\n",
        prefix,indent,      "echo(pad(\"abcdef\",15,\"~\"));",      "\n",
        prefix,indent,prefix,   "Returns: \"~~~~~~~~~~abcdef\"",    "\n",
        "\n",
        prefix,         "Aliases: lpad(), rpad",                    "\n"
        )
    )
    help_text
);
/*#######################################################
## Function: toupper()
##
*/
/// echo(help_toupper()); //==>
// Usage:
//   toupper(str)
// Description:
//   A string manipulation function that converts string to all uppercase equivalent
// Arguments:
//   str|str=           input character string

// Miscellaneous:
//   [help=true]        display this help and exit [default: false]

// Examples:
//   echo(toupper("aCucdEF,GUHK%"));
//   // Returns: "ACUCDEF,GUHK%"
/*
##
#######################################################*/
function toupper(str,   help=false) = (
    (help)
    ?   help_toupper()
    :   chr([for(i=str)
                let(int=ord(i))
                if(65<=int && int<=90) int //Latin Capital/Upper Letters (do nothing)
                else if(97<=int && int<=122) int-32 //Latin Small/Lower Letters (shift)
                else int
            ])
);

function help_toupper() = (
    let(usage=str("toupper(str)"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that converts string to all uppercase equivalent","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(toupper(\"aCucdEF,GUHK%\"));",    "\n",
        prefix,indent,prefix,   "Returns: \"ACUCDEF,GUHK%\"",       "\n"
        )
    )
    help_text
);
/*#######################################################
## Function: toupper()
##
*/
/// echo(help_tolower()); //==>
// Usage:
//   tolower(str)
// Description:
//   A string manipulation function that converts string to all lowercase equivalent
// Arguments:
//   str|str=           input character string

// Miscellaneous:
//   [help=true]        display this help and exit [default: false]

// Examples:
//   echo(tolower("aCucdEF,GUHK%"));
//   // Returns: "acucdef,guhk%"
/*
##
#######################################################*/
function tolower(str,   help=false) = (
    (help)
    ?   help_tolower()
    :   chr([for(i=str)
                let(int=ord(i))
                if(97<=int && int<=122) int //Latin Small/Lower Letters (do nothing)
                else if(65<=int && int<=90) int+32 //Latin Capital/Upper Letters (shift)
                else int
            ])
);
                
function help_tolower() = (
    let(usage=str("tolower(str)"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that converts string to all lowercase equivalent","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(tolower(\"aCucdEF,GUHK%\"));",    "\n",
        prefix,indent,prefix,   "Returns: \"acucdef,guhk%\"",       "\n"
        )
    )
    help_text
);



//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: String conversion
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*#######################################################
## Function: strtod()
##
*/
/// echo(help_strtod()); //==>
// Usage:
//   strtod(str)
// Description:
//   A string manipulation function that emulats the C++ strtod
//   Converts string to number (integer/float/double)
// Arguments:
//   str|str=           input character string

// Miscellaneous:
//   [help=true]        display this help and exit [default: false]
// *Recursion Parameters:
//   i      (len(number-1)   index variable to faciliate tail recursion
//   number (0)              return value

// Examples:
//   echo(strtod("1.123456789"));
//   // Returns: 1.12346
//   echo(strtod("-3451.77834","));
//   // Returns: -3451.78
//   echo(strtod("+45.77834"));
//   // Returns: 45.7783
//   echo(strtod("1.12346e-2"));
//   // Returns: 0.000112346
//   echo(strtod("-3.45178e+7"));
//   // Returns: -3451.78

// Aliases: string_to_double(), str_to_d(
/*
##
#######################################################*/
function strtod(str, i, number=0,    help=false) = (
    (help)
    ?   help_strtod()
    :   let(i=(!is_undef(i)) ? i : len(str)-1)
            (i<0)
            ?   number                                                              // Return "number"
            :   let(unicode=ord(str[i]))
                (48<=unicode && unicode<=57)                                        // 0-9
                ?   strtod(str, i-1, number+((unicode-48)*pow(10,len(str)-1-i))) :
                (unicode==46)                                                       // "."
                ?   strtod(str, i-1, number*10)*pow(10,(-1)*len(str)-i) :                // Set decimal
                (unicode==45)                                                       // "-"
                ?   (i==0)
                    ?   (-1)*number                                                 // Apply negative sign
                    :   (ord(str[i-1])==101)                                        // "e-"
                        ? strtod(str, i-2, 0)*pow(10,(-1)*number)
                        : undef :
                (unicode==43)                                                       // "+"
                ?   (i==0)
                    ?   number                                                      // Apply negative sign
                    :   (ord(str[i-1])==101)                                        // "e+"
                        ? strtod(str, i-2, 0)*pow(10,number)
                        : undef
                : undef                
);
function string_to_double(str,  help) = strtod(str, help);
function str_to_d(str, help) = strtod(str, help);

function help_strtod() = (
    let(usage=str("strtod(str)"))
    let(prefix="// ")
    let(indent="  ")
    let(help_text=str("\n",
        prefix,         "Usage:",                                   "\n",
        prefix,indent,      usage,                                  "\n",
        prefix,         "Description:",                             "\n",
        prefix,indent,      "A string manipulation function that emulats the C++ strtod","\n",
        prefix,indent,      "Converts string to number (integer/float/double)","\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        "\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n",
        prefix,         "*Recursion Parameters:",                   "\n",
        prefix,indent,      "i      (len(number-1)   index variable to faciliate tail recursion","\n",
        prefix,indent,      "number (0)              return value","\n",
        "\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(strtod(\"1.123456789\"));",       "\n",
        prefix,indent,prefix,   "Returns: 1.12346",                 "\n",
        prefix,indent,      "echo(strtod(\"-3451.77834\",\"));",    "\n",
        prefix,indent,prefix,   "Returns: -3451.78",                "\n",
        prefix,indent,      "echo(strtod(\"+45.77834\"));",         "\n",
        prefix,indent,prefix,   "Returns: 45.7783",                 "\n",
        prefix,indent,      "echo(strtod(\"1.12346e-2\"));"  ,      "\n",
        prefix,indent,prefix,   "Returns: 0.000112346",             "\n",
        prefix,indent,      "echo(strtod(\"-3.45178e+7\"));",       "\n",
        prefix,indent,prefix,   "Returns: -3451.78",                "\n",
        "\n",
        prefix,         "Aliases: string_to_double(), str_to_d()",  "\n"
        )
    )
    help_text
);
/*
#################################################################*/