%% -----------------------------------------------------------------------------
% Read the d2d objects
% -----------------------------------------------------------------------------
load('spagplot.mat')


%% -----------------------------------------------------------------------------
% Now stitch everything together as [H-P-]G-H-N-G-P-N
% -----------------------------------------------------------------------------
scale = true;

% GH scale=1
d_gh = IX_dataset_2d(w_gh);

% HN scale=sqrt(2)
d_nh = IX_dataset_2d(w_nh);
if scale, d_nh=scale_x(d_nh,sqrt(2)); end
d_hn = d_nh; d_hn.signal=flipud(d_hn.signal); d_hn.error=flipud(d_hn.error);

% NG scale=sqrt(2)
d_gn = IX_dataset_2d(w_gn);
d_ng = d_gn; d_ng.signal=flipud(d_ng.signal); d_ng.error=flipud(d_ng.error);
if scale, d_gn=scale_x(d_gn,sqrt(2)); end

% GP scale=sqrt(3)
d_gp = IX_dataset_2d(w_gp);
if scale, d_gp=scale_x(d_gp,sqrt(3)); end
d_pg = d_gp; d_pg.signal=flipud(d_pg.signal); d_pg.error=flipud(d_pg.error);

% PN scale=1
d_np = IX_dataset_2d(w_np);
d_pn = d_np; d_pn.signal=flipud(d_pn.signal); d_pn.error=flipud(d_pn.error);

% PH scale=sqrt(3)
d_ph = IX_dataset_2d(w_ph);
if scale, d_ph=scale_x(d_ph,sqrt(3)); end
d_hp = d_ph; d_hp.signal=flipud(d_hp.signal); d_hp.error=flipud(d_hp.error);

d_tot = [d_hp,d_pg,d_gh,d_hn,d_ng,d_gp,d_pn];
for i=2:numel(d_tot)
    end_prev = d_tot(i-1).x(end);
    origin_now = d_tot(i).x(1);
    dx = end_prev - origin_now;
    d_tot(i) = shift_x(d_tot(i),dx);
end


%% -----------------------------------------------------------------------------
% Replace enerything below 100meV with NaN
% -----------------------------------------------------------------------------
for i=1:numel(d_tot)
    d_tot(i).signal(:,1:25) = NaN;
    d_tot(i).error(:,1:25) = 0;
end


%% -----------------------------------------------------------------------------
% Plot
% -----------------------------------------------------------------------------
% Symmetry point labels
labels = {'H','P','G','H','N','G','P','N'};

% Array to contain the x values at which there is a high symmetry point
joins = zeros(1,1+numel(d_tot));    
joins(1) = d_tot(1).x(1);
for i=1:numel(d_tot)
    joins(i+1) = d_tot(i).x(end);
end

% Lines at the high symmetry points:
wsym = repmat(IX_dataset_1d,1,numel(joins));
for i=1:numel(wsym)
    wsym(i) = IX_dataset_1d(joins(i)*[1,1],[0,500]);
end

% Plot data:
plot(d_tot)
lz 0 0.65
set(gca,'XTick',joins);
set(gca,'XTickLabel',labels);
fig_prettify_spagplot
xlabel('')
ylabel('Energy (meV)')
colorbar('delete')

% Plot lines at high symmetry points
acolor('black')
aline(2)
ploc(wsym)

