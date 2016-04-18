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
%token <hex>    REG
%token          I
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
    SE REG SEP HEX {
        write_opcode(XKK(0x3, $2, $4));
    }
|
    SNE REG SEP HEX {
        write_opcode(XKK(0x4, $2, $4));
    }
|
    SE REG SEP REG {
        write_opcode(XYN(0x5, $2, $4, 0x0));
    }
|
    LD REG SEP HEX {
        write_opcode(XKK(0x6, $2, $4));
    }
|
    ADD REG SEP HEX {
        write_opcode(XKK(0x7, $2, $4));
    }
|
    LD REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x0));
    }
|
    OR REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x1));
    }
|
    AND REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x2));
    }
|
    XOR REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x3));
    }
|
    ADD REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x4));
    }
|
    SUB REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x5));
    }
|
    SHR REG {
        write_opcode(XYN(0x8, $2, 0x0, 0x6));
    }
|
    SHR REG SEP REG {
        write_opcode(XYN(0x8, $2, $4, 0x6));
    }
|
    SUBN REG SEP REG {
        write_opcode(XYN(8, $2, $4, 0x7));
    }
|
    SHL REG {
        write_opcode(XYN(0x8, $2, 0, 0x6));
    }
|
    SHL REG SEP REG {
        write_opcode(XYN(8, $2, $4, 0xe));
    }
|
    SNE REG SEP REG {
        write_opcode(XYN(0x9, $2, $4, 0x0));
    }
|
    LD I SEP HEX {
        write_opcode(NNN(0xa, $4));
    }
|
    JP REG SEP HEX {
        if ($2 == 0x0) {
            write_opcode(NNN(0xb, $4));
        }
        else {
            yyerror("Syntax error");
            exit(EXIT_FAILURE);
        }
    }
|
    RND REG SEP HEX {
        write_opcode(XKK(0xc, $2, $4));
    }
|
    DRW REG SEP REG SEP HEX {
        write_opcode(XYN(0xd, $2, $4, $6));
    }
|
    SKP REG {
        write_opcode(XKK(0xe, $2, 0x9e));
    }
|
    SKNP REG {
        write_opcode(XKK(0xe, $2, 0xa1));
    }
|
    LD REG SEP DT {
        write_opcode(XKK(0xf, $2, 0x07));
    }
|
    LD REG SEP K {
        write_opcode(XKK(0xf, $2, 0x0a));
    }
|
    LD DT SEP REG {
        write_opcode(XKK(0xf, $4, 0x15));
    }
|
    LD ST SEP REG {
        write_opcode(XKK(0xf, $4, 0x18));
    }
|
    ADD I SEP REG {
        write_opcode(XKK(0xf, $4, 0x1e));
    }
|
    LD F SEP REG {
        write_opcode(XKK(0xf, $4, 0x29));
    }
|
    LD B SEP REG {
        write_opcode(XKK(0xf, $4, 0x33));
    }
|
    LD L_BKT I R_BKT SEP REG {
        write_opcode(XKK(0xf, $6, 0x55));
    }
|
    LD REG SEP L_BKT I R_BKT {
        write_opcode(XKK(0xf, $2, 0x65));
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
    LD HF SEP REG {
        write_opcode(XKK(0xf, $4, 0x30));
    }
|
    LD R SEP REG {
        write_opcode(XKK(0xf, $4, 0x75));
    }
|
    LD REG SEP R {
        write_opcode(XKK(0xf, $2, 0x85));
    }
;

%%

void write_opcode(unsigned int opcode)
{
    fprintf(stdout, "%.4x", opcode);
}
