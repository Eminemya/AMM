function varargout = signalViewerCov003(varargin)
% SIGNALVIEWERCOV003 MATLAB code for signalViewerCov003.fig
%      SIGNALVIEWERCOV003, by itself, creates a new SIGNALVIEWERCOV003 or raises the existing
%      singleton*.
%
%      H = SIGNALVIEWERCOV003 returns the handle to a new SIGNALVIEWERCOV003 or the handle to
%      the existing singleton*.
%
%      SIGNALVIEWERCOV003('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNALVIEWERCOV003.M with the given input arguments.
%
%      SIGNALVIEWERCOV003('Property','Value',...) creates a new SIGNALVIEWERCOV003 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before signalViewerCov003_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to signalViewerCov003_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help signalViewerCov003

% Last Modified by GUIDE v2.5 28-Oct-2014 11:34:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signalViewerCov003_OpeningFcn, ...
                   'gui_OutputFcn',  @signalViewerCov003_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before signalViewerCov003 is made visible.
function signalViewerCov003_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to signalViewerCov003 (see VARARGIN)

% Choose default command line output for signalViewerCov003
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
rootDir = '/home/nwadhwa/Downloads/Vidmag2/Data/';
vidName = 'guitar.avi';
noiseSigma = 0.05;
vr = VideoReader(fullfile(rootDir, vidName));
frame = mean(im2single(vr.read(1)),3);
[buildPyr, ~] = octave4PyrFunctions(23,23);

impulse = zeros(23,23);
impulse(12,12) = 1;
[impulseResponse, pind1] = buildPyr(impulse);
[buildPyr, ~] = octave4PyrFunctions(size(frame,1), size(frame,2));
[pyr, pind2] = buildPyr(mean(im2single(frame),3));
for k = 1:4
    axes(eval(sprintf('handles.axes%d', k)));
    imagesc(real(pyrBand(impulseResponse, pind1, k+1)));
    colormap('gray');
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end
for k = 1:12
    axes(eval(sprintf('handles.axes%d', k+4)));
    imagesc(abs(pyrBand(pyr,pind2, k+1)));
    colormap('gray');
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end

% Display frames
axes(handles.axes17);
hold all
h = imagesc(1:vr.Width, vr.Height:-1:1, vr.read(1));
axis image;
set(h,'HitTest','off');
%set(gcf,'WindowButtonDownFcn',@axes17_ButtonDownFcn);
set(h,'ButtonDownFcn',@axes17_ButtonDownFcn)


% Data computation

[buildPyr,~] = octave4PyrFunctions(vr.Height, vr.Width);
data = get(handles.figure1, 'UserData');
data.vr = vr;
data.init = true;
data.buildPyr = buildPyr;
orientations = 4;
data.predictedRatios = predictedSigmaOct4(vr.Height, vr.Width, orientations);
data.noiseSigma = noiseSigma;
set(handles.figure1, 'UserData',data);
getBands(handles);
recomputePrecisionMatrix(handles);
setCurrentPt(10,10,handles);



% UIWAIT makes signalViewerCov003 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = signalViewerCov003_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function getBands(handles)
    bands = [];
    for k = 1:12
       if(get(eval(sprintf('handles.checkbox%d', k)), 'Value'));
           bands = [bands; k+1];
       end
    end
    data = get(handles.figure1, 'UserData'); 
    data.bands = bands;
    set(handles.figure1, 'UserData', data);


function onCheck(handles)
    getBands(handles);    
    recomputeAndReplot(handles);



% --- Executes on mouse press over axes background.
function axes17_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

% handles    structure with handles and user data (see GUIDATA)
a = get(hObject, 'CurrentPoint');
h = getHeight(handles);
w = getWidth(handles);

y = h-min(max(round(a(1,2)),1),h)+1;
x = min(max(round(a(1,1)),1),w);
setCurrentPt(x,y,handles);

function setCurrentPt(x,y,handles)
    h = getHeight(handles);
    w = getWidth(handles);
    data = get(handles.figure1, 'UserData');
    data.x = x;
    data.y = y;
    set(handles.figure1,'UserData', data);
    axes(handles.axes17);
    persistent PTHH
    if (data.init)       
        data.init= false; 
        set(handles.figure1, 'UserData',data);
    else
        delete(PTHH); 
    end
    PTHH = scatter(x,h-y+1,'fill','red');
    plotCovarianceMatrix(x,y,handles);
    plotContours(x,y,handles);
    updatePostProbs(x,y,handles);

function [x,y] = getCurrentPt(handles)
    data = get(handles.figure1, 'UserData');
    x = data.x;
    y = data.y;

function plotCovarianceMatrix(x,y,handles)
    axes(handles.axes18);       
    N =100;
    xax = linspace(-3,3,N);
    yax = linspace(-3,3,N);
    [XX, YY] = meshgrid(xax,yax);

    data = get(handles.figure1, 'UserData');
    V = data.precisionMatrix(:,:,y,x);

    pdf=  exp(-(V(1,1)*XX.^2+V(2,2).*YY.^2+2*V(1,2)*XX.*YY));
    pdf = pdf./sum(pdf(:));
    imagesc(xax,yax,pdf);
    xlabel('Velocity (x)');
    ylabel('Velocity (y)');
    title('Covariance of Velocity');
    colormap('jet');
    %colorbar;
    axis equal;

function plotContours(x,y, handles)
    axes(handles.axes19);  
    cla;
    N =100;
    xax = linspace(-3,3,N);
    yax = linspace(-3,3,N);
    [XX, YY] = meshgrid(xax,yax);

    data = get(handles.figure1, 'UserData');
    V = data.precisionMatrix(:,:,y,x);
    mu = data.mu(:,:,y,x)
    
    val = exp(-1/2);
    pdf=  exp(-(V(1,1)*(XX-mu(1)).^2+V(2,2).*(YY-mu(2)).^2+2*V(1,2)*(XX-mu(1)).*(YY-mu(2))));    
    contour(xax, -yax, pdf, [val, val],'red'); hold on;
    CC = winter(numel(data.Sx));
    for l = 1:numel(data.Sx)
       tempPDF = exp(-(data.Sx{l}(y,x).*XX+data.Sy{l}(y,x).*YY-data.St{l}(y,x)).^2./(2*data.phit_SD{l}(y,x).^2));
       contour(xax,-yax, tempPDF, [val, val], 'color', CC(l,:));
    end
    
    xlabel('Velocity (x)');
    ylabel('Velocity (y)');
    title('Contour Plots of PDF');
    
    %colorbar;
    axis equal;

function updatePostProbs(x,y,handles)
    data = get(handles.figure1, 'UserData');
    bands = data.bands;
    postProbs = data.postProb(:,y,x);
    postForm = -ones(13,1);
    for k = 1:numel(bands)
       postForm(bands(k)) = postProbs(k);
    end
    for k = 2:13
        set(eval(sprintf('handles.text%d', k)), 'String', sprintf('%0.3f',(postForm(k))));
    end

    
function height = getHeight(handles)
    data = get(handles.figure1, 'UserData');
    height = data.vr.Height;

function width = getWidth(handles)
    data = get(handles.figure1, 'UserData');
    width = data.vr.Width;


function noiseSigma = getNoiseSigma(handles)
    data = get(handles.figure1, 'UserData');
    noiseSigma = data.noiseSigma;



function setNoiseSigma(noiseSigma, handles)
    data = get(handles.figure1, 'UserData');
    data.noiseSigma = round(1000*noiseSigma)/1000;
    set(handles.figure1, 'UserData', data);
    
    
function replotPt(handles)
    [x,y] = getCurrentPt(handles);
    plotCovarianceMatrix(x,y,handles);
    plotContours(x,y,handles);
    updatePostProbs(x,y,handles);
    
function recomputeAndReplot(handles)
    recomputePrecisionMatrix(handles);
    replotPt(handles);
    
function recomputePrecisionMatrix(handles)
    data = get(handles.figure1, 'UserData'); 
    [~,data.precisionMatrix, data.mu, data.postProb, data.Sx, data.Sy, data.St, data.phit_SD] = frameToCov003(data.vr, data.noiseSigma, data.bands, [1 10], data.buildPyr, data.predictedRatios);
    set(handles.figure1, 'UserData',data);    

    

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    noiseSigma = get(hObject, 'Value');
    setNoiseSigma(noiseSigma, handles);
    % Set edit text value
    set(handles.edit1, 'String', sprintf('%0.3f', (noiseSigma)));
    1;
    recomputeAndReplot(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
    noiseSigma = str2num(get(hObject, 'String'));
    setNoiseSigma(noiseSigma, handles);
    % Set slider value
    set(handles.slider1, 'Value', noiseSigma);
    recomputeAndReplot(handles);
    
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes18_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
100


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox11



% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
onCheck(handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox12
