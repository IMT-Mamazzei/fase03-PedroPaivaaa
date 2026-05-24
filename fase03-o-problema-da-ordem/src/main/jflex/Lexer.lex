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
/* MACROS */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator}|[ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?
Letter = [a-zA-Z]
Digit = [0-9]

Identifier = {Letter}({Letter}|{Digit}|_)*
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%
<YYINITIAL> {
    {WhiteSpace} { /* ignora */ }

    /* Palavras reservadas */
    "if"    { return symbol(sym.IF); }
    "then"  { return symbol(sym.THEN); }
    "else"  { return symbol(sym.ELSE); }
    "while" { return symbol(sym.WHILE); }

    /* Operadores relacionais e atribuição */
    "==" | "!=" | "<=" | ">=" | "<" | ">" { return symbol(sym.REL_OP, yytext()); }
    "=" { return symbol(sym.ASSIGN); }

    /* Pontuação */
    "(" { return symbol(sym.LPAREN); }
    ")" { return symbol(sym.RPAREN); }
    "{" { return symbol(sym.LBRACE); }
    "}" { return symbol(sym.RBRACE); }
    ";" { return symbol(sym.SEMI); }

    /* Operadores matemáticos */
    "+" | "-" { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores e números */
    {OversizedIdentifier} {
        throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext());
    }

    {Identifier} { return symbol(sym.ID, yytext()); }
    {Number}     { return symbol(sym.NUMBER, yytext()); }

    /* Qualquer outro caractere */
    . {
        throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext());
    }
}

<<EOF>> { return symbol(sym.EOF, ""); }