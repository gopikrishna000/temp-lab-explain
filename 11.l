%{
#include<string.h>
char while_str[10]="while(";
char buffer1[1024];
char buffer2[10];
int i,j,k;                           //rop - relational operator
%}

rop     ("<"|">"|">="|"<="|"!="|"==")   
var [a-z]
value   [0-9]
inc ("++"|"--")

%%
.       ;
\n      ;
"for("  ;
{var}+"="{value}+(","{var}+"="{value})*";"      { fprintf(yyout,"%s\n",yytext);  
                        }      /*everything b4 first ';' is just put above while loop as init*/
{var}+{rop}{value}+";"  {for(i=0;i<yyleng-1;i++)
                        {
                                buffer2[i]=yytext[i];
                        }
                        strcat(while_str,buffer2);
                        strcat(while_str,")");
                        fprintf(yyout,"%s",while_str);
                        fprintf(yyout,"\n");
                        strcpy(while_str,"while(");
                        }                          //while loop with one line
{var}+{inc}")"  {for(k=0;k<yyleng-1;k++)    
                   {
                        buffer1[k]=yytext[k];
                   }
                        buffer1[k]=';';
                }               //just stored, to print at end of while loop

{var}+{inc}");"         {for(k=0;k<yyleng-2;k++)     
                        {
                                buffer1[k]=yytext[k];
                        }
                        buffer1[k]=';';
                        fprintf(yyout,"%s\n",buffer1);
                        }
"{"[\n]?.*[\n]?"}"                      {for(j=0;j<yyleng-1;j++)   
                                {
                                        fprintf(yyout,"%c",yytext[j]);
                                }     
                        fprintf(yyout,"%s\n",buffer1);
                        strcpy(buffer1,"");
                        fprintf(yyout,"}\n");
                                    }      //at end of while loop, printing the inc or dec.

"for(;;)"                       {fprintf(yyout,"while(1);");}   //special case
%%

int yywrap(){  }

int main()
{
    yyin=fopen("forfile.c","r");
    yyout=fopen("forout.c","w");
    yylex();
    printf("done\n");
    return 0;
}
