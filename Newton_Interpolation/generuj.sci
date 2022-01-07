function generuj(x,y,a,b)
    if (a==b)
     return y(a);
     end
        return (generuj(x,y,a+1,b)-generuj(x,y,a,b-1))/(x(b)-x(a));
   
endfunction
