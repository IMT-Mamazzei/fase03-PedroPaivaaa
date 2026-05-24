package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

Letter = [a-zA-Z]
Digit = [0-9]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* identificador com mais de 32 chars */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    {WhiteSpace} { }

    /* palavras reservadas */
    "if"        { return symbol(sym.IF); }
    "then"      { return symbol(sym.THEN); }
    "else"      { return symbol(sym.ELSE); }
    "while"     { return symbol(sym.WHILE); }

    /* pontuação */
    "("         { return symbol(sym.LPAREN); }
    ")"         { return symbol(sym.RPAREN); }
    "{"         { return symbol(sym.LBRACE); }
    "}"         { return symbol(sym.RBRACE); }
    ";"         { return symbol(sym.SEMI); }

    /* relacionais - ordem IMPORTA */
    "=="        { return symbol(sym.REL_OP, yytext()); }
    "!="        { return symbol(sym.REL_OP, yytext()); }
    "<="        { return symbol(sym.REL_OP, yytext()); }
    ">="        { return symbol(sym.REL_OP, yytext()); }
    "<"         { return symbol(sym.REL_OP, yytext()); }
    ">"         { return symbol(sym.REL_OP, yytext()); }

    /* atribuição */
    "="         { return symbol(sym.ASSIGN); }

    /* operadores matemáticos */
    "+" | "-"   { return symbol(sym.ADD_OP, yytext()); }

    "*" | "/" | "%" {
        return symbol(sym.MUL_OP, yytext());
    }

    /* identificadores */
    {Identifier} {
        return symbol(sym.ID, yytext());
    }

    /* números */
    {Number} {
        return symbol(sym.NUMBER, yytext());
    }

    /* erro identificador gigante */
    {OversizedIdentifier} {
        throw new RuntimeException(
            "Erro Léxico: Identificador gigante -> " + yytext()
        );
    }

    /* erro genérico */
    . {
        throw new RuntimeException(
            "Erro Léxico: Caractere Ilegal -> " + yytext()
        );
    }
}

<<EOF>> {
    return symbol(sym.EOF);
}