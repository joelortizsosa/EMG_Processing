function source_multi=Filt_Enveloppe(electrodo1,electrodo2,electrodo3,electrodo4,electrodo5)

        Wn= 1.5/(2000/2);
        [B,A] = butter(2,Wn);         
        EMG_filt_B1=filter(B,A,abs(electrodo1));
        EMG_filt_B2=filter(B,A,abs(electrodo2));
        EMG_filt_B3=filter(B,A,abs(electrodo3));        
        EMG_filt_B4=filter(B,A,abs(electrodo4));        
        EMG_filt_B5=filter(B,A,abs(electrodo5));    
        rms_source1 = abs(EMG_filt_B1);
        rms_source2 = abs(EMG_filt_B2);
        rms_source3 = abs(EMG_filt_B3);
        rms_source4 = abs(EMG_filt_B4);
        rms_source5 = abs(EMG_filt_B5);  
        
        source_multi = [rms_source1 rms_source2 rms_source3 rms_source4 rms_source5];