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
    #include <stdlib.h>
    #include <stdio.h>

    #define NNN(a, n) \
        ((a << 12) | (n))

    #define XYN(a, x, y, n) \
        ((a << 12) | (x << 8)| (y << 4) | (n))

    #define XKK(a, x, kk) \
        ((a << 12) | (x << 8) | (kk))

    #define SC8(a, x) \
        ((a << 4) | (x))

    static void write_opcode(unsigned int opcode);
%}

%union
{
    unsigned int hex;
}

%token <hex>    HEX
%token          I
%token          V
%token          DT
%token          K
%token          ST
%token          F
%token          B
%token          HF
%token          R

%token          L_BKT
%token          R_BKT
%token          SEP

%token SYS
%token CLS
%token RET
%token JP
%token CALL
%token SE
%token SNE
%token LD
%token ADD
%token OR
%token AND
%token XOR
%token SUB
%token SHR
%token SUBN
%token SHL
%token RND
%token DRW
%token SKP
%token SKNP
%token SCD
%token SCR
%token SCL
%token EXIT
%token LOW
%token HIGH

%start compiler

%%

compiler: routine;

routine: %empty
|
    instruction routine
;

instruction:
    SYS HEX {
        write_opcode(NNN(0x0, $2));
    }
|
    CLS {
        write_opcode(0x00e0);
    }
|
    RET {
        write_opcode(0x00ee);
    }
|
    JP HEX {
        write_opcode(NNN(0x1, $2));
    }
|
    CALL HEX {
        write_opcode(NNN(0x2, $2));
    }
|
    SE V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XKK(0x3, $4, $7));
    }
|
    SNE V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XKK(0x4, $4, $7));
    }
|
    SE V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x5, $4, $9, 0x0));
    }
|
    LD V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XKK(0x6, $4, $7));
    }
|
    ADD V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XKK(0x7, $4, $7));
    }
|
    LD V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x0));
    }
|
    OR V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x1));
    }
|
    AND V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x2));
    }
|
    XOR V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x3));
    }
|
    ADD V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x4));
    }
|
    SUB V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x5));
    }
|
    SHR V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, 0x0, 0x6));
    }
|
    SHR V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, $9, 0x6));
    }
|
    SUBN V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(8, $4, $9, 0x7));
    }
|
    SHL V L_BKT HEX R_BKT {
        write_opcode(XYN(0x8, $4, 0, 0x6));
    }
|
    SHL V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(8, $4, $9, 0xe));
    }
|
    SNE V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XYN(0x9, $4, $9, 0x0));
    }
|
    LD I SEP HEX {
        write_opcode(NNN(0xa, $4));
    }
|
    JP V L_BKT HEX R_BKT SEP HEX {
        if ($4 == 0x0) {
            write_opcode(NNN(0xb, $7));
        }
        else {
            yyerror("Syntax error");
            exit(EXIT_FAILURE);
        }
    }
|
    RND V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XKK(0xc, $4, $7));
    }
|
    DRW V L_BKT HEX R_BKT SEP V L_BKT HEX R_BKT SEP HEX {
        write_opcode(XYN(0xd, $4, $9, $12));
    }
|
    SKP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xe, $4, 0x9e));
    }
|
    SKNP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xe, $4, 0xa1));
    }
|
    LD V L_BKT HEX R_BKT SEP DT {
        write_opcode(XKK(0xf, $4, 0x07));
    }
|
    LD V L_BKT HEX R_BKT SEP K {
        write_opcode(XKK(0xf, $4, 0x0a));
    }
|
    LD DT SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x15));
    }
|
    LD ST SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x18));
    }
|
    ADD I SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x1e));
    }
|
    LD F SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x29));
    }
|
    LD B SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x33));
    }
|
    LD V L_BKT I R_BKT SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $9, 0x55));
    }
|
    LD V L_BKT HEX R_BKT SEP L_BKT I R_BKT {
        write_opcode(XKK(0xf, $4, 0x65));
    }
|
    SCD HEX {
        write_opcode(SC8(0xc, $2));
    }
|
    SCR {
        write_opcode(SC8(0xf, 0xb));
    }
|
    SCL {
        write_opcode(SC8(0xf, 0xc));
    }
|
    EXIT {
        write_opcode(SC8(0xf, 0xd));
    }
|
    LOW {
        write_opcode(SC8(0xf, 0xe));
    }
|
    HIGH {
        write_opcode(SC8(0xf, 0xf));
    }
|
    LD HF SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x30));
    }
|
    LD R SEP V L_BKT HEX R_BKT {
        write_opcode(XKK(0xf, $6, 0x75));
    }
|
    LD V L_BKT HEX R_BKT SEP R {
        write_opcode(XKK(0xf, $4, 0x85));
    }
;

%%

void write_opcode(unsigned int opcode)
{
    fprintf(stdout, "%.4x", opcode);
}
