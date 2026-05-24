package br.maua.cic303;

%%

%class Lexer
%public
%unicode
%type Token
%line
%column

%{
    private Token token(Tag tag, String lexeme) {
        return new Token(tag, lexeme);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */
WhiteSpace = [ \t\r\n]+

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%

<YYINITIAL> {

    /* Ignorar espaços */
    {WhiteSpace}    { }

    /* ========================= */
    /* PALAVRAS RESERVADAS       */
    /* ========================= */
    "if"        { return token(Tag.IF, yytext()); }
    "then"      { return token(Tag.THEN, yytext()); }
    "else"      { return token(Tag.ELSE, yytext()); }
    "while"     { return token(Tag.WHILE, yytext()); }

    /* ========================= */
    /* PONTUAÇÃO                */
    /* ========================= */
    "("         { return token(Tag.LPAREN, yytext()); }
    ")"         { return token(Tag.RPAREN, yytext()); }
    "{"         { return token(Tag.LBRACE, yytext()); }
    "}"         { return token(Tag.RBRACE, yytext()); }
    ";"         { return token(Tag.SEMI, yytext()); }

    /* ========================= */
    /* OPERADORES RELACIONAIS    */
    /* ========================= */
    "=="        { return token(Tag.REL_OP, yytext()); }
    "!="        { return token(Tag.REL_OP, yytext()); }
    "<="        { return token(Tag.REL_OP, yytext()); }
    ">="        { return token(Tag.REL_OP, yytext()); }
    "<"         { return token(Tag.REL_OP, yytext()); }
    ">"         { return token(Tag.REL_OP, yytext()); }

    /* ========================= */
    /* ATRIBUIÇÃO               */
    /* ========================= */
    "="         { return token(Tag.ASSIGN, yytext()); }

    /* ========================= */
    /* OPERADORES MATEMÁTICOS   */
    /* ========================= */
    "+" | "-"       { return token(Tag.ADD_OP, yytext()); }
    "*" | "/" | "%" { return token(Tag.MUL_OP, yytext()); }

    /* ========================= */
    /* ERRO DE IDENTIFICADOR    */
    /* ========================= */
    {Letter}({Letter}|{Digit}|_){32} {
        return token(Tag.ERROR,
            "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext());
    }

    /* ========================= */
    /* NÚMEROS E IDS            */
    /* ========================= */
    {Number}        { return token(Tag.NUMBER, yytext()); }
    {Identifier}    { return token(Tag.ID, yytext()); }

    /* ========================= */
    /* ERRO GERAL               */
    /* ========================= */
    . {
        return token(Tag.ERROR,
            "Erro Léxico: Caractere Ilegal -> " + yytext());
    }
}

<<EOF>> { return token(Tag.EOF, ""); }