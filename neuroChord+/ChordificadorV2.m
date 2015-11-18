% -------------------------------------------------------------------------
%
%        Funcao Chordificador que cria, treina e testa uma RN feedforward 
%                       usando as funcoes da NNTool
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

function chord = ChordificadorV2 (dataTeste) % Recebe a matriz cromatica do acordes
    
    % Le o dataSet da rede j? treinada
    disp('Load da Rede:');
    load('rede.mat');
    
    % Le o dataSet dos targets correspondentes a cada acorde
    
     disp('\nLoad do target final:');
     load('targetFinal.mat');
    
    % SIMULAR A REDE COM OS DADOS DO ACORDE TOCADO PELO USER
    
    disp('\nSimula Rede:');
    out = sim(net, dataTeste);
    
    out = (out >= 0.5);
    
    % Calcula a percentagem de amostras correctas
 
    % Percorre toda a matriz de saida
    
    acorde = 0;
    
    for i=1:size(targetFinal,2)
        conta = 0;
        for j=1:size(targetFinal,1)
            % Quando encontra uma posicao com o valor "1" no target...
            if (targetFinal(j,i) == 1)
                % Verifica se na mesma posicao do Output tambem tem o valor
                % 1
                if(targetFinal(j,i) == out(j))
                    conta = conta + 1;
                end
            end
        end
        % Se encontrou 3 valores "1" nas posicoes correctas, considera-se
        % que a saida e valida e o acorde e identificado pelo numero da
        % coluna
        if (conta == 3)
            acorde = i;
            break;
        end
    end
    
    accuracy = conta/3*100;
    fprintf('Precisao Teste %f\n', accuracy)
    
    % Valida qual o acorde identificado e faz o return desse valor para a
    % funcao principal
    
    switch (acorde)
        case 1
            chord = 'C';
        case 2
            chord = 'Cm';
        case 3
            chord = 'D';
        case 4
            chord = 'Dm';            
        case 5
            chord = 'E';
        case 6
            chord = 'Em';
        case 7
            chord = 'F';
        case 8
            chord = 'Fm';
        case 9
            chord = 'G';
        case 10
            chord = 'Gm';
        case 11
            chord = 'A';
        case 12
            chord = 'Am';
        case 13
            chord = 'B';
        case 14
            chord = 'Bm';
        otherwise
            chord = 'Indefinido...';
    end
end