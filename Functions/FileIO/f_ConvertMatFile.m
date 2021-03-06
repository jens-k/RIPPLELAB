%   f_ConvertMatFile [As a part of HFO Detection Project]
%   Written by:
%   Miguel G. Navarrete Mejia
%   Electrical Engineering MS 
%   UNIVERSIDAD DE LOS ANDES
%   Colombia, 2016
%   mnavarretem@gmail.com


function st_Info = f_ConvertMatFile(pst_SigPath)
% Converts unsupported mat files to customized Ripplelab mat File

%% Variables

% Figure Background Color
v_FigColor      = [212 208 200]/255;
str_Message     = ['It seems that the file that you are trying to open does not have '...
                'the required format. In order to continue, your data must be converted ' ...
                'to the appropriate RIPPLELAB MATLAB file structure. Therefore, ' ...
                'please select the proper information for each option. ' ...
                'Otherwise, please click on the cancel button.'];
            
st_FieldNames   = {'Select'};
st_DataFile     = struct;
Data            = [];
Header.Scale	= [];
Header.Sampling	= [];
Header.Labels	= [];
Header.IniTime	= [];
Header.Samples	= [];
Header.DataVar	= [];

st_Info         = [];

%% Building Figure
st_Figure.main      = figure(...                         
                    'MenuBar','None', ...
                    'ToolBar','None', ...
                    'NumberTitle','off', ...
                    'Name','Convert *.mat files', ...
                    'Color',v_FigColor,...
                    'Resize','off',...
                    'Units','normalized',...
                    'Position',[.3 .3 .3 .5],...
                    'CreateFcn',@f_LoadFileInfo);
                
%% Building Controls

st_Controls.Message	= uicontrol(...
                    'Parent', st_Figure.main,...
                    'Style','text', ...
                    'BackgroundColor',v_FigColor,...
                    'HorizontalAlignment','center',...
                    'String',str_Message,...
                    'Units','normalized',...
                    'Position',[.1 .7 .8 .25]);
                                
st_Controls.Panel	= uipanel(st_Figure.main,...
                    'BackgroundColor',v_FigColor,...
                    'HighlightColor',[.9 .9 .9],...
                    'Title','',...
                    'BorderType','etchedin',...
                    'BorderWidth',1,...
                    'Position',[.05 .15 .9 .55]);
                                                   
st_Controls.LoadBut	= uicontrol(st_Figure.main,...
                    'Style','pushbutton',...
                    'BackgroundColor',v_FigColor,...
                    'String','Load MAT File',...
                    'Units','normalized',...
                    'Position',[.2 .02 .2 .1],...
                    'CallBack',@f_LoadData);  
                
st_Controls.SaveBut	= uicontrol(st_Figure.main,...
                    'Style','pushbutton',...
                    'BackgroundColor',v_FigColor,...
                    'String','Save MAT File',...
                    'Units','normalized',...
                    'Position',[.4 .02 .2 .1],...
                    'CallBack',@f_SaveData);
                                                   
st_Controls.CancBut	= uicontrol(st_Figure.main,...
                    'Style','pushbutton',...
                    'BackgroundColor',v_FigColor,...
                    'String','Cancel',...
                    'Units','normalized',...
                    'Position',[.6 .02 .2 .1],...
                    'CallBack',@f_CloseFigure);
                
% Labels :::::::::::::::::::::::::::::::::::::::::::::::::::

st_Lbl.Data     = uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Data',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .80 .2 .1]);

st_Lbl.Scale     = uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Scale',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .65 .2 .1]);
            
st_Lbl.Sampling	= uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Sampling Rate',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .50 .2 .1]);

st_Lbl.Labels	= uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Labels (Optional)',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .35 .2 .1]);

st_Lbl.IniTime	= uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Record start time (Optional)',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .20 .2 .1]);

st_Lbl.Samples	= uicontrol(st_Controls.Panel,...
                'Style','text',...
                'BackgroundColor',v_FigColor,...
                'String','Number of samples',...
                'HorizontalAlignment','right',...
                'Units','normalized',...
                'Position',[.05 .05 .2 .1]);

% Controls Pop :::::::::::::::::::::::::::::::::::::::::::::::::::
                
            
st_Cnt.Data     = uicontrol(st_Controls.Panel,...
                'Style','popupmenu',...
                'String',st_FieldNames,...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .80 .25 .1],...
                'CallBack',@f_SelectInfo);
            
st_Cnt.Scale	= uicontrol(st_Controls.Panel,...
                'Style','popupmenu',...
                'String',st_FieldNames,...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .65 .25 .1],...
                'CallBack',@f_SelectInfo);
            
st_Cnt.Sampling	= uicontrol(st_Controls.Panel,...
                'Style','popupmenu',...
                'String',st_FieldNames,...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .50 .25 .1],...
                'CallBack',@f_SelectInfo);

st_Cnt.Labels	= uicontrol(st_Controls.Panel,...
                'Style','popupmenu',...
                'String',st_FieldNames,...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .35 .25 .1],...
                'CallBack',@f_SelectInfo);

st_Cnt.IniTime	= uicontrol(st_Controls.Panel,...
                'Style','edit',...
                'String','[0,0,0]',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .20 .25 .1]);

st_Cnt.Samples	= uicontrol(st_Controls.Panel,...
                'Style','edit',...
                'Enable','off',...
                'String',' ',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.3 .05 .25 .1]);
            
            
% Controls Edit :::::::::::::::::::::::::::::::::::::::::::::::::::
                
st_Edt.Scale	= uicontrol(st_Controls.Panel,...
                'Style','edit',...
                'String','1',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.56 .65 .3 .1]);
            
st_Edt.Sampling	= uicontrol(st_Controls.Panel,...
                'Style','edit',...
                'String',' ',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.56 .50 .3 .1]);

st_Edt.Labels	= uicontrol(st_Controls.Panel,...
                'Style','edit',...
                'String',' ',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.56 .35 .3 .1]);
            
% Controls help :::::::::::::::::::::::::::::::::::::::::::::::::::
                            
st_Hlp.Data     = uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .80 .12 .1],...
                'CallBack',@f_HelpInfo);
            
st_Hlp.Scale	= uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .65 .12 .1],...
                'CallBack',@f_HelpInfo);
            
st_Hlp.Sampling	= uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .50 .12 .1],...
                'CallBack',@f_HelpInfo);

st_Hlp.Labels	= uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .35 .12 .1],...
                'CallBack',@f_HelpInfo);

st_Hlp.IniTime	= uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .20 .12 .1],...
                'CallBack',@f_HelpInfo);

st_Hlp.Samples	= uicontrol(st_Controls.Panel,...
                'Style','pushbutton',...
                'String','?',...
                'HorizontalAlignment','center',...
                'Units','normalized',...
                'Position',[.87 .05 .12 .1],...
                'CallBack',@f_HelpInfo);

%% Wait until finish

warndlg('Please select a file with the required format',...
    'Reading Warning')

while isempty(st_Info) && ishandle(st_Figure.main)
    pause(0.1)
end
            
%% Functions 
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_LoadFileInfo(~,~)
        st_DataFile     = load(pst_SigPath);
        st_FieldNam     = fieldnames(st_DataFile);
        st_FieldNames   = vertcat(st_FieldNames,st_FieldNam);
        
    end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_SelectInfo(hObject,~)
        switch hObject
            case st_Cnt.Data
                if get(hObject,'Value') == 1
                    Data            = [];
                    Header.DataVar	= [];
                else        
                    Header.DataVar	= st_FieldNames{get(hObject,'Value')};
                    Data            = st_DataFile.(Header.DataVar);
                end
                
                if isempty(Data) || ~isnumeric(Data) || numel(size(Data)) > 2
                    warndlg(sprintf('%s %s %s',...
                        'Please select a numeric option.',...
                        'Data must be a 2D numeric matrix in which the shortest',...
                        'dimension corresponds to the channels'));
                    set(hObject,'Value',1)
                    
                    Data            = [];
                    Header.Samples	= [];
                    Header.DataVar	= [];
                    return
                end
                
                v_DataSize	= size(Data);
                
                if v_DataSize(2) > v_DataSize(1)
                    Data        = Data';
                    v_DataSize	= size(Data);
                end
                
                v_Labels	= cell(v_DataSize(2),1);
                
                for kk = 1:v_DataSize(2)
                    v_Labels{kk} = sprintf('Ch%i',kk); 
                end
                
                Header.Samples  = v_DataSize(1);
                Header.Labels   = v_Labels(:);
                
                v_Labels 	= vertcat(v_Labels(:)',repmat({','},size(v_Labels(:)')));
                v_Labels	= cell2mat(v_Labels(:)');
                                                
                set(st_Cnt.Samples,'String',mat2str(Header.Samples));
                set(st_Edt.Labels,'String',v_Labels);
                                
            case st_Cnt.Scale
                
                if get(hObject,'Value') == 1
                    set(st_Edt.Scale,'Enable','On')
                    return
                else
                    set(st_Edt.Scale,'Enable','Off')
                    Header.Scale = st_DataFile.(st_FieldNames{get(hObject,'Value')});
                end
                
                if ~isnumeric(Header.Scale) || numel(size(Header.Scale)) > 2
                    warndlg(sprintf('%s %s',...
                        'Please select a numeric option.',...
                        'Scale must be a numeric value indicating the Scale multiple'));
                    
                    set(hObject,'Value',1)
                    set(st_Edt.Scale,'Enable','On')
                    
                    Header.Scale = [];
                    return
                end
                
                set(st_Edt.Scale,'String',mat2str(Header.Scale))
                
            case st_Cnt.Sampling
                
                if get(hObject,'Value') == 1
                    set(st_Edt.Sampling,'Enable','On')
                    return
                else
                    set(st_Edt.Sampling,'Enable','Off')
                    Header.Sampling = st_DataFile.(st_FieldNames{get(hObject,'Value')});
                end
                
                if ~isnumeric(Header.Sampling) || numel(size(Header.Sampling)) > 2
                    warndlg(sprintf('%s %s',...
                        'Please select a numeric option.',...
                        'Sampling must be a numeric value indicating the sampling in Hz'));
                    
                    set(hObject,'Value',1)
                    set(st_Edt.Sampling,'Enable','On')
                    
                    Header.Sampling = [];
                    return
                end
                
                Header.Sampling     = Header.Sampling(1);
                
                set(st_Edt.Sampling,'String',mat2str(Header.Sampling))
                
            case st_Cnt.Labels
                if get(hObject,'Value') == 1
                    set(st_Edt.Labels,'Enable','On')
                    return
                else
                    set(st_Edt.Labels,'Enable','Off')
                    v_Labels = st_DataFile.(st_FieldNames{get(hObject,'Value')});
                end
                
                if ischar(v_Labels)
                    v_Labels   = f_GetSignalNamesArray(v_Labels);
                end
                
                if ~iscellstr(v_Labels)
                    warndlg(sprintf('%s %s %s',...
                        'Please select a variable.',...
                        'Labels can be a cell array of strings',...
                        'or a comma separated string list'));
                    
                    set(hObject,'Value',1)
                    set(st_Edt.Labels,'Enable','On')
                    return
                end
                    
                Header.Labels   = v_Labels(:);
                v_Labels        = vertcat(v_Labels(:)',repmat({','},size(v_Labels(:)')));
                v_Labels        = cell2mat(v_Labels(:)');
                                
                set(st_Edt.Labels,'String',v_Labels);
        end
        
    end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_SaveData(~,~)
        % Save Data
        
        Header.IniTime = eval(get(st_Cnt.IniTime,'String')); 

        if ~isvector(Header.IniTime) || ~isnumeric(Header.IniTime) || ...
                numel(Header.IniTime) ~= 3
            
            set(st_Cnt.IniTime,'String',[0,0,0])
            Header.IniTime  = [];
        end
        
        if isempty(Header.Scale)
            Header.Scale = str2double(get(st_Edt.Scale,'String'));
            if ~isnumeric(Header.Scale) || isnan(Header.Scale) || ...
                    numel(size(Header.Scale)) > 2
                warndlg(sprintf('%s %s',...
                    'Please select a numeric option.',...
                    'Scale must be a numeric value indicating the Scale multiple'));
                
                set(st_Edt.Scale,'Enable','On')
                
                Header.Scale = [];
                return
            end
        end
        if isempty(Header.Sampling)
            Header.Sampling = str2double(get(st_Edt.Sampling,'String'));
            if ~isnumeric(Header.Sampling) || isnan(Header.Sampling) || ...
                    numel(size(Header.Sampling)) > 2
                
                warndlg(sprintf('%s %s',...
                    'Please select a numeric option.',...
                    'Sampling must be a numeric value indicating the sampling in Hz'));
                
                set(st_Edt.Sampling,'Enable','On')
                
                Header.Sampling = [];
                return
            end
        end
        
        if isempty(Header.Labels)
            v_Labels = get(st_Edt.v_Labels,'String');
            
            if ischar(v_Labels)
                v_Labels   = f_GetSignalNamesArray(v_Labels);
            end
            
            if ~iscellstr(v_Labels)
                warndlg(sprintf('%s %s %s',...
                    'Please select a variable.',...
                    'Labels can be a cell array of strings',...
                    'or a comma separated string list'));
                
                set(hObject,'Value',1)
                set(st_Edt.Labels,'Enable','On')
                return
            end
            
        end
        
        if isempty(Data) || isempty(Header.Sampling) || isempty(Header.Labels) || ...
            isempty(Header.IniTime) || isempty(Header.Samples) || ...
            isempty(Header.Scale)
        
             warndlg(sprintf('%s %s %s',...
                'Please select the requested information.',...
                'If you need help for some of the options,',...
                'please click on the corresponding button with the question mark'));
            return
        end
        
        
        Header.Labels               = Header.Labels(:);
        
        [str_FilePath,str_FileName] = fileparts(pst_SigPath); 
               
        str_FileName                = strcat(str_FileName,'-RippleFile.mat');
        [str_FileName,str_FilePath] = uiputfile('*.mat',...
                                    'Save RIPPLELAB .mat file structure ',...
                                    fullfile(str_FilePath,str_FileName));
                                
        if isnumeric(str_FilePath)
            return
        end
        
        save(fullfile(str_FilePath,str_FileName),'Data','Header');
        
        f_CloseFigure([])
    end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_LoadData(~,~)
        % Save Data
        
        Header.IniTime = eval(get(st_Cnt.IniTime,'String')); 

        if ~isvector(Header.IniTime) || ~isnumeric(Header.IniTime) || ...
                numel(Header.IniTime) ~= 3
            
            set(st_Cnt.IniTime,'String',[0,0,0])
            Header.IniTime  = [];
        end
        
        if isempty(Header.Scale)
            Header.Scale = eval(get(st_Edt.Scale,'String'));
            if ~isnumeric(Header.Scale) || numel(size(Header.Scale)) > 2
                warndlg(sprintf('%s %s',...
                    'Please select a numeric option.',...
                    'Scale must be a numeric value indicating the Scale multiple'));
                
                set(hObject,'Value',1)
                set(st_Edt.Scale,'Enable','On')
                
                Header.Scale = [];
                return
            end
        end
        if isempty(Header.Sampling)
            Header.Sampling = eval(get(st_Edt.Sampling,'String'));
            if ~isnumeric(Header.Sampling) || numel(size(Header.Sampling)) > 2
                warndlg(sprintf('%s %s',...
                    'Please select a numeric option.',...
                    'Sampling must be a numeric value indicating the sampling in Hz'));
                
                set(hObject,'Value',1)
                set(st_Edt.Sampling,'Enable','On')
                
                Header.Sampling = [];
                return
            end
        end
        
        if isempty(Header.Labels)
            v_Labels = get(st_Edt.v_Labels,'String');
            
            if ischar(v_Labels)
                v_Labels   = f_GetSignalNamesArray(v_Labels);
            end
            
            if ~iscellstr(v_Labels)
                warndlg(sprintf('%s %s %s',...
                    'Please select a variable.',...
                    'Labels can be a cell array of strings',...
                    'or a comma separated string list'));
                
                set(hObject,'Value',1)
                set(st_Edt.Labels,'Enable','On')
                return
            end
        end
        
        if isempty(Data) || isempty(Header.Sampling) || isempty(Header.Labels) || ...
            isempty(Header.IniTime) || isempty(Header.Samples) || ...
            isempty(Header.Scale)
            
             warndlg(sprintf('%s %s %s',...
                'Please select the requested information.',...
                'If you need help for some of the options,',...
                'please click on the corresponding button with the question mark'));
            return
        end
        
        Header.Structure = '[f_ConvertMatFile]:RIPPLELABconvertedMATfile';
        st_Info = struct('Header',Header);
        
        f_CloseFigure('msg')
    end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_CloseFigure(hObject,~)
        % Close Figure
        if ishandle(hObject)
            st_Info  = 0;
        elseif isempty(hObject)
            st_Info  = 1;
        end
        close(st_Figure.main)
    end
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function f_HelpInfo(hObject,~)
        % Display Help Info
        
        switch hObject
            case st_Hlp.Data
                str_HelpMessage = sprintf('%s %s %s',...
                'Please select the variable in your file corresponding to the data.',...
                'Data must be a numeric matrix in which the shortest dimension',...
                'corresponds to the channels.');
            case st_Hlp.Scale
                str_HelpMessage = sprintf('%s %s %s',...
                'Please select the variable in your file corresponding',...
                'to the scale value. If required, set the <Select> option',...
                'in the popupmenu to insert a numeric value indicating the scale multiple.');            
            case st_Hlp.Sampling
                str_HelpMessage = sprintf('%s %s %s',...
                'Please select the variable in your file corresponding',...
                'to the sampling frequency. If required, set the <Select> option',...
                'in the popupmenu to insert a numeric value indicating the sampling in Hz.');
            case st_Hlp.Labels
                str_HelpMessage = sprintf('%s %s %s %s',...
                'Please select the variable in your file corresponding to the channel',...
                'labels. Labels can be a cell array of strings or a comma separated string list',... 
                'If required, set the <Select> option in the popupmenu',...
                'to insert a comma separated list with the channel names.');
            case st_Hlp.IniTime
                str_HelpMessage = sprintf('%s %s',...
                'This section is optional. If desired, insert the initial time',...
                'of the register as a MATLAB vector = [HH mm SS.ms].');
            case st_Hlp.Samples
                str_HelpMessage = sprintf('%s %s',...
                'This information is aumatically computed from your data indicating',...
                'the number of samples of your signal.');
        end
        
        helpdlg(str_HelpMessage,'Controls Help')

    end

end