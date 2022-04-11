/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  ghoul: color.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/ghoul

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// LibFile: color.scad
//   Functions and modules that provide color conversions, and lookups
// Includes:
//   use <ghoul/color.scad
// FileGroup: Basic Modeling
// FileSummary: Common color conversions and definitions
/// FileFootnotes: STD=Included in std.scad
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





// GHOUL -- https://github.com/jshessen/GHOUL
include <./strings.scad>;





/*#################################################################
## Functions
##
*/
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Section: Color conversion
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*#######################################################
// Function: get_color_hex()

##
#######################################################*/
function get_color_hex(name, array) = (
    array[search([name],extended_colors)[0]][1]
);
/*#######################################################
## Function: hex2rgb()
##
    Description:
        Returns RGV Vector from Hexidecimal Code
    Parameter(s):
        (hex)
            hex  = #RRGGBB or #Rgb
##
#######################################################*/
//echo(hex2rgb("#FFD700"));   // ECHO: [255,125,0]
//echo(hex2rgb("#AF0827"));   // ECHO: [250,128,114]
function hex2rgb(hex) = (
    assert((hex[0]=="#" && len(hex)<8),"Input argement is not a valid Hexadecimal Color Code: #RRGGBB")
    (len(hex)>4)
    ?   let(r = hex2dec(concat(hex[1],hex[2])))   // 6-digit hex code
        let(g = hex2dec(concat(hex[3],hex[4])))
        let(b = hex2dec(concat(hex[5],hex[6])))
        [r,g,b]
    :   let(r = hex2dec(concat(hex[1],hex[1])))   // 3-digit hex code
        let(g = hex2dec(concat(hex[2],hex[2])))
        let(b = hex2dec(concat(hex[3],hex[3])))
        [r,g,b]
);
/*#######################################################
## Function: rgb2hex()
##
    Description:
        Returns Hexidecimal Value from RGB vector
    Parameter(s):
        (vector)
            vector  = [r,g,b]
##
#######################################################*/
function rgb2hex(vector) = (
    let(r=dec2hex(vector[0]))
    let(g=dec2hex(vector[1]))
    let(b=dec2hex(vector[2]))
    str("#",((len(r)>1) ? r : str("0",r)),
            ((len(g)>1) ? g : str("0",g)),
            ((len(b)>1) ? b : str("0",b)))
);


/*HSL color values
CSS3 adds numerical hue-saturation-lightness (HSL) colors as a complement to numerical RGB colors. It has been observed that RGB colors have the following limitations:

RGB is hardware-oriented: it reflects the use of CRTs.
RGB is non-intuitive. People can learn how to use RGB, but actually by internalizing how to translate hue, saturation and lightness, or something similar, to RGB.
There are several other color schemes possible. Some advantages of HSL are that it is symmetrical to lightness and darkness (which is not the case with HSV for example), and it is trivial to convert HSL to RGB.

HSL colors are encoding as a triple (hue, saturation, lightness).

Hue is represented as an angle of the color circle (i.e. the rainbow represented in a circle). This angle is so typically measured in degrees that the unit is implicit in CSS; syntactically, only a <number> is given. By definition red=0=360, and the other colors are spread around the circle, so green=120, blue=240, etc. As an angle, it implicitly wraps around such that -120=240 and 480=120. One way an implementation could normalize such an angle x to the range [0,360) (i.e. zero degrees, inclusive, to 360 degrees, exclusive) is to compute (((x mod 360) + 360) mod 360). Saturation and lightness are represented as percentages. 100% is full saturation, and 0% is a shade of gray. 0% lightness is black, 100% lightness is white, and 50% lightness is “normal”.*/

//echo(hsl2rgb(120, 100, 50));    // ECHO: [0,255,0]
//echo(hsl2rgb(6 , 93.2, 71.4));  // ECHO: [250,128,114]
function hsl2rgb(hue, sat, light)= (
    let(hue = ((hue % 360)+360)%360)
    let(sat = sat/100)
    let(light = light/100)
    
    let(a=sat*min(light,1-light))
    
    let(n=0)
    let(k=(n + hue/30) % 12)
    let(r=round((light -a*max(-1,min(k-3,9-k,1)))*255))
    
    let(n=8)
    let(k=(n + hue/30) % 12)
    let(g=round((light -a*max(-1,min(k-3,9-k,1)))*255))
    
    let(n=4)
    let(k=(n + hue/30) % 12)
    let(b=round((light -a*max(-1,min(k-3,9-k,1)))*255))
    
    [r,g,b]
);
/*#######################################################
## Function: to_decimal()
##
    Description:
        Returns Decimal "number" from a vector/string.
        Conversion is performed based upon a numerical "base".
    Parameter(s):
        (v)
            string  = character based hexidecimal representation
        (base) Base is the total count of digits used to express numbers
##
#######################################################*/
function to_decimal(v, base=16,  i=0,r=0) = (
    (i<len(v))
    ?   let(unicode=ord(v[i]))
        (48<=unicode && unicode<=57) ?    // 0-9
            to_decimal(v,base,  i+1,r+((unicode-48)*pow(base,i))) :
        (65<=unicode && unicode<=70) ?    // A-F
            to_decimal(v,base,  i+1,r+((unicode-55)*pow(base,i))) :
        (97<=unicode && unicode<=102) ?   // a-f
            to_decimal(v,base,  i+1,r+((unicode-87)*pow(base,i))) :
        undef
    :   r
);
/// The most commonly used base conversions are:
///     Binary number system (Base-2)
function binary_to_decimal(string) = to_decimal(string, 2);
function base2_to_10(string)    = binary_to_decimal(string);
function binTodec(string)       = binary_to_decimal(string);
function bin2dec(string)        = binary_to_decimal(string);
///     Octal number system (Base-8)
function octal_to_decimal(string) = to_decimal(string, 8);
function base8_to_10(string)    = binary_to_decimal(string);
function octTodec(string)       = binary_to_decimal(string);
function oct2dec(string)        = binary_to_decimal(string);
///     Hexadecimal number system (Base-16)
function hexidecimal_to_decimal(string) = to_decimal(string);
function base16_to_10(string)   = hexidecimal_to_decimal(string);
function hexTodec(string)       = hexidecimal_to_decimal(string);
function hex2dec(string)        = hexidecimal_to_decimal(string);
/*#######################################################
## Function: decimal_to()
##
    Description:
        Returns string representation of Decimal "number"
        Conversion is performed based upon a numerical "base".
    Parameter(s):
        (v)
            string  = character based hexidecimal representation
        (base) Base is the total count of digits used to express numbers
##
#######################################################*/
//echo(dec2bin(27));  // ECHO: "11011"
//echo(dec2oct(27));  // ECHO: "33"
//echo(dec2hex(27));  // ECHO: "1B"
function decimal_to(n, base=16,  r="") = (
    (n==0)
    ?   (r!="") ? r : "0"
    :   decimal_to(floor(n/base), base,  str([for (d="0123456789ABCDEF") d][n%base],r))
);
///     Binary number system (Base-2)
function decimal_to_binary(n) = decimal_to(n, 2);
function base10_to_2(n)    = decimal_to_binary(n);
function decTobin(n)       = decimal_to_binary(n);
function dec2bin(n)        = decimal_to_binary(n);
///     Octal number system (Base-8)
function decimal_to_octal(n) = decimal_to(n, 8);
function base10_to_8(n)    = decimal_to_octal(n);
function decTooct(n)       = decimal_to_octal(n);
function dec2oct(n)        = decimal_to_octal(n);
///     Hexadecimal number system (Base-16)
function decimal_to_hexidecimal(string) = decimal_to(string);
function base10_to_16(string)   = decimal_to_hexidecimal(string);
function decTohex(string)       = decimal_to_hexidecimal(string);
function dec2hex(string)        = decimal_to_hexidecimal(string);
/*
#################################################################*/





/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// Section: Color Constants
*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// Subsection:  Standard Illuminant
//   A standard illuminant is a theoretical source of visible light with aspectral
//   power distribution that is published. Standard illuminants provide a basis for
//   comparing images or colors recorded under different lighting.
//   The color formed by all three primariies at full intensity, aka white point
//   https://www.w3.org/TR/2021/WD-css-color-4-20211215/#white-point
*/

// Constant: ILLUMINANT_A
// Description:
//   CIE standard illuminant A is intended to represent typical, domestic,
//   tungsten-filament lighting.
//   
//   A should be used in all applications of colorimetry involving the use of
//   incandescent lighting, unless there are specific reasons for using adifferent
//   illuminant.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_A=[["A",        [0.44757,0.40745],  [.45117,0.40594],    2856,  "incandescent / tungsten"]];

// Constant: ILLUMINANT_B & ILLUMINANT_C
// Status: DEPRECATED, use ILLUMINANT_D instead
// Description:
//   Unfortunately, Illuminants B and C are poor approximations of any phase of
//   natural daylight, particularly in the short-wave visible and in the ultraviolet
//   spectral ranges. Once more realistic simulations were achievable, illuminants B
//   and C were deprecated in favor of the D series.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_B=[["B",        [0.34842,0.35161],  [.34980,0.35270],    4874,  "obsolete, direct sunlight at noon"]];
ILLUMINANT_C=[["C",        [0.31006,0.31616],  [.31039,0.31905],    6774,  "obsolete, average / North sky daylight"]];

// Constant: ILLUMINANT_D
// Description:
//   The D series of illuminants are constructed to represent natural daylight.
//   They are difficult to produce artificially, but are easy to characterize
//   mathematically.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_D=[["D50",      [0.34567,0.35850],  [.34773,0.35952],    5003,  "horizon light, ICC profile PCS"],
              ["D55",      [0.33242,0.34743],  [.33411,0.34877],    5503,  "mid-morning / mid-afternoon daylight"],
              ["D65",      [0.31271,0.32902],  [.31382,0.33100],    6504,  "noon daylight: television, sRGB color space"],
              ["D75",      [0.29902,0.31485],  [.29968,0.31740],    7504,  "North sky daylight"],
              ["D93",      [0.28315,0.29711],  [.28327,0.30043],    9305,  "high-efficiency blue phosphor monitors, BT.2035"]];

// Constant: ILLUMINANT_E
// Description:
//   Illuminant E is an equal-energy radiator; it has a constant SPD inside the
//   visible spectrum.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_E=[["E",        [0.33333,0.33333],  [.33333,0.33333],    5454,  "equal energy"]];

// Constant: ILLUMINANT_F
// Description:
//   The F series of illuminants represent various types of fluorescent lighting.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_F=[["F1",       [0.31310,0.33727],  [.31811,0.33559],    6430,  "daylight fluorescent"],
              ["F2",       [0.37208,0.37529],  [.37925,0.36733],    4230,  "cool white fluorescent"],
              ["F3",       [0.40910,0.39430],  [.41761,0.38324],    3450,  "white fluorescent"],
              ["F4",       [0.44018,0.40329],  [.44920,0.39074],    2940,  "warm white fluorescent"],
              ["F5",       [0.31379,0.34531],  [.31975,0.34246],    6350,  "daylight fluorescent"],
              ["F6",       [0.37790,0.38835],  [.38660,0.37847],    4150,  "light white fluorescent"],
              ["F7",       [0.31292,0.32933],  [.31569,0.32960],    6500,  "D65 simulator, daylight simulator"],
              ["F8",       [0.34588,0.35875],  [.34902,0.35939],    5000,  "D50 simulator, Sylvania F40 Design 50"],
              ["F9",       [0.37417,0.37281],  [.37829,0.37045],    4150,  "cool white deluxe fluorescent"],
              ["F10",      [0.34609,0.35986],  [.35090,0.35444],    5000,  "Philips TL85, Ultralume 50"],
              ["F11",      [0.38052,0.37713],  [.38541,0.37123],    4000,  "Philips TL84, Ultralume 40"],
              ["F12",      [0.43695,0.40441],  [.44256,0.39717],    3000,  "Philips TL83, Ultralume 30"]];

// Constant: ILLUMINANT_LED
// Description:
//   Publication 15:2018 introduces new illuminants for different LED types with
//   CCTs ranging from approx. 2700 K to 6600 K.
// Arguments:
//   Name = Name
//   CIE_1931 = [x,y] - 2-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CIE_1964 = [x,y] - 10-degree field of view: CIE chromaticity coordinates (x,y) of a perfectly reflecting (or transmitting) diffuser
//   CCT = Correlated Color Temperature (CCT) = in Kelvin
//   note = misc note
ILLUMINANT_LED=[["LED-B1", [0.4560,0.4078],                         2733,  "phosphor-converted blue"],
              ["LED-B2",   [0.4357,0.4012],                         2998,  "phosphor-converted blue"],
              ["LED-B3",   [0.3756,0.3723],                         4103,  "phosphor-converted blue"],
              ["LED-B4",   [0.3422,0.3502],                         5109,  "phosphor-converted blue"],
              ["LED-B5",   [0.3118,0.3236],                         6598,  "phosphor-converted blue"],
              ["LED-BH1",  [0.4474,0.4066],                         2851,  "mixing of phosphor-converted blue LED and red LED (blue-hybrid)"],
              ["LED-RGB1", [0.4557,0.4211],                         2840,  "mixing of red, green, and blue LEDs"],
              ["LED-V1",   [0.4560,0.4548],                         2724,  "phosphor-converted violet"],
              ["LED-V2",   [0.3781,0.3775],                         4070,  "phosphor-converted violet"]];
/*
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
/// BOSL Documentation Format
// Subsection:  W3 CSS Colors
//   CSS colors in the sRGB color space are represented by a triplet of
//   values—red, green, and blue—identifying a point in the sRGB color space [SRGB].
//   This is an internationally-recognized, device-independent color space, and so 
//   is useful for specifying colors that will be displayed on a computer screen,
//   but is also useful for specifying colors on other types of devices, like printers.
//   
//   sRGB is the default color space for CSS, used for all the legacy color functions.
*/

// Constant: BASIC_COLORS
// Description:
//   CSS defines a large set of named colors, so that common colors can be written
//   and read more easily.
//   16 of CSS’s named colors come from the VGA palette originally,
//   and were then adopted into HTML.
//   
//   The names resolve to colors in sRGB.
//
///  CSS Name                   R     G    B
BASIC_COLORS=[
    ["white",                   [255, 255, 255]],
    ["silver",                  [192, 192, 192]],
    ["gray",                    [128, 128, 128]],
    ["black",                   [0,   0,   0  ]],
    ["red",                     [255, 0,   0  ]],
    ["maroon",                  [128, 0,   0  ]],
    ["yellow",                  [255, 255, 0  ]],
    ["olive",                   [128, 128, 0  ]],
    ["lime",                    [0,   255, 0  ]],
    ["green",                   [0,   128, 0  ]],
    ["aqua",                    [0,   255, 255]],
    ["teal",                    [0,   128, 128]],
    ["blue",                    [0,   0,   255]],
    ["navy",                    [0,   0,   128]],
    ["fuchsia",                 [255, 0,   255]],
    ["purple",                  [128, 0,   128]]
];

// Constant: EXTENDED_COLORS
// Aliases: COLORS
// Description:
//   The extended colors is the result of merging specifications from HTML 4.01,
//   CSS 2.0, SVG 1.0 and CSS3 User Interfaces (CSS3 UI)
//   
//   The names resolve to colors in sRGB.
//   
///  CSS Name                   R     G    B
EXTENDED_COLORS=[
/// Pink colors
    ["mediumvioletred",         [199, 21,  133]],
    ["deeppink",                [255, 20,  147]],
    ["palevioletred",           [219, 112, 147]],
    ["hotpink",                 [255, 105, 180]],
    ["lightpink",               [255, 182, 193]],
    ["pink",                    [255, 192, 203]],
/// Red colors
    ["darkred",                 [139, 0,   0  ]],
    ["red",                     [255, 0,   0  ]],
    ["firebrick",               [178, 34,  34 ]],
    ["crimson",                 [220, 20,  60 ]],
    ["indianred",               [205, 92,  92 ]],
    ["lightcoral",              [240, 128, 128]],
    ["salmon",                  [250, 128, 114]],
    ["darksalmon",              [233, 150, 122]],
    ["lightsalmon",             [255, 160, 122]],
/// Orange colors
    ["orangered",               [255, 69,  0  ]],
    ["tomato",                  [255, 99,  71 ]],
    ["darkorange",              [255, 140, 0  ]],
    ["coral",                   [255, 127, 80 ]],
    ["orange",                  [255, 165, 0  ]],
/// Yellow colors
    ["darkkhaki",               [189, 183, 107]],
    ["gold",                    [255, 215, 0  ]],
    ["khaki",                   [240, 230, 140]],
    ["peachpuff",               [255, 218, 185]],
    ["yellow",                  [255, 255, 0  ]],
    ["palegoldenrod",           [238, 232, 170]],
    ["moccasin",                [255, 228, 181]],
    ["papayawhip",              [255, 239, 213]],
    ["lightgoldenrodyellow",    [250, 250, 210]],
    ["lemonchiffon",            [255, 250, 205]],
    ["lightyellow",             [255, 255, 224]],
/// Brown colors
    ["maroon",                  [128, 0,   0  ]],
    ["brown",                   [165, 42,  42 ]],
    ["saddlebrown",             [139, 69,  19 ]],
    ["sienna",                  [160, 82,  45 ]],
    ["chocolate",               [210, 105, 30 ]],
    ["darkgoldenrod",           [184, 134, 11 ]],
    ["peru",                    [205, 133, 63 ]],
    ["rosybrown",               [188, 143, 143]],
    ["goldenrod",               [218, 165, 32 ]],
    ["sandybrown",              [244, 164, 96 ]],
    ["tan",                     [210, 180, 140]],
    ["burlywood",               [222, 184, 135]],
    ["wheat",                   [245, 222, 179]],
    ["navajowhite",             [255, 222, 173]],
    ["bisque",                  [255, 228, 196]],
    ["blanchedalmond",          [255, 235, 205]],
    ["cornsilk",                [255, 248, 220]],
/// Green colors
    ["darkgreen",               [0,   100, 0  ]],
    ["green",                   [0,   128, 0  ]],
    ["darkolivegreen",          [85,  107, 47 ]],
    ["forestgreen",             [34,  139, 34 ]],
    ["seagreen",                [46,  139, 87 ]],
    ["olive",                   [128, 128, 0  ]],
    ["olivedrab",               [107, 142, 35 ]],
    ["mediumseagreen",          [60,  179, 113]],
    ["limegreen",               [50,  205, 50 ]],
    ["lime",                    [0,   255, 0  ]],
    ["springgreen",             [0,   255, 127]],
    ["mediumspringgreen",       [0,   250, 154]],
    ["darkseagreen",            [143, 188, 143]],
    ["mediumaquamarine",        [102, 205, 170]],
    ["yellowgreen",             [154, 205, 50 ]],
    ["lawngreen",               [124, 252, 0  ]],
    ["chartreuse",              [127, 255, 0  ]],
    ["lightgreen",              [144, 238, 144]],
    ["greenyellow",             [173, 255, 47 ]],
    ["palegreen",               [152, 251, 152]],
/// Cyan colors    
    ["teal",                    [0,   128, 128]],
    ["darkcyan",                [0,   139, 139]],
    ["lightseagreen",           [32,  178, 170]],
    ["cadetblue",               [95,  158, 160]],
    ["darkturquoise",           [0,   206, 209]],
    ["mediumturquoise",         [72,  209, 204]],
    ["turquoise",               [64,  224, 208]],
    ["aqua",                    [0,   255, 255]],
    ["cyan",                    [0,   255, 255]],
    ["aquamarine",              [127, 255, 212]],
    ["paleturquoise",           [175, 238, 238]],
    ["lightcyan",               [224, 255, 255]],
/// Blue colors
    ["navy",                    [0,   0,   128]],
    ["darkblue",                [0,   0,   139]],
    ["mediumblue",              [0,   0,   205]],
    ["blue",                    [0,   0,   255]],
    ["midnightblue",            [25,  25,  112]],
    ["royalblue",               [65,  105, 225]],
    ["steelblue",               [70,  130, 180]],
    ["dodgerblue",              [30,  144, 255]],
    ["deepskyblue",             [0,   191, 255]],
    ["cornflowerblue",          [100, 149, 237]],
    ["skyblue",                 [135, 206, 235]],
    ["lightskyblue",            [135, 206, 250]],
    ["lightsteelblue",          [176, 196, 222]],
    ["lightblue",               [173, 216, 230]],
    ["powderblue",              [176, 224, 230]],
/// Purple, violet, and magenta color
    ["rebeccapurple",           [102, 51,  153]],
    ["indigo",                  [75,  0,   130]],
    ["purple",                  [128, 0,   128]],
    ["darkmagenta",             [139, 0,   139]],
    ["darkviolet",              [148, 0,   211]],
    ["darkslateblue",           [72,  61,  139]],
    ["blueviolet",              [138, 43,  226]],
    ["darkorchid",              [153, 50,  204]],
    ["fuchsia",                 [255, 0,   255]],
    ["magenta",                 [255, 0,   255]],
    ["slateblue",               [106, 90,  205]],
    ["mediumslateblue",         [123, 104, 238]],
    ["mediumorchid",            [186, 85,  211]],
    ["mediumpurple",            [147, 112, 219]],
    ["orchid",                  [218, 112, 214]],
    ["violet",                  [238, 130, 238]],
    ["plum",                    [221, 160, 221]],
    ["thistle",                 [216, 191, 216]],
    ["lavender",                [230, 230, 250]],
/// White colors
    ["mistyrose",               [255, 228, 225]],
    ["antiquewhite",            [250, 235, 215]],
    ["linen",                   [250, 240, 230]],
    ["beige",                   [245, 245, 220]],
    ["whitesmoke",              [245, 245, 245]],
    ["lavenderblush",           [255, 240, 245]],
    ["oldlace",                 [253, 245, 230]],
    ["aliceblue",               [240, 248, 255]],
    ["seashell",                [255, 245, 238]],
    ["ghostwhite",              [248, 248, 255]],
    ["honeydew",                [240, 255, 240]],
    ["floralwhite",             [255, 250, 240]],
    ["azure",                   [240, 255, 255]],
    ["mintcream",               [245, 255, 250]],
    ["snow",                    [255, 250, 250]],
    ["ivory",                   [255, 255, 240]],
    ["white",                   [255, 255, 255]],
/// Gray and black colors
    ["black",                   [0,   0,   0  ]],
    ["darkslategray",           [47,  79,  79 ]],
    ["darkslategrey",           [47,  79,  79 ]],
    ["dimgray",                 [105, 105, 105]],
    ["dimgrey",                 [105, 105, 105]],
    ["slategray",               [112, 128, 144]],
    ["slategrey",               [112, 128, 144]],
    ["gray",                    [128, 128, 128]],
    ["grey",                    [128, 128, 128]],
    ["lightslategray",          [119, 136, 153]],
    ["lightslategrey",          [119, 136, 153]],
    ["darkgray",                [169, 169, 169]],
    ["darkgrey",                [169, 169, 169]],
    ["silver",                  [192, 192, 192]],
    ["lightgray",               [211, 211, 211]],
    ["lightgrey",               [211, 211, 211]],
    ["gainsboro",               [220, 220, 220]]
];
COLORS = EXTENDED_COLORS;
/*
@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/