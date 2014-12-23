function I=parab(x,y,p)

I=(p(1)+p(2)*y)*exp(-p(3)*abs(y-p(4).*x.*x));
