% -------------------------------------------------------------------------
%
%    Funcao recordAudio que gera um ficheiro em formato wave capturado
%                   em tempo real atraves de um microfone
%
% -------------------------------------------------------------------------
%
%   Trabalho realizado no ambito da disciplina de Conhecimento e Raciocinio
%
%   ISEC - Curso de Engenharia Informatica, ano lectivo 2014/2015
%
%   Autor: Carlos Gil (9805004) Carlos da Silva (21220319)
%
%   Turma: PL4
%
%   Data de realizacao: 03/07/2015
%
%   NOTA: O presente trabalho trata-se de uma implementacao de um programa
%   que permite a deteccao de acordes musicais baseando-se na representacao
%   cromatica de cada acorde, usando-se para o efeito uma rede neuronal
%   feedforward usando as funcoes da NNTool, assim como a Chroma Toolbox
%   que permite a captura, transformacao, normalizacao e tratamento dos
%   dados adquiridos em tempo real ou atraves de ficheiros wave.
%
% -------------------------------------------------------------------------

function record = recordAudio()

fs = 44100;
bits = 16;

recObj = audiorecorder(fs,bits,1);
                
%Record your voice for 5 seconds.

disp('Ready...');
pause(1);
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');


%# Store data in double-precision array.
meuRecord = getaudiodata(recObj);
%disp(size(meuRecord));

audiowrite('data_WAV\audio.wav', meuRecord, fs);
%wavwrite(meuRecord, fs, bits,'meuWav.wav');


disp('Start playing.')
play(recObj);
disp('Stop playing.')

y = getaudiodata(recObj);

%plot(y);

record = meuRecord;