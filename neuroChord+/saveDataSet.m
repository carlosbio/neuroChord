filename = 'bm5.wav';    % Nome do ficheiro
[f_audio,sideinfo] = wav_to_audio('', 'data_WAV/', filename);   % Converte o ficheiro
shiftFB = estimateTuning(f_audio);  % Estima a afina??o

paramPitch.winLenSTMSP = 4410;  % Frequ?ncia
paramPitch.shiftFB = shiftFB;
paramPitch.visualize = 1;
[f_pitch,sideinfo] = ...
    audio_to_pitch_via_FB(f_audio,paramPitch,sideinfo); % Determina o pitch

% Aumento do grau de invari?ncia do timbre

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

%visualizeCRP(f_CRPSmoothed,parameterVis);    % Visualiza??o do espectro
disp(f_CRPSmoothed);
velho = load ('dataSet.mat');
novo = reshape(f_CRPSmoothed,[60,1]);
%dataTeste = reshape(f_CRPSmoothed,[60,1]);
dataSet = [velho.dataSet novo];
save('dataSet.mat','dataSet');