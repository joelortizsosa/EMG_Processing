function source_multi = Processing_Emg(data,taille,W,metodo)
taille = round((taille * 424)/5300);
% taille = 50;
electrodo1 = remmean( data(:,1));
electrodo2 = remmean( data(:,2));
electrodo3 = remmean( data(:,3));
electrodo4 = remmean( data(:,4));
electrodo5 = remmean( data(:,5));
% figure;plot(electrodo1)
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
% figure;plot(x1)
rms_x1 = rms(x1, taille, 0, 0)';
rms_x2 = rms(x2, taille, 0, 0)';
rms_x3 = rms(x3, taille, 0, 0)';
rms_x4 = rms(x4, taille, 0, 0)';
rms_x5 = rms(x5, taille, 0, 0)';
% figure;plot(rms_x1)
mixedsig = [
             x1'
             x2'
             x3'
             x4'
             x5' 
                ];

%      [A, W] = fastica(mixedsig);

%Descomponemos las señales en 5 fuentes independientes
source=W*mixedsig;
%calculamos la transpuesta para que cada columna sea una fuente
source=source';

source1 = source(:,1);
source2 = source(:,2);
source3 = source(:,3);
source4 = source(:,4);
source5 = source(:,5);

if metodo==1
rms_source1 = rms(source1, taille, 0, 0)'; % 424
rms_source2 = rms(source2, taille, 0, 0)';
rms_source3 = rms(source3, taille, 0, 0)';
rms_source4 = rms(source4, taille, 0, 0)';
rms_source5 = rms(source5, taille, 0, 0)';
end

if metodo==2
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
        rms_source1 = abs(reco_emg_filt1); % 424
        rms_source2 = abs(reco_emg_filt2);
        rms_source3 = abs(reco_emg_filt3);
        rms_source4 = abs(reco_emg_filt4);
        rms_source5 = abs(reco_emg_filt5);        
end

source_multi = [rms_source1 rms_source2 rms_source3 rms_source4 rms_source5];
