/**
 *
 * This is the ANTLR grammar file for the PolarFrankie Lexer!
 *
 * (Literal values)
 *
**/

lexer grammar LexerLiterals;

// Options
options {
    language=Cpp;
}

import LexerFragments, LexerIdentifiersFragments;

// Boolean Literals
LIT_BOOLEAN_TRUE
    : '$TRUE'
    ; /* $true, any numerical value that doesn't match zero, or a non-empty string! */
LIT_BOOLEAN_FALSE
    : '$FALSE'
    ; /* $false, any numerical value that matches zero, or an empty string! */

// Numerial Literals
LIT_NUMBER
    :   '-'? DIGIT_+ '.' DIGIT_* // -3.14, 0.1, -1.14, 1., 3.
    |   '-'? DIGIT_* '.' DIGIT_+ // -3.14, 0.1, -.14, .4
    |   '-'? DIGIT_+ // 2, 12, 20
    ;

// Strings
LIT_STRING_START
    : '"'
            -> pushMode(MODE_STRING_CAPTURE)
    ; /* Start capturing string contents */

// String template inner capture
mode MODE_STRING_CAPTURE_REFERENCE;
    LIT_STRING_REFERENCE_TYPE_CONSTANT
        : '$' CONSTANT_IDENTIFIER_CONTENT_
        ; /* Type-related constants */
    LIT_STRING_REFERENCE_CONSTANT
        : CONSTANT_IDENTIFIER_CONTENT_
        ; /* Constants */
    LIT_STRING_REFERENCE_TYPE_VARIABLE
        : '$' VARIABLE_IDENTIFIER_CONTENT_
        ; /* Type-related variables */
    LIT_STRING_REFERENCE_VARIABLE
        : VARIABLE_IDENTIFIER_CONTENT_
        ; /* Variables */
    LIT_STRING_REFERENCE_ESCAPE_END_STRING_CONTENT
        : ESCAPE_SEQUENCE_ // Ends with an escape character!
                -> popMode
        ; /* End the reference mode! (part of raw string content) */
    LIT_STRING_REFERENCE_END_STRING_END
        : '"' // Ends the string!
                -> popMode, popMode
        ; /* End the string capture (When the reference mode ends with the string closing!) */
    LIT_STRING_REFERENCE_END_STRING_CONTENT
        : . // Ends with a normal character
                -> popMode
        ; /* End the reference mode! (part of raw string content) */

// String template inner capture
mode MODE_STRING_CAPTURE;
    LIT_STRING_CONTENT_ESCAPED
        : ESCAPE_SEQUENCE_
        ; /* Capture escaped string chars */
    LIT_STRING_REFERENCE_START
        : '$'
                -> pushMode(MODE_STRING_CAPTURE_REFERENCE)
        ; /* Start a reference capture */
    LIT_STRING_CONTENT
        : ~( '"' | '$' | '\\' )+
        ; /* Capture static string content */
    LIT_STRING_END
        : '"'
                -> popMode
        ; /* End the template mode */
