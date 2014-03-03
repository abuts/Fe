classdef parWithCorrections
    % class defines parabolic spin wave and
    % methods used to calculate changes of intensity caused by the shape of
    % this parabold
    
    %   Detailed explanation goes here
    
    properties
        A_cor;        % a normalization constant calculated at some point of q
        legend='';    % the legend desctibes the SW position
        % the q-range to do fitting within
        QRange=0.2;
        % energy limit below wihich spin wave appear
        Esw_threshold=40;
        % initial peak width
        peak_width =0.02;
        % minimal number of steps in 1D cut to fit
        num_steps_in_cut=20;
        %
        cut_direction=[1,0,0];
        dE=2;
        dk=0.05;
        correction = 1;
        %
        fix_x_coordinate = true;
        cut_at_e_points  = false; % specify energy points to cut rather them q-points
        energies;
        
        result_pic;
    end
    properties(Dependent)
        p; % The coefficients of the parabola, which describes spit wave in the form E=p(1)+q*p(2)+q^2*p(3)
        ref_par_X; % the X points seelcted manually to plot spin wave through
        ref_par_Y; % the Y points seelcted manually to plot spin wave through      
    end
    properties(Access=private)
        p_;
        XY_ref_points_;
    end
    
    methods
        %---------------------------------------------------------------------------------
        function self=parWithCorrections(rp)
            if isa(rp,'parWithCorrections')
                self.A_cor=rp.A_cor;        % a normalization constant calculated at some point of q
                self.legend=rp.legend;      % the legend desctibes the SW position
                self.XY_ref_points_=rp.XY_ref_points_; % the X points seelcted manually to plot spin wave through
                %self.ref_par_Y=rp.ref_par_Y; % the Y points seelcted manually to plot spin wave through
                self.QRange=rp.QRange;  % the q-range to do fitting within
                self.Esw_threshold=rp.Esw_threshold;   % energy limit below wihich spin wave appear
                self.peak_width =rp.peak_width;       % initial peak width
                self.num_steps_in_cut=rp.num_steps_in_cut; % minimal number of steps in 1D cut to fit
                %
                self.cut_direction=rp.cut_direction;
                self.dE=rp.dE;
                self.dk=rp.dk;
                self.correction = rp.correction;
                %
                self.cut_at_e_points = rp.cut_at_e_points;
                self.fix_x_coordinate= rp.fix_x_coordinate;
                self.energies=rp.energies;
                
                self.result_pic=rp.result_pic;
                self.p_ = rp.p_;
            else
                self.ref_par_X=rp;
            end
        end
        function val=get.ref_par_X(self)
            val = self.XY_ref_points_(1,:);
        end
        function val=get.ref_par_Y(self)
            val = self.XY_ref_points_(2,:);
        end
        function self=set.ref_par_X(self,rp)
            if size(rp) == [2,5]
                self.XY_ref_points_ = rp;          
            elseif numel(rp) == 5
                self.XY_ref_points_(1,:) = rp;
            else
                error('Invalid number of parameters')
            end
            x1 = self.XY_ref_points_(1,:);
            y1 = self.XY_ref_points_(2,:);
            er1= ones(size(x1));
            [ym,ind] = max(y1);
            p3_0 = ym/(x1(ind)*x1(ind));
            %
            fitpar=@(x,par)(par(1)+(par(2)+par(3)*x).*x);
            [~,par] = fit(x1,y1,er1,fitpar,[0,0,p3_0],[1,1,1]);
            %
            p0 = par.p;
            %
            self.p_ = p0;
            q0=0.4;
            self.A_cor = p0(1)+q0*(p0(2)+q0*p0(3));
      
        end
       function self=set.ref_par_Y(self,rp)
            if numel(rp) == 5
                self.XY_ref_points_(2,:)=rp;
            else
                error('Invalid number of parameters')              
            end              
       end
     
        %
        function e_min = emin(self,s)
            if (s+1)<1.e-6
                e_min = min(self.ref_par_Y(1),self.ref_par_Y(2));
            elseif abs(s-1)<1.e-6
                e_min = min(self.ref_par_Y(4),self.ref_par_Y(5));
            else
                e_min = max(min(self.ref_par_Y(1),self.ref_par_Y(2)),min(self.ref_par_Y(4),self.ref_par_Y(5)));
            end
        end
        %
        function e_max = emax(self,s)
            if (s+1)<1.e-6
                e_max = max(self.ref_par_Y(1),self.ref_par_Y(2));
            elseif abs(s-1)<1.e-6
                e_max = max(self.ref_par_Y(4),self.ref_par_Y(5));
            else
                e_max = min(max(self.ref_par_Y(1),self.ref_par_Y(2)),max(self.ref_par_Y(4),self.ref_par_Y(5)));
            end
        end
        function valid = evalid(self,energy,s)
            is_valid = @(x)(x < self.emax(s) & x>self.emin(s));
            valid = arrayfun(is_valid,energy);
        end
        %
        function xx=getXonE(self,erange,side)
            % method to calculate range of q given the range of energies
            Det = self.p(2)*self.p(2)-4*self.p(3)*(self.p(1)-erange);
            if side<0
                xx = (-self.p(2)-sqrt(Det))/(2*self.p(3));
            elseif side>0
                xx = (-self.p(2)+sqrt(Det))/(2*self.p(3));
            else % side == 0
                xx = [(-self.p(2)-sqrt(Det))/(2*self.p(3)),(-self.p(2)+sqrt(Det))/(2*self.p(3))];
            end
            
        end
        %
        function [I,dI]=correctIntensity(self,I0,dI0,qi,sigma,dK,dE)
            % method to calculate corrections as the function of wave
            % vector assuming spin wave is parabolic and the corrections are
            % described by corr=Sigma/((1+2*betta*q)*2*dK) where betta is
            % the coefficient near quadratic term of the parabola;
            %
            %Connection between q and energy
            %             Det = self.p(2)*self.p(2)-4*self.p(3)*(self.p(1)-energy);
            %             if side<0
            %                 qi = (-self.p(2)-sqrt(Det))/(2*self.p(3));
            %             else
            %                 qi = (-self.p(2)+sqrt(Det))/(2*self.p(3));
            %             end
            if self.correction==1
                corr = (2*self.p_(3)*abs(qi));
            else
                pp= self.p;
                e0 = qi*(pp(2)+qi*pp(3));
                f = @(x)(erf((-e0+dE+(qi+x).*(pp(2)+((qi+x))*pp(3)))/(sqrt(2)*sigma))+...
                    erf((e0+dE-(qi+x).*(pp(2)+((qi+x))*pp(3)))/(sqrt(2)*sigma)));
                corr = 1/(0.25*integral(f,-dK,dK));
                
            end
            I = I0*corr;
            dI= dI0*corr;
            
        end
        %
        %
        function [mina,maxa,dk_cut] = q_range(self,q,energy,dk,varargin)
            % method calculates the q-range to make cut within.
            qrange= self.QRange;
            if nargin > 4
                if energy>self.Esw_threshold  % limits for phonons
                    q_min = -abs(q)*2.5;
                    q_max =  abs(q)*2.5;
                else
                    q_min = -abs(q)-qrange;
                    q_max =  abs(q)+qrange;
                end
            else
                if energy>self.Esw_threshold  % limits for phonons
                    q_min = q*2.5;
                    q_max = 0;
                else
                    q_min = q-qrange;
                    q_max = q+qrange;
                end
            end
            a = [q_min,q_max];
            mina = min(a);
            maxa = max(a);
            
            if 0.5*(mina+maxa) > 0
                if mina < 0
                    mina = 0;
                end
            else
                if maxa > 0
                    maxa  = 0;
                end
            end
            
            n_steps = (maxa-mina)/dk;
            if n_steps<self.num_steps_in_cut
                dk_cut = (maxa-mina)/self.num_steps_in_cut;
            else
                dk_cut = dk;
            end
            
        end
        
        %---------------------------------------------------------------------------------
        function this=set.p(this,val)
            if(numel(val)<3)
                error('SW_PAR:set_p','SW parabola parameters have to be a 3-vector');
            end
            if size(val,2)==1
                this.p_=val;
            else
                this.p_=val;
            end
            
            this.ref_par_Y = this.dispersion(this.ref_par_X);
        end
        function val = get.p(this)
            val = this.p_;
        end
        %
        
        function [ref_points,self] = refit_ref_points(self,par)
            % method recalculates reference points of the spin wave
            % receiving fit parameters par
            self.p = par;
            xm2 = self.ref_par_X(1);
            ym2 = self.dispersion(xm2);
            if ym2 > self.ref_par_Y(1)
                ym2 = self.ref_par_Y(1)-self.dE;
                xm2 = self.getXonE(ym2,-1);
            end
            self.XY_ref_points_(1,1) = xm2;
            self.XY_ref_points_(2,1) = ym2;
            
            xp2 = self.XY_ref_points_(1,5);
            yp2 = self.dispersion(xp2);
            if yp2 > self.XY_ref_points_(2,5)
                yp2 = self.XY_ref_points_(2,5)-self.dE;
                xp2 = self.getXonE(yp2,1);
            end
            self.XY_ref_points_(1,5) = xp2;
            self.XY_ref_points_(2,5) = yp2;
            
            self.ref_par_Y = self.dispersion(self.ref_par_X);
            
            ref_points = [self.ref_par_X; self.ref_par_Y];
        end
        %
        function en = dispersion(self,q)
            en =(self.p_(1)+(self.p_(2)+self.p_(3)*q).*q);
        end
        
    end
    methods(Static)
        function capt = getTextFromVector(vector)
            capt=['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];
        end
        %
        function [I,dI,en]=break_heterogeneous(I,dI,en)
            % method to insert breaks (NaN-s) into non-unique function
            %
            % if one plots a non-unique function each leaf (unique part) of
            % this function is connected with the following leaf making the
            % graph messy.
            %
            % the method inserts NaN-s to seaparate unique leafs from each
            % other
            % UNFINISHED !
            
            i=1:numel(en)-1;
            if en(2)>en(1)
                fbreak= @(i) en(i)>en(i+1);
            else
                fbreak= @(i) en(i)<en(i+1);
            end
            xbreak = arrayfun(fbreak,i);
            ind  = find(xbreak);
            if ~isempty(ind)
                ind = ind(1);
                I=[I(1:ind),NaN,I(ind+1:end)];
                dI=[dI(1:ind),NaN,dI(ind+1:end)];
                en =[en(1:ind),NaN,en(ind+1:end)];
            end
        end
        function [I,dI]=corr_fun(newBetta,oldBetta,I,dI,x)
            % function to correct intensity by newly changed parabola
            % coefficients
            cc = (1+2*newBetta*abs(x))./(1+2*oldBetta*abs(x));
            I=I.*cc;
            dI=dI.*cc;
            %
        end
        function fit = reCorrect(fit,oldPar,newPar)
            [fit.I,fit.dI]=parWithCorrections.corr_fun(newPar(3),oldPar(3),fit.I,fit.dI,fit.xx);
        end
        function [I,dI] = reCorrectI(I0,dI0,qs,old_par,new_par)
            % methor to modify intensity corrections with better verified sw
            % parameters
            % I0 -- intensity to re-correct
            % dI0 -- error in intensity to recorrect
            % new par -- improved array of parabola coefficients, which should
            % be used instead of old parabola coefficients.
            
            %
            oldBetta = old_par(3);
            [I,dI]=parWithCorrections.corr_fun(new_par(3),oldBetta,I0,dI0,qs);
            
        end
        
        
        
    end
    
end

