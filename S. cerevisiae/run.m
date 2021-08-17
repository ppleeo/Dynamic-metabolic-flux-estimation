clc;
clear;

[data_RAW,~,~] = xlsread ('dummy_flux.xlsx',1);

[m,n]=size(data_RAW);

% m=300;

model = readCbModel('yeast_7.6_cobra.xml');
clc;


model=addReaction(model,'r_4051', 's_0434 -> ');  %% ATP
model=addReaction(model,'r_4052', 's_0394 -> ');  %% ADP
model=addReaction(model,'r_4053', 's_0423 -> ');  %% AMP
% model=addReaction(model,'r_4054', 's_1203 -> ');  %% NADH
% model=addReaction(model,'r_4055', 's_1198 -> ');  %% NAD
% model=addReaction(model,'r_4056', 's_1212 -> ');  %% NADPH
% model=addReaction(model,'r_4057', 's_1207 -> ');  %% NADP
model=addReaction(model,'r_4058', 's_0568 -> ');  %% G6P
model=addReaction(model,'r_4059', 's_0557 -> ');  %% F6P
model=addReaction(model,'r_4060', 's_0555 -> ');  %% FBP
model=addReaction(model,'r_4061', 's_0764 -> ');  %% GAP
model=addReaction(model,'r_4062', 's_2939 -> ');  %% DHAP
model=addReaction(model,'r_4063', 's_0260 -> ');  %% 3PG
model=addReaction(model,'r_4064', 's_0188 -> ');  %% 2PG
model=addReaction(model,'r_4065', 's_1360 -> ');  %% PEP
model=addReaction(model,'r_4066', 's_1399 -> ');  %% PYR
model=addReaction(model,'r_4067', 's_0335 -> ');  %% 6PG
model=addReaction(model,'r_4068', 's_0577 -> ');  %% RIBU5P
model=addReaction(model,'r_4069', 's_0581 -> ');  %% X5P
model=addReaction(model,'r_4070', 's_0415 -> ');  %% R5P
model=addReaction(model,'r_4071', 's_1427 -> ');  %% S7P
model=addReaction(model,'r_4072', 's_0551 -> ');  %% E4P
model=addReaction(model,'r_4073', 's_0567 -> ');  %% G1P
model=addReaction(model,'r_4074', 's_1541 -> ');  %% UDPG
model=addReaction(model,'r_4075', 's_0409 -> ');  %% T6P
% model=addReaction(model,'r_4076', 's_1520 -> ');  %% Trehalose
model=addReaction(model,'r_4077', 's_0524 -> ');  %% CIT
model=addReaction(model,'r_4078', 's_0941 -> ');  %% ISOCIST
model=addReaction(model,'r_4079', 's_0182 -> ');  %% AKG
model=addReaction(model,'r_4080', 's_1460 -> ');  %% SUC
model=addReaction(model,'r_4081', 's_0727 -> ');  %% FUM
model=addReaction(model,'r_4082', 's_0068 -> ');  %% MAL
% model=addReaction(model,'r_4083', 's_0376 -> ');  %% ACCOA
% model=addReaction(model,'r_4084', 's_0532 -> ');  %% COA
model=addReaction(model,'r_4085', 's_1039 -> ');  %% SER
model=addReaction(model,'r_4086', 's_1003 -> ');  %% GLY
model=addReaction(model,'r_4087', 's_0955 -> ');  %% ALA
model=addReaction(model,'r_4088', 's_1021 -> ');  %% LEU
model=addReaction(model,'r_4089', 's_0991 -> ');  %% GLU
model=addReaction(model,'r_4090', 's_0999 -> ');  %% GLN
model=addReaction(model,'r_4091', 's_1035 -> ');  %% PRO
model=addReaction(model,'r_4092', 's_0973 -> ');  %% ASP
model=addReaction(model,'r_4093', 's_1025 -> ');  %% LYS
model=addReaction(model,'r_4094', 's_1029 -> ');  %% MET
clc;
% model=changeRxnBounds(model,'r_1106', 0.097, 'b');  %% acetate
clc;
solverOK = changeCobraSolver('gurobi5','LP');

[mum,num]=size(model.rxns);
X = zeros(1,n);
Y = zeros(m,mum);

for i = 1:1:20
    i %#ok<*NOPTS>
    X = data_RAW(i,:);

    model=changeRxnBounds(model,'r_1714', X(2), 'b');  %% qs
    model=changeRxnBounds(model,'r_1166', -X(2), 'b');  %% qs
%     model=changeRxnBounds(model,'r_1697', X(3), 'b');  %% qCO2
%     model=changeRxnBounds(model,'r_1979', X(4), 'b');  %% qO2
    model=changeRxnBounds(model,'r_4051', X(5), 'b');  %% ATP
    model=changeRxnBounds(model,'r_4052', X(6), 'b');  %% ADP
    model=changeRxnBounds(model,'r_4053', X(7), 'b');  %% AMP
%     model=changeRxnBounds(model,'r_4054', X(8), 'b');  %% NADH
%     model=changeRxnBounds(model,'r_4055', X(9), 'b');  %% NAD
%     model=changeRxnBounds(model,'r_4056', X(10), 'b');  %% NADPH
%     model=changeRxnBounds(model,'r_4057', X(11), 'b');  %% NADP
    model=changeRxnBounds(model,'r_4058', X(12), 'b');  %% G6P
    model=changeRxnBounds(model,'r_4059', X(13), 'b');  %% F6P
    model=changeRxnBounds(model,'r_4060', X(14), 'b');  %% FBP
    model=changeRxnBounds(model,'r_4061', X(15), 'b');  %% GAP
    model=changeRxnBounds(model,'r_4062', X(16), 'b');  %% DHAP
    model=changeRxnBounds(model,'r_4063', X(17), 'b');  %% 3PG
    model=changeRxnBounds(model,'r_4064', X(18), 'b');  %% 2PG
    model=changeRxnBounds(model,'r_4065', X(19), 'b');  %% PEP
    model=changeRxnBounds(model,'r_4066', X(20), 'b');  %% PYR
    model=changeRxnBounds(model,'r_4067', X(21), 'b');  %% 6PG
    model=changeRxnBounds(model,'r_4068', X(22), 'b');  %% RIBU5P
    model=changeRxnBounds(model,'r_4069', X(23), 'b');  %% X5P
    model=changeRxnBounds(model,'r_4070', X(24), 'b');  %% R5P
    model=changeRxnBounds(model,'r_4071', X(25), 'b');  %% S7P
    model=changeRxnBounds(model,'r_4072', X(26), 'b');  %% E4P
    model=changeRxnBounds(model,'r_4073', X(27), 'b');  %% G1P
    model=changeRxnBounds(model,'r_4074', X(28), 'b');  %% UDPG
    model=changeRxnBounds(model,'r_4075', X(29), 'b');  %% T6P
%     model=changeRxnBounds(model,'r_4076', X(30), 'b');  %% Trehalose
    model=changeRxnBounds(model,'r_4077', X(31), 'b');  %% CIT
    model=changeRxnBounds(model,'r_4078', X(32), 'b');  %% ISOCIST
    model=changeRxnBounds(model,'r_4079', X(33), 'b');  %% AKG
    model=changeRxnBounds(model,'r_4080', X(34), 'b');  %% SUC
    model=changeRxnBounds(model,'r_4081', X(35), 'b');  %% FUM
    model=changeRxnBounds(model,'r_4082', X(36), 'b');  %% MAL
%     model=changeRxnBounds(model,'r_4083', X(37), 'b');  %% ACCOA
%     model=changeRxnBounds(model,'r_4084', X(38), 'b');  %% COA
    model=changeRxnBounds(model,'r_4085', X(39), 'b');  %% SER
    model=changeRxnBounds(model,'r_4086', X(40), 'b');  %% GLY
    model=changeRxnBounds(model,'r_4087', X(41), 'b');  %% ALA
    model=changeRxnBounds(model,'r_4088', X(42), 'b');  %% LEU
    model=changeRxnBounds(model,'r_4089', X(43), 'b');  %% GLU
    model=changeRxnBounds(model,'r_4090', X(44), 'b');  %% GLN
    model=changeRxnBounds(model,'r_4091', X(45), 'b');  %% PRO
    model=changeRxnBounds(model,'r_4092', X(46), 'b');  %% ASP
    model=changeRxnBounds(model,'r_4093', X(47), 'b');  %% LYS
    model=changeRxnBounds(model,'r_4094', X(48), 'b');  %% MET
    
    model=changeObjective(model, 'r_2111'); 
    FBAsolution = optimizeCbModel(model,'max','one');
    if size(FBAsolution.x) == [0 0] %#ok<*BDSCA>
        Y(i,:) = 0;
    else
        for k=1:mum
            Y(i,k) = FBAsolution.x(k);
        end
    end
end

xlswrite('flux_all.xlsx',Y,1,'B4');
clc;
plot(Y(:,2985),'-');  %% u
xlabel('time(s)');
ylabel('flux(mmol/g/h)');
axis([0 m 0 0.5]); 

'Done'