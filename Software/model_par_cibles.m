clear all;
close all;
clc
path(path,'\\192.168.1.2\inria-emg\library\FastICA_2.5\FastICA_25'); % cargar el directorio de las funciones para fast ICA
path(path,'\\192.168.1.2\inria-emg\sujet17\datos')
% load W_excelent_48valeur;
%  W_comb=W_comb;
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


% data1=[Block1trial1(1:425,:);Block1trial1(3200:5300,:)];
% data2=[Block1trial2(1:425,:);Block1trial2(3200:5300,:)];
% data3=[Block1trial3(1:425,:);Block1trial3(3200:5300,:)];
% data4=[Block1trial4(1:425,:);Block1trial4(3200:5300,:)];
% data5=[Block1trial5(1:425,:);Block1trial5(3200:5300,:)];
% data6=[Block1trial6(1:425,:);Block1trial6(3200:5300,:)];
% data7=[Block1trial7(1:425,:);Block1trial7(3200:5300,:)];
% data8=[Block1trial8(1:425,:);Block1trial8(3200:5300,:)];
% data9=[Block1trial9(1:425,:);Block1trial9(3200:5300,:)];
% data10=[Block1trial10(1:425,:);Block1trial10(3200:5300,:)];
% data11=[Block1trial11(1:425,:);Block1trial11(3200:5300,:)];
% data12=[Block1trial12(1:425,:);Block1trial12(3200:5300,:)];
% data13=[Block1trial13(1:425,:);Block1trial13(3200:5300,:)];
% data14=[Block1trial14(1:425,:);Block1trial14(3200:5300,:)];
% data15=[Block1trial15(1:425,:);Block1trial15(3200:5300,:)];
% data16=[Block1trial16(1:425,:);Block1trial16(3200:5300,:)];



% load Block1trial5;
% load Block1trial6;
% load Block1trial7;
% load Block1trial8;
% load Block1trial9;
% load Block1trial10;
% load Block1trial11;
% load Block1trial12;
% load Block1trial13;
% load Block1trial14;
% load Block1trial15;
% load Block1trial16;
% % load Block3trial5;
% % load Block3trial6;
% % load Block3trial7;
% % load Block3trial8;
% % load Block3trial9;
% % load Block3trial10;
% % load Block3trial11;
% % load Block3trial12;
% % load Block3trial13;
% % load Block3trial14;
% % load Block3trial15;
% % load Block3trial16;
% % load Block3trial17;
% % load Block3trial18;
% % load Block3trial19;
% % load Block3trial20;
% % load Block3trial21;
% % load Block3trial22;
% % load Block3trial23;
% % load Block3trial24;
% % load Block3trial25;
% % load Block3trial26;
% % load Block3trial27;
% % load Block3trial28;
% % load Block3trial29;
% % load Block3trial30;
% % load Block3trial31;
% % load Block3trial32;
% % load Block3trial33;
% % load Block3trial34;
% % load Block3trial35;
% % load Block3trial36;
% % load Block3trial37;
% % load Block3trial38;
% % load Block3trial39;
% % load Block3trial40;
% % load Block3trial41;
% % load Block3trial42;
% % load Block3trial43;
% % load Block3trial44;
% % load Block3trial45;
% % load Block3trial46;
% % load Block3trial47;
% % load Block3trial48;
% % data1=Block1trial1;
% % data2=Block1trial2;
% % data3=Block1trial3;
% % data4=Block1trial4;
% 
% data1= Block1trial5;
% data2= Block1trial6;
% data3= Block1trial7;
% data4= Block1trial8;
% data5= Block1trial9;
% data6= Block1trial10;
% data7=Block1trial11;
% data8= Block1trial12;
% data9= Block1trial13;
% data10= Block1trial14;
% data11= Block1trial15;
% data12= Block1trial16;



% data5=Block3trial5;
% data6=Block3trial6;
% data7=Block3trial7;
% data8=Block3trial8;
% data9=Block3trial9;
% data10=Block3trial10;
% data11=Block3trial11;
% data12=Block3trial12;
% data13=Block3trial13;
% data14=Block3trial14;
% data15=Block3trial15;
% data16=Block3trial16;
% data17=Block3trial17;
% data18=Block3trial18;
% data19=Block3trial19;
% data20=Block3trial20;
% data21=Block3trial21;
% data22=Block3trial22;
% data23=Block3trial23;
% data24=Block3trial24;
% data25=Block3trial25;
% data26=Block3trial26;
% data27=Block3trial27;
% data28=Block3trial28;
% data29=Block3trial29;
% data30=Block3trial30;
% data31=Block3trial31;
% data32=Block3trial32;
% data33=Block3trial33;
% data34=Block3trial34;
% data35=Block3trial35;
% data36=Block3trial36;
% data37=Block3trial37;
% data38=Block3trial38;
% data39=Block3trial39;
% data40=Block3trial40;
% data41=Block3trial41;
% data42=Block3trial42;
% data43=Block3trial43;
% data44=Block3trial44;
% data45=Block3trial45;
% data46=Block3trial46;
% data47=Block3trial47;
% data48=Block3trial48;

% 
% for i=1:11
%     for j=1:5300
%         datam1(j,i)=(data1(j,i)+data2(j,i)+data3(j,i))/3;
%     end
% end
% 
% for i=1:11
%     for j=1:5300
%         datam2(j,i)=(data4(j,i)+data5(j,i)+data6(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam3(j,i)=(data7(j,i)+data8(j,i)+data9(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam4(j,i)=(data10(j,i)+data11(j,i)+data12(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam5(j,i)=(data13(j,i)+data14(j,i)+data15(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam6(j,i)=(data16(j,i)+data17(j,i)+data18(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam7(j,i)=(data19(j,i)+data20(j,i)+data21(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam8(j,i)=(data22(j,i)+data23(j,i)+data24(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam9(j,i)=(data25(j,i)+data26(j,i)+data27(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam10(j,i)=(data28(j,i)+data29(j,i)+data30(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam11(j,i)=(data31(j,i)+data32(j,i)+data33(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam12(j,i)=(data34(j,i)+data35(j,i)+data36(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam13(j,i)=(data37(j,i)+data38(j,i)+data39(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam14(j,i)=(data40(j,i)+data41(j,i)+data42(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam15(j,i)=(data43(j,i)+data44(j,i)+data45(j,i))/3;
%     end
% end
% for i=1:11
%     for j=1:5300
%         datam16(j,i)=(data46(j,i)+data47(j,i)+data48(j,i))/3;
%     end
% end

% datam1=datam1(3000:4999,1:11);
% datam2=datam2(3000:4999,1:11);
% datam3=datam3(3000:4999,1:11);
% datam4=datam4(3000:4999,1:11);
% datam5=datam5(3000:4999,1:11);
% datam6=datam6(3000:4999,1:11);
% datam7=datam7(3000:4999,1:11);
% datam8=datam8(3000:4999,1:11);
% datam9=datam9(3000:4999,1:11);
% datam10=datam10(3000:4999,1:11);
% datam11=datam11(3000:4999,1:11);
% datam12=datam12(3000:4999,1:11);
% datam13=datam13(3000:4999,1:11);
% datam14=datam14(3000:4999,1:11);
% datam15=datam15(3000:4999,1:11);
% datam16=datam16(3000:4999,1:11);

% data = [datam1;datam2;datam3;datam4;datam5;datam6;datam7;datam8;datam9;datam10;datam11;datam12;datam13;datam14;datam15;datam16];
% data = [data1;data2;data3;data4;data5;data6;data7;data8;data9;data10;data11;data12;data13;data14;data15;data16;data17;data18;data19;data20;data21;data22;data23;data24;data25;data26;data27;data28;data29;data30;data31;data32;data33;data34;data35;data36;data37;data38;data39;data40;data41;data42;data43;data44;data45;data46;data47;data48];
data = [data1;data2;data3;data4;data5;data6;data7;data8;data9;data10;data11;data12;data13;data14;data15;data16];




% data=[data1;data2;data3;data4;data5;data6;data7;data8];

% Proceso para centrar las se�ales, restando la media a cada �chantionage
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

%Filtrado de las se�ales, utilizando la tecnica Wavelet, para la extraccion
%del ruido.

%se�ales observadas, a partir de las cuales se procedera aencontrar las
%fuentes
% x1=func_denoise_wavelet(electrodo1);
% x2=func_denoise_wavelet(electrodo2);
% x3=func_denoise_wavelet(electrodo3);
% x4=func_denoise_wavelet(electrodo4);
% x5=func_denoise_wavelet(electrodo5);

x1=(electrodo1);
x2=(electrodo2);
x3=(electrodo3);
x4=(electrodo4);
x5=(electrodo5);

figure(2);

subplot(3,2,1)
 plot( x1 ),title('Signal Filtr� Electrode 1');
subplot(3,2,2)
 plot( x2 ),title('Signal Filtr� Electrode 2');
subplot(3,2,3)
 plot( x3 ),title('Signal Filtr� Electrode 3');
subplot(3,2,4)
 plot( x4 ),title('Signal Filtr� Electrode 4');
subplot(3,2,5)
 plot( x5 ),title('Signal Filtr� Electrode 5');

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
 plot( rms_x1 ),title('Valor eficaz de se�al de observacion X1');
subplot(3,2,2)
 plot( rms_x2 ),title('Valor eficaz de se�al de observacion X2');
subplot(3,2,3)
 plot( rms_x3 ),title('Valor eficaz de se�al de observacion X3');
subplot(3,2,4)
 plot( rms_x4 ),title('Valor eficaz de se�al de observacion X4');
subplot(3,2,5)
 plot( rms_x5 ),title('Valor eficaz de se�al de observacion X5');


% ahora haremos el calculo de las constantes A y W necesarias para
% encontrar las fuentes, haciendo uso de la funcion FASTICA, proporcionada
% por el departamento de informatica y ciencias de la computacion.
%http://research.ics.aalto.fi/ica/fastica/



%Creamos el vector de OBSERVACION, que esta dado como X(t) = [x1(t),....,x5(t)]'
%Ingresamos todas las se�ales observadas (x1....x5) dentro de la matriz
%mixedsig, quedando cada fila como fila de observacion:


mixedsig = [
             x1'
             x2'
             x3'
             x4'
             x5' 
                ];

    [A, W] = fastica(mixedsig);

%Descomponemos las se�ales en 5 fuentes independientes

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
         Wn= 1.5/(2000/2);  % en 2000  hay algunos valores negativos, en 4000 se parece a la se�al obtenida por la funcion rms
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
%     reco_emg_filt_norm = (reco_emg_filt - repmat(xymm_pul(:,3)', size(reco_emg_filt,1),1) )./(repmat(xymm_pul(:,4)', size(reco_emg_filt,1),1)-repmat(xymm_pul(:,3)', size(reco_emg_filt,1),1)); 
% figure(5);
% plot( reco_emg_filt)
% rms_source1 = rms(source1, 424, 0, 0);
% figure(6)
% plot(rms_source1,'r');
 
 %Ahora calculamos la RMS de estas se�ales
 
% rms_source1 = rms(source1, 424, 0, 0)'; % 424
% rms_source2 = rms(source2, 424, 0, 0)';
% rms_source3 = rms(source3, 424, 0, 0)';
% rms_source4 = rms(source4, 424, 0, 0)';
% rms_source5 = rms(source5, 424, 0, 0)';

rms_source1 = abs(reco_emg_filt1); % 424
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

%% 
% fm_x=zeros(200,1);
% fm_y=zeros(200,1);
%  i=0;
%  for j=1:424:84800 %1:424:84800
%      i=i+1;
%       try
%         fm_x(i,1) = (mean(data(j:j+423,10))); % pour la force en x est 2
%         fm_y(i,1) = (mean(data(j:j+423,11)));% pour la force en y est 3
%      end
%  end
% rms_fuerzaX =fm_x/256;
% rms_fuerzaY =fm_y/256;

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
% force_multi=[rms_fuerzaX zeros(200,1) zeros(200,1) zeros(200,1) zeros(200,1)];
%  modelfun = @(b,x)(b(1)+exp(-b(2)*x(:,1)) +exp(-b(3)*x(:,2))  +exp(-b(4)*x(:,3)) +exp(-b(5)*x(:,4)) +exp(-b(6)*x(:,5)) );
%             modelfun_X = @(b,x)(b(1)+b(2)*exp(x(:,1)) +b(3)*exp(x(:,2))  +b(4)*exp(x(:,3)) +b(5)*exp(x(:,4)) +b(6)*exp(x(:,5)) );
%             modelfun_Y = @(b,x)(b(1)+b(2)*exp(-x(:,1)) +b(3)*exp(-x(:,2))  +b(4)*exp(-x(:,3)) +b(5)*exp(-x(:,4)) +b(6)*exp(-x(:,5)) );
%  modelfun = @(b,x)(b(1)+exp(-b(2)*x) +b(3)+b(4)+b(5)+b(6));
% source_multi = [rms_source1];
% source_multi = [rms_x2 rms_x3 rms_x4];
% beta0=[-1 1 -1]
% lmModel_x =NonLinearModel.fit(source_multi,rms_fuerzaX,modelfun,beta0)

% lmModel_x_sansICA = fitlm(source_multi_sansICA, rms_fuerzaX, 'linear', 'RobustOpts', 'on')
% lmModel_y_sansICA = fitlm(source_multi_sansICA, rms_fuerzaY, 'linear', 'RobustOpts', 'on')
% modelfun = @(b,x)b(1) + b(2)*x(:,1).^b(3) + b(4)*x(:,2).^b(5)+ b(6)*x(:,3).^b(7)+ b(8)*x(:,4).^b(9)+ b(10)*x(:,5).^b(11);
%              beta0_X = [11.6890150754407 9.81792193788962 1.76995046160371 -3.39027125998076 -6.41146745666976 0.269582000192562];
%              beta0_Y = [20.2259280767224 5.71053010098596 -6.59523594489293 -3.88632120672145 -2.47510326755246 13.6840615462526];
%             % 
%             lmModel_x = fitnlm(source_multi,rms_fuerzaX, modelfun_X,beta0_X)
%             lmModel_y = fitnlm(source_multi,rms_fuerzaY,modelfun_Y,beta0_Y)

%MODELOS DE REGRESION
%REGRESION ROBUSTA CON ICA:
    
            lmModel_x = fitlm(source_multi, rms_fuerzaX, 'linear', 'RobustOpts', 'on')
            lmModel_y = fitlm(source_multi, rms_fuerzaY, 'linear', 'RobustOpts', 'on')
           
% %REGRESION ROBUSTA SIN ICA:            
%             lmModel_x_sansICA = fitlm(source_multi_sansICA, rms_fuerzaX, 'linear', 'RobustOpts', 'on')
%             lmModel_y_sansICA = fitlm(source_multi_sansICA, rms_fuerzaY, 'linear', 'RobustOpts', 'on')
%          
% %REGRESION CON MINIMOS CUADRADOS ORDINARIOS
% %CON ICA:
%             lmModel_x_LS = fitlm(source_multi, rms_fuerzaX, 'linear', 'RobustOpts','ols')
%             lmModel_y_LS = fitlm(source_multi, rms_fuerzaY, 'linear', 'RobustOpts','ols')
% 
% %SIN ICA
%             lmModel_x_LS_sansICA = fitlm(source_multi_sansICA, rms_fuerzaX, 'linear', 'RobustOpts','ols')
%             lmModel_y_LS_sansICA = fitlm(source_multi_sansICA, rms_fuerzaY, 'linear', 'RobustOpts','ols')

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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
%%
% x_predit = predict(lmModel_x, source_multi);
% %error existente entre la prediccion y el valor real u observado
% d_n=rms_fuerzaX-x_predit; 
% %media arimetica de los errores
% media_d_n = mean(d_n)
% m1=media_d_n;
% %desviacion standar
% temp1=0;
% 
% for i=1:50
%     temp=(d_n(i) -media_d_n).^2;
%     temp1=temp1+temp;
% end
% % desviacion =  sqrt((1/49)*temp1);
% desviacion=10.4054;
% des=std(d_n)
% %distribucion normal de los errores
% normal=zeros(50,1);
% for i=1:50
%  normal(i,1)= exp( -0.5* ((d_n(i) -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi)) ;
% end
% 
% % fun = @(x) exp( -0.5* ((x -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi));
% %  for i=1:50
% % normal(i,1) = integral(fun,-inf,45.8364);
% %  end
% % p1=pdf('normal',normal(38,1),media_d_n,desviacion)
% % 
% %   figure;plot(normal,d_n);
% norm = normpdf(d_n,media_d_n,des);
% figure(19);plot(d_n,norm,'r.');
% 
% norm = normcdf(d_n,media_d_n,des);
% figure(20);plot(d_n,norm,'r.');
% %%
% x_predit = predict(lmModel_x_sansICA, source_multi_sansICA);
% %error existente entre la prediccion y el valor real u observado
% d_n=rms_fuerzaX-x_predit; 
% %media arimetica de los errores
% media_d_n = mean(d_n)
% m2=media_d_n;
% %desviacion standar
% temp1=0;
% 
% for i=1:50
%     temp=(d_n(i) -media_d_n).^2;
%     temp1=temp1+temp;
% end
% % desviacion =  sqrt((1/49)*temp1);
% desviacion=10.4054;
% des=std(d_n)
% %distribucion normal de los errores
% normal=zeros(50,1);
% for i=1:50
%  normal(i,1)= exp( -0.5* ((d_n(i) -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi)) ;
% end
% 
% % fun = @(x) exp( -0.5* ((x -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi));
% %  for i=1:50
% % normal(i,1) = integral(fun,-inf,45.8364);
% %  end
% % p1=pdf('normal',normal(38,1),media_d_n,desviacion)
% % 
% %   figure;plot(normal,d_n);
% norm = normpdf(d_n,media_d_n,des);
% figure(19);hold on;plot(d_n,norm,'b.');
% 
% norm = normcdf(d_n,media_d_n,des);
% figure(20);hold on;plot(d_n,norm,'b.');
% %%
% x_predit = predict(lmModel_x_LS, source_multi);
% %error existente entre la prediccion y el valor real u observado
% d_n=rms_fuerzaX-x_predit; 
% %media arimetica de los errores
% media_d_n = mean(d_n)
% m3=media_d_n;
% %desviacion standar
% temp1=0;
% 
% for i=1:50
%     temp=(d_n(i) -media_d_n).^2;
%     temp1=temp1+temp;
% end
% % desviacion =  sqrt((1/49)*temp1);
% desviacion=10.4054;
% des=std(d_n)
% %distribucion normal de los errores
% normal=zeros(50,1);
% for i=1:50
%  normal(i,1)= exp( -0.5* ((d_n(i) -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi)) ;
% end
% 
% % fun = @(x) exp( -0.5* ((x -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi));
% %  for i=1:50
% % normal(i,1) = integral(fun,-inf,45.8364);
% %  end
% % p1=pdf('normal',normal(38,1),media_d_n,desviacion)
% % 
% %   figure;plot(normal,d_n);
% 
% norm = normpdf(d_n,media_d_n,des);
% figure(19);hold on;plot(d_n,norm,'g.');
% 
% norm = normcdf(d_n,media_d_n,des);
% figure(20);hold on;plot(d_n,norm,'g.');
% %%
% x_predit = predict(lmModel_x_LS_sansICA, source_multi_sansICA);
% %error existente entre la prediccion y el valor real u observado
% d_n=rms_fuerzaX-x_predit; 
% %media arimetica de los errores
% media_d_n = mean(d_n)
% m4=media_d_n;
% %desviacion standar
% temp1=0;
% 
% for i=1:50
%     temp=(d_n(i) -media_d_n).^2;
%     temp1=temp1+temp;
% end
% % desviacion =  sqrt((1/49)*temp1);
% desviacion=10.4054;
% des=std(d_n)
% %distribucion normal de los errores
% normal=zeros(50,1);
% for i=1:50
%  normal(i,1)= exp( -0.5* ((d_n(i) -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi)) ;
% end
% 
% % fun = @(x) exp( -0.5* ((x -media_d_n) /desviacion).^2 )./(des*sqrt(2*pi));
% %  for i=1:50
% % normal(i,1) = integral(fun,-inf,45.8364);
% %  end
% % p1=pdf('normal',normal(38,1),media_d_n,desviacion)
% % 
% %   figure;plot(normal,d_n);
% 
% norm = normpdf(d_n,media_d_n,des);
% figure(19);hold on;plot(d_n,norm,'y.');l1=legend(strcat('Robust with ICA mean=', num2str(m1)),strcat('Robust without ICA mean=', num2str(m2)),strcat('Ordinary Least Square with ICA mean=', num2str(m3)),strcat('Ordinary Least Square without ICA mean=', num2str(m4)) )
% 
% norm = normcdf(d_n,media_d_n,des);
% figure(20);hold on;plot(d_n,norm,'y.');l2=legend(strcat('Robust with ICA mean=', num2str(m1)),strcat('Robust without ICA mean=', num2str(m2)),strcat('Ordinary Least Square with ICA mean=', num2str(m3)) ,strcat('Ordinary Least Square without ICA mean=', num2str(m4)))
% 
% %%
% figure(21);plotResiduals(lmModel_y,'probability')
% figure(22);plotResiduals(lmModel_y_sansICA,'probability')
% figure(23);plotResiduals(lmModel_y_LS,'probability')
% figure(24);plotResiduals(lmModel_y_LS_sansICA,'probability')