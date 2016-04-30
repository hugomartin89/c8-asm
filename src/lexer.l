/*
 * Copyright (c) 2016 Hugo Martín <hugomartin89@gmail.com>.
 *
 * This file is part of C8-ASM.
 *
 * C8-ASM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * C8-ASM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with C8-ASM.  If not, see <http://www.gnu.org/licenses/>.
 */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.h"

    size_t yylinepos = 1; /* to keep current line */
%}

%option yylineno
%option warn

COMMENT ;.*
BLANK   [ \t]

IGNORE  {COMMENT}|{BLANK}

SEP     ,

HEX     (0x)?[0-9a-f]{1,3}

%%

{HEX} {
    sscanf(yytext, "%x", &yylval.hex);

    yylinepos += strlen(yytext);
    return (HEX);
}

{IGNORE} {
    yylinepos += strlen(yytext);
}

{SEP} {
    yylinepos += strlen(yytext);

    return (SEP);
}

"V" {
    yylinepos += strlen(yytext);
    return (V);
}

"I" {
    yylinepos += strlen(yytext);
    return (I);
}

"DT" {
    yylinepos += strlen(yytext);
    return (DT);
}

"K" {
    yylinepos += strlen(yytext);
    return (K);
}

"ST" {
    yylinepos += strlen(yytext);
    return (ST);
}

"F" {
    yylinepos += strlen(yytext);
    return (F);
}

"B" {
    yylinepos += strlen(yytext);
    return (B);
}

"HF" {
    yylinepos += strlen(yytext);
    return (HF);
}

"R" {
    yylinepos += strlen(yytext);
    return (R);
}

"[" {
    yylinepos += strlen(yytext);
    return (L_BKT);
}

"]" {
    yylinepos += strlen(yytext);
    return (R_BKT);
}

"\n" {
    yylinepos = 1;
}

"SYS" {
    yylinepos += strlen(yytext);
    return (SYS);
}

"CLS" {
    yylinepos += strlen(yytext);
    return (CLS);
}

"RET" {
    yylinepos += strlen(yytext);
    return (RET);
}

"JP" {
    yylinepos += strlen(yytext);
    return (JP);
}

"CALL" {
    yylinepos += strlen(yytext);
    return (CALL);
}

"SE" {
    yylinepos += strlen(yytext);
    return (SE);
}

"SNE" {
    yylinepos += strlen(yytext);
    return (SNE);
}

"LD" {
    yylinepos += strlen(yytext);
    return (LD);
}

"ADD" {
    yylinepos += strlen(yytext);
    return (ADD);
}

"OR" {
    yylinepos += strlen(yytext);
    return (OR);
}

"AND" {
    yylinepos += strlen(yytext);
    return (AND);
}

"XOR" {
    yylinepos += strlen(yytext);
    return (XOR);
}

"SUB" {
    yylinepos += strlen(yytext);
    return (SUB);
}

"SHR" {
    yylinepos += strlen(yytext);
    return (SHR);
}

"RND" {
    yylinepos += strlen(yytext);
    return (RND);
}

"DRW" {
    yylinepos += strlen(yytext);
    return (DRW);
}

"SKP" {
    yylinepos += strlen(yytext);
    return (SKP);
}

"SKNP" {
    yylinepos += strlen(yytext);
    return (SKNP);
}

"SCD" {
    yylinepos += strlen(yytext);
    return (SCD);
}

"SCR" {
    yylinepos += strlen(yytext);
    return (SCR);
}

"SCL" {
    yylinepos += strlen(yytext);
    return (SCL);
}

"EXIT" {
    yylinepos += strlen(yytext);
    return (EXIT);
}

"LOW" {
    yylinepos += strlen(yytext);
    return (LOW);
}

"HIGH" {
    yylinepos += strlen(yytext);
    return (HIGH);
}

. {
    /* TODO: improve error reports */
    fprintf(stderr, "Lexical error [%d:%d]: Unexpected token '%s'\n",
            yylineno, yylinepos, yytext);

    exit(EXIT_FAILURE);
}
