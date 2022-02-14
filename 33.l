%{
int i=0,j=0,k=0,arg[10][20],mname[20];
%}
%s START
%s ARG
%s END
%s MAIN
%%
<INITIAL>"#define " {BEGIN START;}   //implicitly declared for all default states,.so its optional.
<INITIAL>. {fprintf(yyout,"%s",yytext);}
<START>[a-zA-Z0-9]+ {//strcpy(mname,yytext);   //function name.
        fprintf(yyout,"int %s",yytext);
        BEGIN ARG;
        }
 //NOTE: starting '(' b4 paramter is printed/echoed automatically due to no match for it in <ARG>.
<ARG>[^,()]+ {//strcpy(arg[i++],yytext);   // varaible name.
        fprintf(yyout,"int %s",yytext);
        }
<ARG>[,] {fprintf(yyout,"%s",yytext);}     //just comma
<ARG>")" {fprintf(yyout,"%s\n{",yytext);    //just ending brace and call to END.
        BEGIN END;
        } 
<END>[^\n]+ {
        fprintf(yyout,"\n return %s\n}\n",yytext);   //just put whatever defn there, after return.
        BEGIN MAIN;
        }
<MAIN>. {fprintf(yyout,"%s",yytext);
        }
%%

int yywrap(){}

int main()
{
        yyin = fopen("macro_func.c","r");
        yyout = fopen("macro_func_out.c","w");
        yylex();
        fclose(yyin);
        fclose(yyout);
        printf("Done\n");
        return 0;
}