% -------------------------------------------------------------------------
%
%        Funcao funcaoTreinoneuroChord treina uma rede neuronal 
%         usando as funcoes da NNTool durante 10 vezes
%      sucessivas ou quando obtiver uma accuracy superior a 90%
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

function funcaoTreinoneuroChord
    
    accuracy = 0;
    cont = 0;
    
    % Le o dataSet dos samples de acordes que foram gravados
    % Sao estes que vao ser usados para treinar a rede
    
    load('dataSet.mat');
    
    % Le o dataSet dos targets correspondentes aos samples de acordes que foram gravados
    % Tambem serao usados para o treino da rede
    
    load('targetAll.mat');
    
%=========================================================================
%   Configuracoes da Rede  
%=========================================================================    
    %net = feedforwardnet([10 10 10]);
    net = feedforwardnet([10 10]);
    net.trainFcn = 'trainlm';
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'tansig';
    net.layers{3}.transferFcn = 'tansig';
    %net.layers{4}.transferFcn = 'purelin';

    % NUMERO DE EPOCAS DE TREINO
    
    %net.trainParam.lr = 0.01;
    net.trainParam.epochs = 100;
    
    net.divideParam.trainRatio = 0.90;
    net.divideParam.valRatio = 0.05;
    net.divideParam.testRatio = 0.05;
    
%========================================================================

    % Para ocultar a janela da Tool
    
    net.trainParam.showWindow = false;              
    
    
    while((accuracy<90) && (cont<10))
        % Treinar a rede
        [net,tr] = train(net, dataSet, targetAll);

        % Visualizar a rede

        %view(net)

        % Simular a rede

        out=sim(net,dataSet);

        % Converte valores da rede em 0 e 1

        for i=1:size(out,2)
            out(:,i) = (out(:,i) >= 0.5);
        end

        % Calcula a percentagem de amostras correctas

        certos = 0;

        % Percorre toda a matriz de saida

        for i=1:size(out,2)
            conta = 0;
            for j=1:size(out,1)
                % Quando encontra uma posicao com o valor...
                if (out(j,i) == 1)
                    % Verifica se na mesma posicao do Target tambem tem o valor
                    % 1
                    if(out(j,i) == targetAll(j,i))
                        conta = conta + 1;
                    end
                end
            end
            % Se encontrou 3 valores "1" nas posicoes correctas, considera-se
            % que a saida e valida
            if (conta == 3)
                certos = certos + 1;
            end
        end

        % Calcula a percentagem de saidas correctas

        accuracy = certos/size(out,2)*100;
        fprintf('Precisao total %f\n', accuracy)
    end
    save('rede.mat','net');
    cont = cont + 1;
end