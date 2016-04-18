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

#include <stdio.h>

#include "parser.h"

extern char* yytext;
extern FILE* yyin;

void yyerror(const char* s);

int main(int argc, char* argv[])
{
    yyin = fopen(argv[1], "rt");

    yyparse();

    fclose(yyin);

    fprintf(stdout, "\n");

    return 0;
}

void yyerror(const char* s)
{
    fprintf(stderr, "Error: %s\n", s);
}
