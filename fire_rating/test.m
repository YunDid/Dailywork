% HistogramISIn( AnSt_Label_E_00159_12_ID_20_Str_Acquisition_1_Electrode_R_nr, 5, 10.^(-5:.05:1.5) )

clc;
clear;
close all

maindir='E:\Projects\Matlab\data\Network_burst\7-23\1-before-spon-10min\before-spon-10min.mat';%stimulus marker & data
a=load(maindir);
Namess=fieldnames(a);
spike=[];

for k=1:length(Namess)
    Names=Namess{k,1};
    data=extractfield(a,Names);
    spike=[spike data];
end

spike=sort(spike);
spike(spike==0)=[];
N = (10:20);
Steps = 10.^(-5:.05:1.5);
HistogramISIn(spike,N,Steps)

NN=10;
isi_nn=0.001;
[Burst, SpikeBurstNumber] = BurstDetectISIn( spike, NN, isi_nn);
save ('Burst-7-21-3first-learning-L1.mat','Burst')  