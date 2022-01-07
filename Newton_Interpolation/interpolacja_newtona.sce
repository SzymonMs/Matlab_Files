function y= interpolacja_newtona
    X=[1 2 4.5 5 6];
    Y=[-10.5 -16 11.8125 27.5 112];
    rzad=4;
    function g=generuj(X,Y,a,b)
        if(a==b)
            g=Y(a);
        else
        wyk2=generuj(X,Y,a+1,b);
        wyk3=generuj(X,Y,a,b-1);
        g=(wyk2-wyk3)/(X(b)-X(a));
        end
    endfunction
    c(1:rzad+1)=0;
    
    for i=1:rzad+1
        c(i)=generuj(X,Y,1,i);
    end
x=poly(0,"x");
y=c(1);
for i=2:rzad+1
    y1=c(i);
    for j=1:i-1
        y1=y1*(x-X(j))
        end
        y=y+y1;
end
x=linspace(-1,6,1000);
wartosc=horner(y,x);
plot(x,wartosc)

endfunction
