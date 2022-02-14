%{
int i;
%}
text [a-z,;\%"()]
num [0-9]         //imp: if given BEGIN X, then from next iteration, only <X> will be matches until BEGIN INITIAL is given.
%s START        // %s -inclusive %x -exclusive start condition: means
%s CONDN        //like jump function after executing half result, and execute remaining result only if other pattern matched.
%s BODY    //%S or %Start; start condition (or even "%s BEGIN END";)
%s NEXT
nl [\n]
%%
"if("   {BEGIN START;}
<START>{text}+  {fprintf(yyout,"switch(%s)",yytext);
                fprintf(yyout,"\n{");
                BEGIN CONDN;}
<CONDN>"=="{num}+       {fprintf(yyout,"\ncase ");
                        for(i=2;i<yyleng;i++)     //printing the int value after case
                        {
                                fprintf(yyout,"%c",yytext[i]);
                        }
                        fprintf(yyout,":\n");
                        BEGIN BODY;
                        }
<BODY>"{"{nl}.* {for(i=1;i<yyleng;i++)    //matches for only one/first line
                {
                        fprintf(yyout,"%c",yytext[i]);
                }
                BEGIN NEXT;
                }
<NEXT>"}"{nl}"else if("{text}+  {fprintf(yyout,"\nbreak;");
                                BEGIN CONDN;}
<NEXT>"}"{nl}"else"     {fprintf(yyout,"\nbreak;");
                        fprintf(yyout,"\ndefault:\n");
                        BEGIN BODY;
                        }
<NEXT>"}"       {fprintf(yyout,"\n}");}
.       ;
%%

int yywrap(){}
int main()
{
yyin=fopen("if_switch.c","r");
yyout=fopen("if_switch_out.c","w");
yylex();
fclose(yyin);
printf("Done\n");
return 0;
}
