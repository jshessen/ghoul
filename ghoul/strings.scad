/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  GHOUL: strings.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/GHOUL

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// LibFile: strings.scad
//   Functions and modules that provide string manipulations and formatting
/// Includes:
///   N/A
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
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: String deconstruction
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*/

/*#######################################################
## Function: substr()
##
// Function: substr()
/// echo(help_substr()); ==>
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
        prefix,indent,      "A string manipulation function that extracts characters from a string to create another string.","\n",
        prefix,indent,      "This attempts to emulate the C++ substr function","\n\n",
        prefix,         "Arguments:",                               "\n",
        prefix,indent,      "str|str=           input character string","\n",
        prefix,indent,      "[start|start=]     integer start position of new string [default: 0]","\n",
        prefix,indent,      "[length|length=]   integer number of characters from start to include in new string","\n\n",
        prefix,         "Miscellaneous:",                           "\n",
        prefix,indent,      "[help=true]        display this help and exit [default: false]","\n\n",
        prefix,         "Examples:",                                "\n",
        prefix,indent,      "echo(substr(\"abcdefg\"));",           "\n",
        prefix,indent,prefix,   "Returns: \"abcdefg\"",             "\n",
        prefix,indent,      "echo(substr(\"abcdefg\",4));",         "\n",
        prefix,indent,prefix,   "Returns: \"efg\"",                 "\n",
        prefix,indent,      "echo(substr(\"abcdefg\",length=4));",  "\n",
        prefix,indent,prefix,   "Returns: \"abcde\"",               "\n\n",
        prefix,         "Aliases: substring()")
    )
    echo(help_text)
    ""
);
/*#######################################################
## Function: trim()
##
    Description:
        A string manipulation function that removes leading and trailing spaces from string
    Parameter(s):
        (str)
            str  = Original character string
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
/*#######################################################
## Function: pad()
##
    Description:
        A string manipulation function that adds characters to a string up to a given length
    Parameter(s):
        (str, length, char)
            str  = Original character string
            length  = Total characters
            char    = Character to "pad" the original string up to a given length
##
#######################################################*/
function pad(str,length,char) = (
    (help)
    ?   help_pad()
    :   let(str=str(str))
        let(char=(!is_undef(char))?char:" ")
        (len(str) > length)
        ?   str
        :   pad(str(char,str),length,char)
);
function lpad(str,length,char) = pad(str,length,char);
function rpad(str,length,char) = str(str,pad("",length-len(str),char));

function toupper(str) = (
    (help)
    ?   help_toupper()
    :   chr([for(i=str)
                let(int=ord(i))
                if(65<=int && int<=90) int //Latin Capital/Upper Letters (do nothing)
                else if(97<=int && int<=122) int-32 //Latin Small/Lower Letters (shift)
                else undef //Not a "letter"
            ])
);

function tolower(str) = (
    (help)
    ?   help_tolower()
    :   chr([for(i=str)
                let(int=ord(i))
                if(97<=int && int<=122) int //Latin Small/Lower Letters (do nothing)
                else if(65<=int && int<=90) int+32 //Latin Capital/Upper Letters (shift)
                else undef //Not a "letter"
            ])
);
/*#######################################################
## Function: strtod()
##
    Description:
        A string manipulation function that emulats the C++ strtod
        Converts string to number (integer/float/double)
    Parameter(s):
        (str)
            str  = Original character string
    *Recursion Parameters
        i      (len(number-1)   = Index variable to faciliate tail recursion
        pos    (0)              = Position/Place of character relative to numerical decimal point
        double (0)              = Return value
##
#######################################################*/
function strtod(str, i, pos=0, double=0) = (
    (help)
    ?   help_strtod()    let(char=str[i])
    (char==" ") ? substr(str,1) :    // Remove leading whitespace
    let(i=(!is_undef(i)) ? i : len(str)-1)
    (i<0)
    ?   double                                // Return "number"
    :   (char==".")
        ?   str_to_double(str, i-1, 0, double/pow(10,pos)) // Set decimal, and reset position
        :   let(num=get_hex_digit(char))
            (num>-1)
            ?   str_to_double(str, i-1, pos+1, num*pow(10,pos)+double)
            :   num*double                    // Apply negative value
);
function string_to_double(str) = strtod(str);
/*
#################################################################*/