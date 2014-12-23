classdef pic_spread
    %Class respronsible for spreading number of pictures around the
    %screen
    
    properties
        resize_pitcures = false;
        overlap_borders = false;
        pic_size = [800,600];
        pic_count=0;
        % size of the left border in pictures to start from (e.g. if you have
        % windows toolbad on the left side of the screen)
        left_border=40;
        top_border =60;
    end
    properties(Access=private)
        pic_per_screen=[4,3];
        screen_size=[800,600];
        pic_list={};
        current_shift_x=0;
        current_shift_y=0;
        % rize all previous figures when adding the last one
        rize_stored_figures = false;
    end
    
    methods
        function obj=pic_spread(varargin)
            % constructor initates the class and defines the picture size
            %
            % Usage:
            % >>obj=pic_spread(['-tight']) % -- prepares to put default image spread of 4x3
            %                         picture per creen
            % >>obj=pic_spread([3,2],['-tight']) % -- prepares to put 6 pictures on the screen as
            %                              in the table of 3x2 cells
            %
            % if '-tight' parameter is present, then picture placed on the
            % screen tight, namely overalling picture borders and resizing
            % them to fit on the screen requested number.
            
            keywords={'-tight','rize'};
            set(0,'Units','pixels')
            ss= get(0,'ScreenSize');
            obj.screen_size=[ss(3),ss(4)];
            [ok,mess,place_pic_tight,rize_fig,param]=parse_char_options(varargin,keywords);
            if ~ok
                error('PIC_SPREAD:invalid_argument',mess);
            end
            obj.rize_stored_figures=rize_fig;
            
            if ~isempty(param) && numel(param{1})==2
                obj.pic_per_screen = param{1};
            end
            
            if place_pic_tight
                obj.overlap_borders=true;
                obj.top_border=0;
                obj.resize_pitcures = true;
            end
            obj.pic_size = int32([(obj.screen_size(1)-obj.left_border)/obj.pic_per_screen(1),(obj.screen_size(2)-obj.top_border)/obj.pic_per_screen(2)]);
            
            obj.current_shift_x = obj.left_border;
        end
        
        function self=place_pic(self,fig_handle,varargin)
            % method sets the size and the postition of the picture,
            % defined by the picture handle provided as argument, to current size and
            % postion.
            % if '-rize' option is specified, after adding the last pictures 
            %  method also rized all previous pictures
            
            keywords={'-rize'};
            [ok,mess,rize_fig]=parse_char_options(varargin,keywords);
            if ~ok
                error('PIC_SPREAD:invalid_argument',mess);
            end
            if ~rize_fig
                rize_fig = self.rize_stored_figures;
            end
            
            ps = get(fig_handle,'Position');
            
            
            if ~self.resize_pitcures
                self.pic_size=[ps(3),ps(4)];
            end
            
            if self.pic_count==0
                iy = self.screen_size(2)-self.pic_size(2)-self.top_border;
            else
                iy = ps(2);
            end
            ix = self.current_shift_x;
            if ix+self.pic_size(1)>self.screen_size(1)
                if self.overlap_borders
                    ix = self.left_border;
                else
                    ix=0;
                end
                iy = iy-self.pic_size(2);
            end
            if iy<0
                iy = self.screen_size(2)-self.pic_size(2)-self.top_border;
            end
            set(fig_handle, 'Position', [ix iy, self.pic_size(1),self.pic_size(2)])
            
            self.current_shift_x = ix+self.pic_size(1);
            self.current_shift_y = iy;
            
            % store the info about active picture handles
            self.pic_count=self.pic_count+1;
            self.pic_list{self.pic_count}=fig_handle;
            
            if rize_fig
                for i=1:self.pic_count
                    %set(0,'currentfigure', self.pic_list{i});
                    figure(self.pic_list{i});
                end
                hold on;
            end
            
        end
        function self=close_pics_all(self)
            % method closes all related picutres
            
            close(self.pic_list{1:end});
            self.pic_list={};
            
            self.pic_count=0;
            self.current_shift_x =0;
            self.current_shift_y =0;
        end
        
        
        function self=close_pics(self)
            % method closes latest
            % self.pix_per_screen(1)*selfpic_per_screen(2) pictures
            
            n_pic_per_screen = self.pic_per_screen(1)*self.pic_per_screen(2);
            last =self.pic_count- n_pic_per_screen;
            if last<=0
                last=1;
            end
            ix = self.left_border;
            iy = self.screen_size(2)-self.pic_size(2);
            
            for i=self.pic_count:-1:last;
                fig_h = self.pic_list{i};
                try
                    ps = get(fig_h,'OuterPosition');
                    
                    ix = ps(1);
                    iy = ps(2);
                    close(fig_h);
                catch
                end
            end
            
            if last>1
                list = self.pic_list(1:last-1);
                self.pic_list = list;
            else
                self.pic_list={};
            end
            self.pic_count=numel(self.pic_list);
            self.current_shift_x =ix;
            self.current_shift_x =iy;
        end
        
        function self=raise_screen(self,varargin)
            % method rises pic_per_screen pictures starting from the picture number specified
            
            if nargin >1
                p_start = varargin{1};
            else
                p_start = 1;
            end
            
            p_end = p_start+self.pic_per_screen(1)*self.pic_per_screen(2);
            if p_end>self.pic_count
                p_end =self.pic_count;
            end
            
            for i=p_end:p_start:-1
                set(0,'currentfigure', self.pic_list{i});
            end
        end
    end
    
end

