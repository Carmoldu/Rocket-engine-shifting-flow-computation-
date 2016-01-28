%Computation of combustion and nozzle expansion of C4H10. Gas enters the
%combustion chanmber with the estequiometrically necessary quantity  of O2.
%It is necessary to include the HGS functions, which can be
%found at https://github.com/OpenLlop/HGS .


%Data
%Input gas at the combustion chamber
Species={'C4H10(iso)','H2O','CO2','CO','O2','H2','OH','H','O'};
Tin=300; %[K]
Pchamber=10; %[bar]
MolsIn=[1,0,0,0,13/2,0,0,0,0];

%Exhaust conditions
Pamb=1; %[bar]
Pexhaust=Pamb; %[bar]



% 1. COMPUTATUIN OF TEMPERATURE AND COMPOSITION OF GAS AT THE OUTLET OF THE
% COMBUSTION CHAMBER
[Tchamber,MolsCombustion] = hgsTp(Species,MolsIn,Tin,Pchamber);

fprintf('1. 1. COMPUTATUIN OF TEMPERATURE AND COMPOSITION OF GAS AT THE OUTLET OF THE COMBUSTION CHAMBER\n');
fprintf('Combustion Chamber temperature:                           Tcambra = %.2f [K]  \n',Tchamber);
fprintf('Gas composition ath the combustion chamber outlet:           ');
MolsCombustion
fprintf('\n');


% 2. WITH 'SHIFTING FLOW' APROXIMATIONS, COMPUTE COMPOSITION, VELOCITY,
% MACH AND TEMPERATURE OF THE GAS AT THE OUTLET OF THE NOZZLE

[Texhaust,MolsExhaust,Vexhaust,MachExhaust]=hgsisentropic( Species,MolsCombustion,Tchamber,Pchamber,Pexhaust,'shifting');

fprintf('2. WITH SHIFTING FLOW APROXIMATIONS, COMPUTE COMPOSITION, VELOCITY,MACH AND TEMPERATURE OF THE GAS AT THE OUTLET OF THE NOZZLE\n');
fprintf('Composition:           ');
MolsExhaust
fprintf('\n');
fprintf('Temperature:                     Texhaust = %.2f [K]  \n',Texhaust);
fprintf('Velocity:                       Vexhaust = %.2f [m/s]  \n',Vexhaust);
fprintf('Mach:                            MachExhaust = %.2f   \n',MachExhaust);

% 3. GRAPHYCALLY REPRESENT TEMPERATURE AND MACH ALONG THE NOZZLE AS A
% FUNCTION OF ITS PRESSURE. IDENTIFY THE THROAT

T=zeros(19,1);
Mach=zeros(19,1);
P=zeros(19,1);

for i=1:+1:19
    P(i)=Pchamber+(Pexhaust-(Pchamber+1))*(i-1)/20;
    
    [T(i),~,~,Mach(i)]=hgsisentropic( Species,MolsCombustion,Tchamber,Pchamber,P(i),'shifting');
end

figure('name','3. GRAPHYCALLY REPRESENT TEMPERATURE AND MACH ALONG THE NOZZLE AS A FUNCTION OF ITS PRESSURE. IDENTIFY THE THROAT','numberTitle','off')
subplot(2,1,1)
plot(P, T,'-r');
title('Temperature VS pressure')
xlabel('Pressure [bar]')
ylabel('Temperature [K]')
set(gca,'XDir','Reverse')
subplot(2,1,2)
plot(P, Mach,'-b');
title('Mach VS pressure')
xlabel('Pressure [bar]')
ylabel('Mach')
set(gca,'XDir','Reverse')

