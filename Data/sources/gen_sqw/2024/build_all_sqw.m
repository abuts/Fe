% build all sqw files with parameters, defined in their own
% sqw generation scripts
methods = {@make_sqw_ei196,@make_sqw_ei200,@make_sqw_ei401,@make_sqw_ei800,@make_sqw_ei1400};
%methods = {@test_timing,@test_timing};
timings = zeros(1,numel(methods));
for i = 1:numel(methods)
    disp('********************************************************************')
    disp('********************************************************************')
    disp('********************************************************************')
    disp('********************************************************************')
    t0 = tic;
    methods{i}();
    timings(i)= toc(t0);
end
for i=1:numel(methods)
    interv =  seconds(timings(i));
    interv.Format = 'hh:mm:ss';
    fprintf('Time to run %s = %s\n',func2str(methods{i}),string(interv));
end


