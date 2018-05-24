%option noyywrap
%option yylineno  

%{
  #include <malloc.h>
  #include <string.h>
  #include <stdio.h>

  unsigned long long int read_counter;
  int verb;
%}

sam_qname   [!-?A-~]{1,254}
sam_flag    [0-9]{1,5}    
sam_rname   \*|[!-()+-<>-~][!-~]*
sam_pos     [0-9]{1,10}
sam_mapq    [0-9]{1,3}
sam_cigar   \*|([0-9]+[MIDNSHPX=])+
sam_rnext   \*|=|[!-()+-<>-~][!-~]*
sam_pnext   [0-9]{1,10}
sam_tlen    [-0-9]{1,10}
sam_seq     \*=|[A-Za-z=.]+
sam_qual    [!-~]+
sam_aligA   [A-Za-z][A-Za-z0-9]:A:[!-~]
sam_aligi   [A-Za-z][A-Za-z0-9]:i:[-+]?[0-9]+
sam_aligf   [A-Za-z][A-Za-z0-9]:f:[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
sam_aligZ   [A-Za-z][A-Za-z0-9]:Z:[ !-~]+
sam_aligH   [A-Za-z][A-Za-z0-9]:H:[0-9A-F]+
sam_aligB   [A-Za-z][A-Za-z0-9]:B:[cCsSiIfF](,[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)+

%s expectqn
%s expectfl
%s expectrn
%s expectpo
%s expectmq
%s expectci
%s expectrx
%s expectpx
%s expecttl
%s expectse
%s expectql
%s expectop

%%
<expectqn>{sam_qname}   { if(verb) { printf("QNAME found:      %s\n",yytext);} BEGIN(expectfl); }
<expectfl>{sam_flag}    { if(verb) { printf("FLAG found:       %s\n",yytext);} BEGIN(expectrn); }
<expectrn>{sam_rname}   { if(verb) { printf("RNAME found:      %s\n",yytext);} BEGIN(expectpo); }
<expectpo>{sam_pos}     { if(verb) { printf("POS found:        %s\n",yytext);} BEGIN(expectmq); }  
<expectmq>{sam_mapq}    { if(verb) { printf("MAPQ found:       %s\n",yytext);} BEGIN(expectci); } 
<expectci>{sam_cigar}   { if(verb) { printf("CIGAR found:      %s\n",yytext);} BEGIN(expectrx); } 
<expectrx>{sam_rnext}   { if(verb) { printf("RNEXT found:      %s\n",yytext);} BEGIN(expectpx); }
<expectpx>{sam_pnext}   { if(verb) { printf("PNEXT found:      %s\n",yytext);} BEGIN(expecttl); } 
<expecttl>{sam_tlen}    { if(verb) { printf("TLEN found:       %s\n",yytext);} BEGIN(expectse); } 
<expectse>{sam_seq}     { if(verb) { printf("SEQ found:        %s\n",yytext);}
                          else     { printf("%s\n"                  ,yytext);} BEGIN(expectql); } 
<expectql>{sam_qual}    { if(verb) { printf("QUAL found:       %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligA}   { if(verb) { printf("ALIG (A) found:   %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligi}   { if(verb) { printf("ALIG (i) found:   %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligf}   { if(verb) { printf("ALIG (f) found:   %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligZ}   { if(verb) { printf("ALIG (Z) found:   %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligH}   { if(verb) { printf("ALIG (H) found:   %s\n",yytext);} BEGIN(expectop); }
<expectop>{sam_aligB}   { if(verb) { printf("ALIG (B) found:   %s\n",yytext);} BEGIN(expectop); }

\n                      { read_counter++; BEGIN(expectqn);}
.             {}

%%

int main()
{
  BEGIN(expectqn);
  read_counter = 0;
  verb = 0;

  fprintf(stderr,"CPP > info\t: preprocessing unit start\n");
  yylex();

  fprintf(stderr,"CPP > info\t: EOF reached line %i\n\t\t%Lu read(s) processed.\n",yylineno,read_counter);
  return 0;
}

