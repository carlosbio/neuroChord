function varargout = neuroChordV2(varargin)
% NEUROCHORDV2 MATLAB code for neuroChordV2.fig
%      NEUROCHORDV2, by itself, creates a new NEUROCHORDV2 or raises the existing
%      singleton*.
%
%      H = NEUROCHORDV2 returns the handle to a new NEUROCHORDV2 or the handle to
%      the existing singleton*.
%
%      NEUROCHORDV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEUROCHORDV2.M with the given input arguments.
%
%      NEUROCHORDV2('Property','Value',...) creates a new NEUROCHORDV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before neuroChordV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to neuroChordV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help neuroChordV2

% Last Modified by GUIDE v2.5 20-Jun-2015 15:05:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @neuroChordV2_OpeningFcn, ...
                   'gui_OutputFcn',  @neuroChordV2_OutputFcn, ...
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


% --- Executes just before neuroChordV2 is made visible.
function neuroChordV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to neuroChordV2 (see VARARGIN)

% Choose default command line output for neuroChordV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes neuroChordV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
imshow('neuroChord_bk.jpg', 'Parent', handles.axes2);
set(handles.textChord,'FontSize', 20);

% --- Outputs from this function are returned to the command line.
function varargout = neuroChordV2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in botaoGravar.
function botaoGravar_Callback(hObject, eventdata, handles)
% hObject    handle to botaoGravar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = 44100;
bits = 16;

recObj = audiorecorder(fs,bits,1);
set(handles.textChord,'FontSize', 20);
set(handles.textChord,'String', 'Preparar...');
pause(2);
set(handles.textChord,'String', 'A gravar...');
recordblocking(recObj, 2);
set(handles.textChord,'String', 'Fim da gravacao...');
pause(2);

%# Store data in double-precision array.
meuRecord = getaudiodata(recObj);

audiowrite('data_WAV\sample.wav', meuRecord, fs);

y = getaudiodata(recObj);
plot(y);


set(handles.textChord,'String', '"Chordifique..."');

% --- Executes on button press in botaoChord.
function botaoChord_Callback(hObject, eventdata, handles)
% hObject    handle to botaoChord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clear
%close all

filename = 'sample.wav';    % Nome do ficheiro
[f_audio,sideinfo] = wav_to_audio('', 'data_WAV/', filename);   % Converte o ficheiro
shiftFB = estimateTuning(f_audio);  % Estima a afinacao

paramPitch.winLenSTMSP = 4410;  % Frequencia
paramPitch.shiftFB = shiftFB;
paramPitch.visualize = 1;
[f_pitch,sideinfo] = ...
    audio_to_pitch_via_FB(f_audio,paramPitch,sideinfo); % Determina o pitch

% Aumento do grau de invariancia do timbre

paramCRP.coeffsToKeep = [55:120];
paramCRP.visualize = 1;
paramCRP.inputFeatureRate = sideinfo.pitch.featureRate;
[f_CRP,sideinfo] = pitch_to_CRP(f_pitch,paramCRP,sideinfo);

% Limpeza (smoothing e downsamplig) do sinal adquirido

paramSmooth.winLenSmooth = 21;
paramSmooth.downsampSmooth = 5;
paramSmooth.inputFeatureRate = sideinfo.CRP.featureRate;
[f_CRPSmoothed, featureRateSmoothed] = ...
    smoothDownsampleFeature(f_CRP,paramSmooth);
parameterVis.featureRate = featureRateSmoothed;

visualizeCRP(f_CRPSmoothed,parameterVis);    % Visualizacao do espectro

disp(f_CRPSmoothed);

%Converte a matriz de saida do Chroma [5x12] numa matriz vertical [60x1]
dataActual = reshape(f_CRPSmoothed,[60,1]);


acorde = ChordificadorV2(dataActual);  % Injecta a matriz na rede neuronal

set(handles.textChord,'FontSize', 50);
set(handles.textChord,'String', acorde);

%close all

disp(acorde);

function textChord_Callback(hObject, eventdata, handles)
% hObject    handle to textChord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textChord as text
%        str2double(get(hObject,'String')) returns contents of textChord as a double


% --- Executes during object creation, after setting all properties.
function textChord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textChord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in botaoPlay.
function botaoPlay_Callback(hObject, eventdata, handles)
% hObject    handle to botaoPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[y,Fs] = audioread('data_WAV/sample.wav');
sound(y,Fs);