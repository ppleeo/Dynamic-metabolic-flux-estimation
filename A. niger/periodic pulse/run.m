clc;
clear;

[data_RAW,~,~] = xlsread ('dummyflux.xlsx',1);
% [data_RAW,~,~] = xlsread ('dcdt-GEM.xlsx',1);

% model=xls2model('iPL1210D.xls');
model = readCbModel('iHL1210D.xml');
clc;
model=addReaction(model,'biomass', 'biomass[c] -> ');

% model=changeRxnBounds(model,'biomass', 0.01, 'b');  %% 比生长速率设置
% model=changeRxnBounds(model,'R1591', -0.606, 'b');  %% gluc为唯一碳源
% model=changeRxnBounds(model,'R1584', 2.75, 'b');  %% co2
% model=changeRxnBounds(model,'R9', 0, 'l');%% 
% model=changeRxnBounds(model,'R1593', 0.000293, 'b');%% glyml
model=changeRxnBounds(model,'R1646', 0.399, 'b');  %% Oxalate
model=changeRxnBounds(model,'R1291', 0, 'b');  %% nadp[m] <=> nadph[m]
model=changeRxnBounds(model,'R1292', 0, 'b');  %% nadp <=> nadph
model=changeRxnBounds(model,'R1586', 0, 'b');  %% urea input
model=changeRxnBounds(model,'R1587', 0, 'b');  %% hno3 input
model=changeRxnBounds(model,'R1118', 0, 'b');  %% gl3p + fad <=> t3p2 + fadh2 可消除无碳源输入时有菌体生长
model=changeRxnBounds(model,'R1526', 0, 'b');  %% cit[m] + mal => cit + mal[m]
clc;
solverOK = changeCobraSolver('gurobi5','LP');

X = zeros(1,39);
% Y = zeros(120,16);
Y = zeros(600,1837);
for i = 1:1:600
    i %#ok<*NOPTS>
    X = data_RAW(i,:);
    model=changeRxnBounds(model,'R1591', X(1), 'b');  %% gluc为唯一碳源qs
    model=changeRxnBounds(model,'R1802', X(2), 'b');  %% glc
    model=changeRxnBounds(model,'R1803', X(3), 'b');  %% g6p
    model=changeRxnBounds(model,'R1804', X(4), 'b');  %% f6p
    model=changeRxnBounds(model,'R1805', X(5), 'b');  %% fdp
    model=changeRxnBounds(model,'R1806', X(6), 'b');  %% t3p1
    model=changeRxnBounds(model,'R1807', X(7), 'b');  %% 3pg
    model=changeRxnBounds(model,'R1808', X(8), 'b');  %% pep
    model=changeRxnBounds(model,'R1809', X(9), 'b');  %% cit
    model=changeRxnBounds(model,'R1810', X(10), 'b');  %% akg
    model=changeRxnBounds(model,'R1811', X(11), 'b');  %% suc
    model=changeRxnBounds(model,'R1812', X(12), 'b');  %% fum
    model=changeRxnBounds(model,'R1813', X(13), 'b');  %% mal
    model=changeRxnBounds(model,'R1814', X(14), 'b');  %% 6pg
    model=changeRxnBounds(model,'R1815', X(15), 'b');  %% r5p
    model=changeRxnBounds(model,'R1816', X(16), 'b');  %% s7p
    model=changeRxnBounds(model,'R1817', X(17), 'b');  %% e4p
    model=changeRxnBounds(model,'R1818', X(18), 'b');  %% atp
    model=changeRxnBounds(model,'R1819', X(19), 'b');  %% adp
    model=changeRxnBounds(model,'R1820', X(20), 'b');  %% amp
    model=changeRxnBounds(model,'R1821', X(21), 'b');  %% nadh
    model=changeRxnBounds(model,'R1822', X(22), 'b');  %% nad
    model=changeRxnBounds(model,'R1588', X(23), 'b');  %% O2
    model=changeRxnBounds(model,'R1584', X(24), 'b');  %% CO2
    model=changeRxnBounds(model,'R1823', X(25), 'b');  %% Lysine
    model=changeRxnBounds(model,'R1824', X(26), 'b');  %% Glutamate
    model=changeRxnBounds(model,'R1825', X(27), 'b');  %% Proline
    model=changeRxnBounds(model,'R1826', X(28), 'b');  %% Glutamine
    model=changeRxnBounds(model,'R1827', X(29), 'b');  %% Ornithine
    model=changeRxnBounds(model,'R1828', X(30), 'b');  %% Aspartate
    model=changeRxnBounds(model,'R1829', X(31), 'b');  %% Asparagine
    model=changeRxnBounds(model,'R1830', X(32), 'b');  %% Methionine
    model=changeRxnBounds(model,'R1831', X(33), 'b');  %% Threonine
    model=changeRxnBounds(model,'R1832', X(34), 'b');  %% iso-Leucine
    model=changeRxnBounds(model,'R1833', X(35), 'b');  %% Alanine
    model=changeRxnBounds(model,'R1834', X(36), 'b');  %% Valine
%     model=changeRxnBounds(model,'R1835', X(37), 'b');  %% Leucine
    model=changeRxnBounds(model,'R1536', X(38), 'b');  %% Serine
%     model=changeRxnBounds(model,'R1537', X(39), 'b');  %% Glycine
    
    model=changeObjective(model, 'biomass'); 
    FBAsolution = optimizeCbModel(model,'max','one');
    if size(FBAsolution.x) == [0 0] %#ok<*BDSCA>
        Y(i,:) = 0;
    else
        for k=1:1837
            Y(i,k) = FBAsolution.x(k);
        end
    end
end
xlswrite('flux_all.xlsx',Y);
clc;
plot(Y(:,1),'-');
xlabel('time(s)');
ylabel('flux(mmol/g/h)');
axis([0 600 0 5]); 

'Done'