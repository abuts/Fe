function [sigErr]=digitize(w2)

x0= 0.2691;
I=0.28;
Sigma=0.1;

e=50:10:140;
sigErr=zeros(4,numel(e));
for i=1:numel(e)
 [x0,I,Sigma]=cut_and_fit(w2,e(i),x0,I,Sigma);    
 sigErr(1,i)=x0;
 sigErr(2,i)=e(i); 
 sigErr(3,i)=I; 
 sigErr(4,i)=Sigma;  
end
