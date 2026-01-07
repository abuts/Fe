function disp = phonones_model(qh,qk,ql,en,param)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% arguments (Input)
%     qh (:,1) double;
%     qk (:,1) double;
%     ql (:,1) double;
%     en (:,1) double;
%     param (1,:) double;
% end

arguments (Output)
    disp double
end
%a1 = 2*pi*sqrt(2)/2.844;
a1 = 2*pi/2.844;
A1 = param(1);
gamma_ph = param(2);
disp = A1*abs(sin(pi*qh)+sin(pi*qk));
%weight = (((4/3)*290.6)*A1*ones(size(qh))) .* (dsho_over_eps (en, disp, gamma_ph));

%disp = disp .* weight;

end