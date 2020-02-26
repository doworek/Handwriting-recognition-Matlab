function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 06-Jan-2019 13:09:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global XDrawn;
XDrawn = zeros(28, 28);
userDraw(handles);
set(gcf,'color',[1 0.9 0.9])

% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) %DRAW AXES
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function userDraw(handles)
axis([0 27 0 27]);
A=handles.axes1; % axes1 is tag of my axes
set(A,'buttondownfcn',@start_pencil)
set(gca,'Color','w')
set(gca,'XColor','none')
set(gca,'YColor','none')
%set(gca,'Color',[1 0.9 0.9])
set(gca,'xtick',[])
set(gca,'ytick',[])

function start_pencil(src,eventdata)
global XDrawn;
coords=get(src,'currentpoint'); %since this is the axes callback, src=gca
x=coords(1,1,1);
y=coords(1,2,1);
XDrawn(int64(x) + 1, int64(y) + 1) = 1;
XDrawn(int64(x+1) + 1, int64(y+1) + 1) = 1;

r=line(x, y, 'color', [0.2 0.2 0.6], 'LineWidth', 6, 'hittest', 'off'); %turning     hittset off allows you to draw new lines that start on top of an existing line.
set(gcf,'windowbuttonmotionfcn',{@continue_pencil,r})
set(gcf,'windowbuttonupfcn',@done_pencil)

function continue_pencil(src,eventdata,r)
%Note: src is now the figure handle, not the axes, so we need to use gca.
global XDrawn;
coords=get(gca,'currentpoint'); %this updates every time i move the mouse
x=coords(1,1,1);
y=coords(1,2,1);
if (x > 0) && (y > 0) && (x < 27) && (y < 27)
    XDrawn(int64(x) + 1, int64(y) + 1) = 1;
    XDrawn(int64(x+1) + 1, int64(y+1) + 1) = 1;
end
%get the line's existing coordinates and append the new ones.
lastx=get(r,'xdata');  
lasty=get(r,'ydata');
newx=[lastx x];
newy=[lasty y];
set(r,'xdata',newx,'ydata',newy);

function done_pencil(src,evendata)
%all this funciton does is turn the motion function off 
set(gcf,'windowbuttonmotionfcn','')
set(gcf,'windowbuttonupfcn','')


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) %EXIT
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %TRAIN
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
promptMessage = sprintf('Do you want to train new NN? It can take a while.');
titleBarCaption = 'Continue?';
button = questdlg(promptMessage, titleBarCaption, 'OK', 'Cancel', 'OK');
if strcmpi(button, 'OK')
 % Load MNIST.
    inputValues = loadMNISTImages('train-images-idx3-ubyte');
    labels = loadMNISTLabels('train-labels-idx1-ubyte');
    inputValues = imbinarize(inputValues);

    % Transform the labels to correct target values.
    targetValues = zeros(10, size(labels, 1));
    for n = 1: size(labels, 1)
        targetValues(labels(n) + 1, n) = 1;
    end
    
    % Choose form of MLP:
    numberOfHiddenUnits = 300;
    
    % Choose appropriate parameters.
    learningRate = 0.1;
    
    % Choose activation function.
    activationFunction = @ReLU;
    dActivationFunction = @dReLU;
    
    % Choose batch size and epochs. Remember there are 60k input values.
    batchSize = 100;
    epochs = 15000;
    
   set(handles.figure1, 'pointer', 'watch')
drawnow;
  [hiddenWeights, outputWeights] = TrainProcess(activationFunction, dActivationFunction, numberOfHiddenUnits, inputValues, targetValues, epochs, batchSize, learningRate);
set(handles.figure1, 'pointer', 'arrow')
    dlmwrite('hiddenW.dat', hiddenWeights);
    dlmwrite('outputW.dat', outputWeights);
end
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %STATISTICS
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  % Load validation set.
    inputValues = loadMNISTImages('t10k-images-idx3-ubyte');
    labels = loadMNISTLabels('t10k-labels-idx1-ubyte');
    inputValues = imbinarize(inputValues);
    
    activationFunction = @ReLU;
    hiddenWeights = dlmread('hiddenW.dat');
    outputWeights = dlmread('outputW.dat');
    
    [correctlyClassified, classificationErrors] = Validate(activationFunction, hiddenWeights, outputWeights, inputValues, labels);
         accuracy = round(correctlyClassified/100,2); 

   procentString = sprintf('%.2f', accuracy);
    set(handles.text4, 'String', classificationErrors);
    set(handles.text5, 'String', correctlyClassified);
    set(handles.text6, 'String', procentString);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles) %CHECK
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X XDrawn;
X = XDrawn;

    hiddenWeights = dlmread('hiddenW.dat');
    outputWeights = dlmread('outputW.dat');
    activationFunction = @ReLU;

    X = logical(X);
    X = rot90(X);
    X = reshape(X,[784 1]);
    dlmwrite('X.dat', X);
    [number] = Check(activationFunction, hiddenWeights, outputWeights, X);
    set(handles.text9, 'String', number);  

    % --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) %CHECK BMP
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;

    hiddenWeights = dlmread('hiddenW.dat');
    outputWeights = dlmread('outputW.dat');
    activationFunction = @ReLU;
    
    X = reshape(X,[784 1]);
   % dlmwrite('X.dat', X);
    [number] = Check(activationFunction, hiddenWeights, outputWeights, X);
    set(handles.text9, 'String', number);
    
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles) %CLEAR
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global XDrawn;
XDrawn = zeros(28, 28);
cla(handles.axes1, 'reset');
userDraw(handles);
set(gcf,'color',[1 0.9 0.9])
set(handles.text9, 'String', '');

% This creates the 'background' axes
ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to this toolbox, you can use another image file instead.
I=imread('clouds_background.jpg');
imagesc(I)
colormap gray
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
            'visible','off')


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;
[FileName,PathName] = uigetfile('*.bmp', 'Select the bitmap');

if (~strcmp(FileName, '') || ~strcmp(PathName, ''))
    pathToImg = strcat(PathName, FileName);
    X = imread(pathToImg);
    X = imresize(X,[28 28]);
    X=~X;
    imshow(pathToImg, 'Parent', handles.axes1);
end
    
    %KONIEC
