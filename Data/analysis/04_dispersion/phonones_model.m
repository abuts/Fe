function [outputArg1,outputArg2] = phonones_model(qh,qk,ql,en,inputArg2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    inputArg1
    inputArg2
end

arguments (Output)
    outputArg1
    outputArg2
end
a1 = 2*pi*sqrt(2)/2.844;
A1 = 1;

f_sw = A1*sin(pi*(qh+qk)/a1)*sin(pi*(qh-qk)/a1);
end