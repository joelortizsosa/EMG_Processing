clear all;
close all;
clc
path(path,'\\192.168.1.2\inria-emg\library\FastICA_2.5\FastICA_25'); % cargar el directorio de las funciones para fast ICA
path(path,'\\192.168.1.2\inria-emg\sujet17')

load Block1trial1;
load Block1trial2;
load Block1trial3;
load Block1trial4;
load Block1trial5;
load Block1trial6;
load Block1trial7;
load Block1trial8;
load Block1trial9;
load Block1trial10;
load Block1trial11;
load Block1trial12;
load Block1trial13;
load Block1trial14;
load Block1trial15;
load Block1trial16;

data1=Block1trial1;
data2=Block1trial2;
data3=Block1trial3;
data4=Block1trial4;
data5=Block1trial5;
data6=Block1trial6;
data7=Block1trial7;
data8=Block1trial8;
data9=Block1trial9;
data10=Block1trial10;
data11=Block1trial11;
data12=Block1trial12;
data13=Block1trial13;
data14=Block1trial14;
data15=Block1trial15;
data16=Block1trial16;

data = [data1;data2;data3;data4;data5;data6;data7;data8;data9;data10;data11;data12;data13;data14;data15;data16];

electrodo1 = remmean( data(:,4));
electrodo2 = remmean( data(:,5));
electrodo3 = remmean( data(:,6));
electrodo4 = remmean( data(:,7));
electrodo5 = remmean( data(:,8));



figure(1);

subplot(3,2,1)
 plot( electrodo1 ),title('electrodo 1');
subplot(3,2,2)
 plot( electrodo2 ),title('electrodo 2');
subplot(3,2,3)
 plot( electrodo3 ),title('electrodo 3');
subplot(3,2,4)
 plot( electrodo4 ),title('electrodo 4');
subplot(3,2,5)
 plot( electrodo5 ),title('electrodo 5');

x1=(electrodo1);
x2=(electrodo2);
x3=(electrodo3);
x4=(electrodo4);
x5=(electrodo5);

figure(2);

subplot(3,2,1)
 plot( x1 ),title('Signal Filtré Electrode 1');
subplot(3,2,2)
 plot( x2 ),title('Signal Filtré Electrode 2');
subplot(3,2,3)
 plot( x3 ),title('Signal Filtré Electrode 3');
subplot(3,2,4)
 plot( x4 ),title('Signal Filtré Electrode 4');
subplot(3,2,5)
 plot( x5 ),title('Signal Filtré Electrode 5');

%Aplicaremos la tecnica del valor eficaz para visualizar los picos donde se
%encuentran los voltages utilizando ventana de tiempo de 30ms, en nuestro
%caso, representaremos 10ms por 100 muestras, ya que nuestra grafica esta
%realizada con respecto a las muestras y no con el tiempo.

rms_x1 = rms(x1, 424, 0, 0)';%424
rms_x2 = rms(x2, 424, 0, 0)';
rms_x3 = rms(x3, 424, 0, 0)';
rms_x4 = rms(x4, 424, 0, 0)';
rms_x5 = rms(x5, 424, 0, 0)';

figure(3);

subplot(3,2,1)
 plot( rms_x1 ),title('Valor eficaz de señal de observacion X1');
subplot(3,2,2)
 plot( rms_x2 ),title('Valor eficaz de señal de observacion X2');
subplot(3,2,3)
 plot( rms_x3 ),title('Valor eficaz de señal de observacion X3');
subplot(3,2,4)
 plot( rms_x4 ),title('Valor eficaz de señal de observacion X4');
subplot(3,2,5)
 plot( rms_x5 ),title('Valor eficaz de señal de observacion X5');


% ahora haremos el calculo de las constantes A y W necesarias para
% encontrar las fuentes, haciendo uso de la funcion FASTICA, proporcionada
% por el departamento de informatica y ciencias de la computacion.
%http://research.ics.aalto.fi/ica/fastica/



%Creamos el vector de OBSERVACION, que esta dado como X(t) = [x1(t),....,x5(t)]'
%Ingresamos todas las señales observadas (x1....x5) dentro de la matriz
%mixedsig, quedando cada fila como fila de observacion:


mixedsig = [
             x1'
             x2'
             x3'
             x4'
             x5' 
                ];

    [A, W] = fastica(mixedsig);

%Descomponemos las señales en 5 fuentes independientes

source=W*mixedsig;
%calculamos la transpuesta para que cada columna sea una fuente
source=source';

source1 = source(:,1);
source2 = source(:,2);
source3 = source(:,3);
source4 = source(:,4);
source5 = source(:,5);

figure(4);

subplot(3,2,1)
 plot( source1 ),title('Signal source 1');
subplot(3,2,2)
 plot( source2 ),title('Signal source 2');
subplot(3,2,3)
 plot( source3 ),title('Signal source 3');
subplot(3,2,4)
 plot( source4 ),title('Signal source 4');
subplot(3,2,5)
 plot( source5 ),title('Signal source 5');
         Wn= 1.5/(2000/2);  % en 2000  hay algunos valores negativos, en 4000 se parece a la señal obtenida por la funcion rms
        [B,A] = butter(2,Wn);
 	    reco_emg1 = detrend(source1,'constant');
        reco_emg_filt1=filter(B,A,abs(source1));
 	    reco_emg2 = detrend(source2,'constant');
        reco_emg_filt2=filter(B,A,abs(source2));
 	    reco_emg3 = detrend(source3,'constant');
        reco_emg_filt3=filter(B,A,abs(source3));        
 	    reco_emg4 = detrend(source4,'constant');
        reco_emg_filt4=filter(B,A,abs(source4));        
 	    reco_emg5 = detrend(source5,'constant');
        reco_emg_filt5=filter(B,A,abs(source5));        


rms_source1 = abs(reco_emg_filt1); 
rms_source2 = abs(reco_emg_filt2);
rms_source3 = abs(reco_emg_filt3);
rms_source4 = abs(reco_emg_filt4);
rms_source5 = abs(reco_emg_filt5);


figure(5);

subplot(3,2,1)
 plot( rms_source1 ),title('RMS source 1');
subplot(3,2,2)
 plot( rms_source2 ),title('RMS source 2');
subplot(3,2,3)
 plot( rms_source3 ),title('RMS source 3');
subplot(3,2,4)
 plot( rms_source4 ),title('RMS source 4');
subplot(3,2,5)
 plot( rms_source5 ),title('RMS source 5');


fm_x=zeros(84800,1);
fm_y=zeros(84800,1);
 i=0;
 for j=1:84800 %1:424:84800
     
        fm_x(j,1) = ((data(j,10))); % pour la force en x est 2
        fm_y(j,1) = ((data(j,11)));% pour la force en y est 3
 end
rms_fuerzaX =fm_x/256;
rms_fuerzaY =fm_y/256;

%% 
%prediction multiple variables
source_multi = [rms_source1 rms_source2 rms_source3 rms_source4 rms_source5];
source_multi_sansICA = [rms_x1 rms_x2 rms_x3 rms_x4 rms_x5];


%MODELOS DE REGRESION
%REGRESION ROBUSTA CON ICA:
    
            lmModel_x = fitlm(source_multi, rms_fuerzaX, 'linear', 'RobustOpts', 'on')
            lmModel_y = fitlm(source_multi, rms_fuerzaY, 'linear', 'RobustOpts', 'on')
           
 J=[lmModel_x.Coefficients.Estimate lmModel_y.Coefficients.Estimate]
 save J J -v7
 save W W -v7
 
 
 %% APRENDIZAJE CON MODIFICACIONES EN LAS TRAYECTORIAS
% close all;
for i=1:16
% datos=Block1trial16;
eval(['datos=Block1trial',num2str(i),';'])
forceX=datos(:,10)/256;forceY=datos(:,11)/256;
 electrodo1 = remmean( datos(:,4));electrodo2 = remmean( datos(:,5));electrodo3 = remmean( datos(:,6));electrodo4 = remmean( datos(:,7));electrodo5 = remmean( datos(:,8));
        mixedsig = [ electrodo1'
                     electrodo2'
                     electrodo3'
                     electrodo4'
                     electrodo5'];
        source=W*mixedsig;   
        source=source';
        source1 = source(:,1); source2 = source(:,2); source3 = source(:,3); source4 = source(:,4); source5 = source(:,5);         
        elec = Filt_Enveloppe(source1,source2,source3,source4,source5);
        XY=[forceX forceY];
        emg=zeros(5300,5);
            for j=1:5300
            emg(j,:)=(XY(j,:)-[J(1,1) J(1,2)])*pinv(J(2:6,:)); 
            end
        eval(['error',num2str(i),'=elec-emg',';'])    
%         error1=elec-emg;
end        
% error =  ((error1 + error2 + error3 + error4 + error5 + error6 + error7 + error8 + error9 + error10 + error11 + error12 + error13 + error14 + error15 + error16)/16) ;

date1=Block1trial1;
date2=Block1trial2;
date3=Block1trial3;
date4=Block1trial4;
date5=Block1trial5;
date6=Block1trial6;
date7=Block1trial7;
date8=Block1trial8;
date9=Block1trial9;
date10=Block1trial10;
date11=Block1trial11;
date12=Block1trial12;
date13=Block1trial13;
date14=Block1trial14;
date15=Block1trial15;
date16=Block1trial16;

for i=1:16
% date=date8;
eval(['date=date',num2str(i),';'])
e1 = remmean( date(:,4));e2 = remmean( date(:,5));e3 = remmean( date(:,6));e4 = remmean( date(:,7));e5 = remmean( date(:,8));
        mixedsig = [ e1'; e2'; e3'; e4';e5'];
        s=W*mixedsig;           s=s';        s1 = s(:,1); s2 = s(:,2); s3 = s(:,3); s4 = s(:,4); s5 = s(:,5);         
        e = Filt_Enveloppe(s1,s2,s3,s4,s5);
% em2=[e(1:5300,:);e(5300:-1:1,:)];  
eval(['em',num2str(i),'=[e(1:5300,:);e(5300:-1:1,:)];'])
end
% er=[error8;error8(5300:-1:1,:)];
% er=error8(:,1);
% plot(er)
% for i=1:5
%     er(:,)
% end
error =  ((error1 + error2 + error3 + error4 + error5 + error6 + error7 + error8 + error9 + error10 + error11 + error12 + error13 + error14 + error15 + error16)/16) ;
% er=[error1;error1(5300:-1:1,:);error8;error8(5300:-1:1,:)];
er=[error1;error1(5300:-1:1,:);error2;error2(5300:-1:1,:);error3;error3(5300:-1:1,:);error4;error4(5300:-1:1,:);error5;error5(5300:-1:1,:);error6;error6(5300:-1:1,:);error7;error7(5300:-1:1,:);error8;error8(5300:-1:1,:);error9;error9(5300:-1:1,:);error10;error10(5300:-1:1,:);error11;error11(5300:-1:1,:);error12;error12(5300:-1:1,:);error13;error13(5300:-1:1,:);error14;error14(5300:-1:1,:);error15;error15(5300:-1:1,:);error16;error16(5300:-1:1,:)];
% er=[error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:)];
for i=1:5
    err=er(:,i);
    eval(['me',num2str(i),'=fitlm(([em1;em2;em3;em4;em5;em6;em7;em8;em9;em10;em11;em12;em13;em14;em15;em16]),err, ''quadratic'', ''RobustOpts'', ''on'');'])
    eval(['me=predict(me',num2str(i),',([em1;em2;em3;em4;em5;em6;em7;em8;em9;em10;em11;em12;em13;em14;em15;em16]));'])
    figure;
    plot(er(:,i))
    hold on;
     plot(me,'r')
end
 disp('fin de aprendizaje')%Mostrar cuando termina el aprendizaje
K=[me1.Coefficients.Estimate me2.Coefficients.Estimate me3.Coefficients.Estimate me4.Coefficients.Estimate me5.Coefficients.Estimate]
save K K -v7
%Simulacion de correccion

for i=1:16
% datos=Block1trial16;
eval(['datos=Block1trial',num2str(i),';'])
forceX=datos(:,10)/256;forceY=datos(:,11)/256; 
figure;
hold on;
plot(forceX(:,1),forceY(:,1))
 electrodo1 = remmean( datos(:,4));electrodo2 = remmean( datos(:,5));electrodo3 = remmean( datos(:,6));electrodo4 = remmean( datos(:,7));electrodo5 = remmean( datos(:,8));
        mixedsig = [ electrodo1'
                     electrodo2'
                     electrodo3'
                     electrodo4'
                     electrodo5'];
        source=W*mixedsig;   
        source=source';
        source1 = source(:,1); source2 = source(:,2); source3 = source(:,3); source4 = source(:,4); source5 = source(:,5);         
        elec = Filt_Enveloppe(source1,source2,source3,source4,source5);

        for h=1:5300
            XY(h,:)=([1 elec(h,:)]*J);
        end

            hold on;
            plot(XY(:,1),XY(:,2),'k')

        X_Y=[];
        for h=1:5300

        e=[elec(h,1) elec(h,2) elec(h,3) elec(h,4) elec(h,5) elec(h,1)*elec(h,2) elec(h,1)*elec(h,3) elec(h,1)*elec(h,4) elec(h,1)*elec(h,5) elec(h,2)*elec(h,3) elec(h,2)*elec(h,4) elec(h,2)*elec(h,5) elec(h,3)*elec(h,4) elec(h,3)*elec(h,5) elec(h,4)*elec(h,5) elec(h,1).^2 elec(h,2).^2 elec(h,3).^2 elec(h,4).^2 elec(h,5).^2];
            emg(h,:)=elec(h,:)-[1 (e)]*K;
            X_Y(h,:)=([1 emg(h,:)]*J);
        end

            hold on;
            plot(X_Y(:,1),X_Y(:,2),'r')        
        
end  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 