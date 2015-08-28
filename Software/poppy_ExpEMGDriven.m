
path(path,'C:\INRIA-EMG\library\FastICA_2.5\FastICA_25');
path(path,'C:\INRIA-EMG\library')
path(path,'C:\INRIA-EMG\library\sounds')


load J
load W
load K
W=W;
J=J;% /3
K=K
%% A MOFIDIER
subject_name='sujet17';    % Enter Observer's name
block = 1;
sweep_duration = 2.5; % in seconds, from target appearance DEFAULT VALUE, redefine in BlockData
%% DO NOT MODIFY %%%%%%%%%%%%%%%%%%%%%

close all; clc
cogentPath=fullfile(pwd,'CogGphTB');
addpath(cogentPath)

nb_Ecran=0;%%%% 0 pour 1 ecran, 2 pour 2 ecrans
PortSeriePulse='COM1';
serialOut=0;%% attention, delai de 45ms!
tailleAffichage=get(0,'ScreenSize');
frame_rate = 60;
targetsettletime = 0.5 * frame_rate;
zero_pos_tolerance = 15; % in percent of target extent
target_tolerence = 20;   % in percent of target extent
force_level = 20; % in newton to target
target_extent = 0.5; % in screen unit, 1 being the uper edge of the screen from the center
time_on_target = 0.2; % in seconds
expected_MT = [50 200]; % range (min and max) of expected movement time, in ms
emg_filter_cutoff = 1.5; % in herz
scallingF = 131.5;

% % Parallel port config
% ioObj = io32();% Setup the io32 object
% status = io32(ioObj);% Initialize the dll
% address = hex2dec('378');% Setup the port to write to

if serialOut
    if ~exist('syncOUTObj')
        syncOUTObj = serial(PortSeriePulse);
    else
        fclose(syncOUTObj);
    end
    syncOUTObj.DataTerminalReady = 'off';
    fopen(syncOUTObj);
end
% Connection avec poppy par protocole TCP/IP
%//////////////////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////////////////
try
 fclose(tcp);
end
 tcp = tcpip('192.168.1.3',50007);
 fclose(tcp);
 fopen(tcp);


%%%%%% ETIENNE EDIT itc18 ACQUIRE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Heka.AIrange=10;
Heka.frequence=2000;
sample_rate=Heka.frequence;
Heka.sampstim=0
%Heka.Datas={};

if ~libisloaded('itc18')
    %loadlibrary('itc18vb.dll', @itc18, 'alias', 'itc18');
    loadlibrary('ITCMM',@ITCMMmfile,'alias','itc18');
end

%itcSize = calllib('itc18', 'getStructureSize');
Heka.itcSize = calllib('itc18', 'ITC18_GetStructureSize');

Heka.itc = char(zeros(Heka.itcSize, 1));
Heka.itcPtr = libpointer('voidPtr',[uint8(Heka.itc); 0]);

%isopen=calllib('itc18', 'open', itcPtr,hex2dec('10000'));%% 1 for usb, last 0 for card number

Heka.devicetypePtr=libpointer('int32Ptr', 0);
Heka.deviceNumbPtr=libpointer('int32Ptr', 0);
calllib('itc18', 'ITC18_GetDeviceInfo', Heka.itcPtr,Heka.devicetypePtr,Heka.deviceNumbPtr);
Heka.isopen=calllib('itc18', 'ITC18_Open', Heka.itcPtr,hex2dec('10000'));%% 1 for usb, last 0 for card number

% txtPtr=libpointer('cstring', char(ones(80,1)));
% calllib('itc18', 'ITC18_GetStatusText', itcPtr,isopen,txtPtr,80);
% txtPtr.Value

if Heka.isopen~= 0
    errordlg('ITC hardware is inoperable')
    return
end

Heka.channels=0:7;
Heka.nbinstructions=numel(Heka.channels);
Heka.outChannels = int32([0 2048 4096 6144 10240 14336]); %8192 [DA0 DA1 DA2 DA3 Dig1 Skip]; Dig0
Heka.inChannels = int32([0 128 256 384 512 640 768 896 1024 1920]); % [AD0 AD1 AD2 AD3 AD4 AD5 AD6 AD7 DigIn Skip]@
for ichan=1:Heka.nbinstructions;
    % set the instructions
    Heka.instructions(ichan) = 0;
    if ichan==Heka.nbinstructions;
        % update outputs
        Heka.instructions(ichan) = Heka.instructions(ichan) + 32768;%dec2hex(32768)='0x8000'
        % update inputs
        Heka.instructions(ichan) = Heka.instructions(ichan) + 16384;%dec2hex(16384)='0x4000'
    end
    %set output channel skip
    try
        Heka.instructions(ichan) = Heka.instructions(ichan) + Heka.outChannels(Outputchannels(ichan)+1);
    catch
        Heka.instructions(ichan) = Heka.instructions(ichan) + Heka.outChannels(end);%aucun output
    end
    % set input channel DAn
    try
        Heka.instructions(ichan) = Heka.instructions(ichan) + Heka.inChannels(Heka.channels(ichan)+1);
    catch
        Heka.instructions(ichan) = Heka.instructions(ichan) + Heka.inChannels(end);%aucun output
    end
    channames=['HekaAI_' num2str(Heka.channels(ichan))];
    %Heka.Datas.(channames)=[];
end

calllib('itc18', 'ITC18_Initialize', Heka.itcPtr,0);
Heka.lesrange=[10 5 2 1];
Heka.rangeval=find(Heka.AIrange==Heka.lesrange)-1;
% 0=10v  1=5v 2=2v 3=1v
Heka.allrange=repmat(Heka.rangeval,1,8);
%allrange=[1 1 1 1 1 1 1 1]*AIrange
calllib('itc18', 'ITC18_SetRange', Heka.itcPtr,Heka.allrange);%+-10V
calllib('itc18', 'ITC18_SetSequence', Heka.itcPtr, Heka.nbinstructions, Heka.instructions);
calllib('itc18', 'ITC18_InitializeAcquisition', Heka.itcPtr); % reset and clear Input output
calllib('itc18', 'ITC18_SetSamplingInterval', Heka.itcPtr, round(1/Heka.frequence/.00000125/Heka.nbinstructions),0);% interval de 1000 microS=1ms
Heka.fifosize=calllib('itc18', 'ITC18_GetFIFOSize',Heka.itcPtr);

% if numel(sampstim)>fifosize;
%     sampstim=sampstim(1:fifosize-nbinstructions);
%     sampstim(end+1:end+nbinstructions)=0;
%     nbsecondes=(fifosize-nbinstructions)/(frequence*nbinstructions);
%     message=['La stimulation a été tronquée à ' num2str(round(nbsecondes)) ' secondes!!!!'];
%     warndlg(message,'ATTENTION');
% end
% stimPtr = libpointer('int16Ptr', int16(sampstim));
% calllib('itc18', 'ITC18_WriteFIFO', itcPtr,numel(sampstim),stimPtr);

Heka.readPtr = libpointer('int32Ptr', 0);% pour mesurer le nb de données dans le buffer
Heka.itc18dataPtr = libpointer('int16Ptr', int16(zeros(Heka.fifosize, 1)));% pour stocker les données

Heka.externalTrigger=0;
Heka.AOready=0;
Heka.itcfactor=Heka.AIrange*0.03125/1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Load Cogent
cgloadlib;
%cgopen(3,0,frame_rate,2); % open window
cgopen(tailleAffichage(3),tailleAffichage(4),0,frame_rate,nb_Ecran)

s = cogstd('sPriority','realtime');

gsd = cggetdata('gsd');
screen_width = gsd.ScreenWidth/2   ;    % in pixels, from center
screen_height = gsd.ScreenHeight/2 ;    % in pixels, from center

% load Sounds
cgsound('open')
cgsound('WavFilSND',1,'beep.wav') % Load Tone
cgsound('vol',1,1) % Set volume to zero e.g. last argument = 0.

cgsound('WavFilSND',2,'Arcade Explo A.wav') % Load Tone
cgsound('vol',2,1) % Set volume to zero e.g. last argument = 0.

cgsound('WavFilSND',3,'Metal Clang.wav') % Load Tone
cgsound('vol',3,1) % Set volume to zero e.g. last argument = 0.

% create dir and go there
dir_path = fullfile(pwd,subject_name);
mkdir (dir_path);
cd(dir_path); 
load xymm_pul;
%load xymm_pul_modif1;
%xymm_pul=xymm_pul_modif1;
%load xymm_pul_modif2;
%xymm_pul=xymm_pul_modif2;

xymm_pul = xymm_pul;

% load things from the subject folder
eval(['load target_orderB',num2str(block),'']); % load target order for that block, generated by ExpTargetOrder prog
eval(['target_order = target_orderB',num2str(block),';']);

% % Set data acquisition
% daqreset;
% AI = analoginput('nidaq','Dev1');
% set(AI,'InputType','SingleEnded');
% addchannel(AI,0:15);% 16 channels, 

% message to participants
texto_over = 'The expt will start soon';
cgflip(0,0,0)
cgfont('times',100,0)
cgpencol(0,1,0)
cgtext(texto_over,0,0)
cgtext('Move to the target ASAP',0,150)
cgflip(0,0,0)
pause(1)

% wait for key press
    kd(28) = 0;
    while ~kd(28)
        [kd,kp]=cgkeymap;
        %kp=find(kp);
    end % end of break setup here
Ep=[];        
for i = 1:size(target_order,2)  %inicio de TRIALS

config={};
% set(AI,'TimeOut', 10) % keep for 10 s after collection
% set(AI,'SampleRate',2000) 
% sample_rate = get(AI,'SampleRate');
% set(AI,'SamplesPerTrigger',inf) %d uration*sample_rate
% %
% set(AI,'LogToDiskMode','Overwrite')
% set(AI,'LogFileName','log.daq')
% set(AI,'LoggingMode', 'disk') 
% %
% set(AI,'TriggerType','Manual')
% blocksize = get(AI,'SamplesPerTrigger');

for j = 1:0.5*frame_rate % relax for half a second
    cgfont('times',100,0)
    cgpencol(0,1,0)
    cgtext('Relax',0,0)
    cgfont('times',50,0)
    cgtext(['trial:' num2str(i)],-450,-400)
    cgflip(0,0,0)
end

% wait for key press    
kd(28) = 0;
while ~kd(28)
      kd = cgkeymap;
end % end of break setup here
 
running_ave_pos(1:targetsettletime)=1000; % this is the array used for the running average for when to start the trial... filled with some dummy values
   
%         start(AI); % configure and start the ai engine
%         pause(0.2); % small delay to let the ai engine configure properly before triggering occurs
%         trigger(AI); % start the data acquisition   
    calllib('itc18', 'ITC18_InitializeAcquisition', Heka.itcPtr); % reset and clear Input output
    calllib('itc18', 'ITC18_Start', Heka.itcPtr,Heka.externalTrigger,Heka.AOready,1,0);% 0:external trig inactif, 0: pas output, 1: stop fifo plein, 0: pour rien
    startHeka=tic;
    pause(0.77)% Pour avoir au moins 1500 valeurs!!        
        % aidata = peekdata(AI,1000);
    calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
    nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions;
    calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);
    Fulldata = double(Heka.itc18dataPtr.value)*scallingF;
    chan1samp=4:Heka.nbinstructions:nbsamptorecup;
    aidata=[];
    for ichan=1:numel(Heka.channels)
        aidata(1:numel(chan1samp),ichan)= Fulldata(chan1samp+ichan-1)*Heka.itcfactor;
    end
    Heka.FullDatas=aidata;
    trimeIndex=size(aidata,1);
%     offsetX = mean(aidata(end-999:end,2));% end-999:end prend les 500 dernières ms
%     offsetY = mean(aidata(end-999:end,3));
    
        Wn= emg_filter_cutoff/(sample_rate/2);
        [B,A] = butter(2,Wn);
%         emg = detrend(aidata(:,4:8),'constant');
%         % offset_emg = mean (aidata(end-999:end,:,4:8)); %ATTENTION... A ESSAYER!!!!
%         emg_filt=filter(B,A,abs(emg(end-1499:end,:)));
%         emg_filt= mean(emg_filt(end-499:end,:)); % avrage over the filtered last 500 data points
%         emg_filt_norm = (emg_filt - xymm_pul(:,3)')./(xymm_pul(:,4)'-xymm_pul(:,3)');
%         emg_filt_norm = emg_filt_norm.*(emg_filt_norm>0);
% %         refo= [ones(2,1) emg_filt_norm]*xymm_pul(:,1:2); 
%         refo= [1 emg_filt]*J(:,1:2); 
        
        emg = aidata(:,4:8);
        emg_filt=Processing_Emg(emg,size(emg,1),W,2);
        %//////////////////////////////////////////
%         emg_filt= mean(emg_filt(end-799:end,:));%799
        emg_filt= mean(emg_filt(end-899:end,:));%799
        %//////////////////////////////////////////
%         emg_filt= mean(emg_filt(:,:));

% e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
% emg_filt=emg_filt - [1 e]*K;
%//////////////
% emg_c=zeros(900,5);
% for h=1:900
% e=[emg_filt(h,1) emg_filt(h,2) emg_filt(h,3) emg_filt(h,4) emg_filt(h,5) emg_filt(h,1)*emg_filt(h,2) emg_filt(h,1)*emg_filt(h,3) emg_filt(h,1)*emg_filt(h,4) emg_filt(h,1)*emg_filt(h,5) emg_filt(h,2)*emg_filt(h,3) emg_filt(h,2)*emg_filt(h,4) emg_filt(h,2)*emg_filt(h,5) emg_filt(h,3)*emg_filt(h,4) emg_filt(h,3)*emg_filt(h,5) emg_filt(h,4)*emg_filt(h,5) emg_filt(h,1).^2 emg_filt(h,2).^2 emg_filt(h,3).^2 emg_filt(h,4).^2 emg_filt(h,5).^2];
% emg_c(h,:)=emg_filt(h,:) - [1 e/2]*K;
% end
% emg_filt= mean(emg_c(:,:));
%///////////
        
        refo= [1 emg_filt]*J;         
        
        offsetX = (refo(:,1));
        offsetY = (refo(:,2));     
       
    stop_trial = 0;
    while stop_trial == 0     
%        aidata = peekdata(AI,1500);
%         aidata_cal=(transf_matrix*aidata(:,2:7)')';
%         xpixel = (mean(aidata_cal(:,1))-offsetX) * (target_extent * screen_height / force_level);
%         ypixel= -(mean(aidata_cal(:,2))-offsetY) * (target_extent * screen_height / force_level);   
        calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
        nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions;
        calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);
        Fulldata = double(Heka.itc18dataPtr.value)*scallingF;%*AIrange*0.03125/1000;
        chan1samp=4:Heka.nbinstructions:nbsamptorecup;
        aidata=[];
        for ichan=1:numel(Heka.channels)
            aidata(1:numel(chan1samp),ichan)= Fulldata(chan1samp+ichan-1)*Heka.itcfactor;
        end
        Heka.FullDatas(end+1:end+numel(chan1samp),:)=aidata;
%         size(Heka.FullDatas)
        
        % keyboard
        %emg = detrend(aidata(:,4:8),'constant');
%         emg = detrend(Heka.FullDatas(end-1499:end,4:8),'constant');
        emg = Heka.FullDatas(end-1499:end,4:8);
        emg_filt=Processing_Emg(emg,size(emg,1),W,2);
        emg_filt= mean(emg_filt(end-899:end,:));
%         emg_filt= emg_filt(end,:);
%         emg_filt= mean(emg_filt(:,:));
%         e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
%         refo= [1 e]*J; 
% e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
% emg_filt=emg_filt - [1 e]*K;
%//////////////
% emg_c=zeros(900,5);
% for h=1:900
% e=[emg_filt(h,1) emg_filt(h,2) emg_filt(h,3) emg_filt(h,4) emg_filt(h,5) emg_filt(h,1)*emg_filt(h,2) emg_filt(h,1)*emg_filt(h,3) emg_filt(h,1)*emg_filt(h,4) emg_filt(h,1)*emg_filt(h,5) emg_filt(h,2)*emg_filt(h,3) emg_filt(h,2)*emg_filt(h,4) emg_filt(h,2)*emg_filt(h,5) emg_filt(h,3)*emg_filt(h,4) emg_filt(h,3)*emg_filt(h,5) emg_filt(h,4)*emg_filt(h,5) emg_filt(h,1).^2 emg_filt(h,2).^2 emg_filt(h,3).^2 emg_filt(h,4).^2 emg_filt(h,5).^2];
% emg_c(h,:)=emg_filt(h,:) - [1 e/2]*K;
% end
% emg_filt= mean(emg_c(:,:));
%///////////

        refo= [1 emg_filt]*J; 
%         emg_filt=filter(B,A,abs(emg));
%         emg_filt= emg_filt(end,:);
%         emg_filt_norm = (emg_filt - xymm_pul(:,3)')./(xymm_pul(:,4)'-xymm_pul(:,3)');
%         emg_filt_norm = emg_filt_norm.*(emg_filt_norm>0);
%         refo= emg_filt_norm*xymm_pul(:,1:2);
        
        xpixel = (refo(1)-offsetX) * (target_extent * screen_height);
        ypixel = (refo(2)-offsetY) * (target_extent * screen_height);
if ypixel>349
    ypixel=349;
end

if ypixel<-349
    ypixel=-349;
end

if xpixel>349
    xpixel=349;
end

if xpixel<-349
    xpixel=-349;
end
 slider_value1=16 ; %x
 slider_value2 = ((-0.0385*ypixel) + 13.462);  %y
 slider_value3 = ((0.0732*xpixel)  + 12.572);  %z
 [l_shoulder_y,l_shoulder_x,l_elbow_y] = robot3_inv(slider_value1,slider_value2,slider_value3);
 motor_l_shoulder_y=Cadena_4char(l_shoulder_y);
 motor_l_shoulder_x=Cadena_4char(l_shoulder_x);
 motor_l_elbow_y=Cadena_4char(l_elbow_y);
                           fprintf(tcp,'%s',motor_l_shoulder_y)
                           fprintf(tcp,'%s',',')
                           fprintf(tcp,'%s',motor_l_shoulder_x)  
                           fprintf(tcp,'%s',',-090,')
                           fprintf(tcp,'%s',motor_l_elbow_y)
                           fwrite(tcp,10,'uchar');        
        
        cgpencol(1,0,0)        
        cgellipse (0,0,zero_pos_tolerance * target_extent * screen_height / 100,zero_pos_tolerance * target_extent * screen_height / 100) % unfiled zero-pos_tolerence circle at center
        cgellipse(xpixel,ypixel,9,9,'f')
        cgflip(0,0,0)
        % in here now look to see if the *stop waiting* condition has been filled    
        running_ave_pos(1:(targetsettletime-1))=running_ave_pos(2:targetsettletime); % shuffle the running average array
        running_ave_pos(targetsettletime) = sqrt(xpixel*xpixel+ypixel*ypixel); % load the latest pixel offset from zero into the running average array 
        if mean(running_ave_pos) < zero_pos_tolerance
            stop_trial = 1;
        end        
    end
    cgsound('play',1) % sound target appear
    
    % now we know the person seems reasonably stably positioned at the center start spot,
    % then do the wait until the target is meant to appear.
    
    % compute target position, in screen unit, and then in pixels
    [xy_target(1) , xy_target(2)] = pol2cart( (target_order(i)-1) * pi/8 , 1);
    xy_target_pixel = xy_target .* (target_extent * screen_height);
    jj=0;
    stop_trial = 0;
    t = 0;
    frames = 0;
    for jj = 1:sweep_duration*frame_rate   
        
        calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
        nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions
        calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);
        Fulldata = double(Heka.itc18dataPtr.value)*scallingF;%*AIrange*0.03125/1000;
        chan1samp=4:Heka.nbinstructions:nbsamptorecup; nbechsample=numel(chan1samp);
        aidata=[];
        for ichan=1:numel(Heka.channels)
            aidata(1:nbechsample,ichan)= Fulldata(chan1samp+ichan-1)*Heka.itcfactor;
        end
        frames = frames +1;
        if frames==2
            aidata(round(0.0115*Heka.frequence):end,numel(Heka.channels)+1)=5;%%% considere 11.5ms de decalage pour heka start
        end

        Heka.FullDatas(end+1:end+nbechsample,1:size(aidata,2))=aidata;

        if frames==1  & serialOut % send pulse when target appear
            syncOUTObj.DataTerminalReady = 'on';
        elseif serialOut
            syncOUTObj.DataTerminalReady = 'off';
        end
        
        %emg = detrend(aidata(:,4:8),'constant');
%         emg = detrend(Heka.FullDatas(end-1499:end,4:8),'constant');
%         emg_filt=filter(B,A,abs(emg));
%         emg_filt= emg_filt(end,:);
%         emg_filt_norm = (emg_filt - xymm_pul(:,3)')./(xymm_pul(:,4)'-xymm_pul(:,3)');
%         emg_filt_norm = emg_filt_norm.*(emg_filt_norm>0);
% %         refo= emg_filt_norm*xymm_pul(:,1:2);
%         
%         refo= [1 emg_filt]*J(:,1:2); 
        emg = Heka.FullDatas(end-1499:end,4:8);
        emg_filt=Processing_Emg(emg,size(emg,1),W,2);
        emg_filt= mean(emg_filt(end-899:end,:));
%         emg_filt= emg_filt(end,:);
%  emg_filt= mean(emg_filt(:,:));
%         e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
%         refo= [1 e]*J; 
% e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
% emg_filt=emg_filt - [1 e]*K;
%//////////////
% emg_c=zeros(900,5);
% for h=1:900
% e=[emg_filt(h,1) emg_filt(h,2) emg_filt(h,3) emg_filt(h,4) emg_filt(h,5) emg_filt(h,1)*emg_filt(h,2) emg_filt(h,1)*emg_filt(h,3) emg_filt(h,1)*emg_filt(h,4) emg_filt(h,1)*emg_filt(h,5) emg_filt(h,2)*emg_filt(h,3) emg_filt(h,2)*emg_filt(h,4) emg_filt(h,2)*emg_filt(h,5) emg_filt(h,3)*emg_filt(h,4) emg_filt(h,3)*emg_filt(h,5) emg_filt(h,4)*emg_filt(h,5) emg_filt(h,1).^2 emg_filt(h,2).^2 emg_filt(h,3).^2 emg_filt(h,4).^2 emg_filt(h,5).^2];
% emg_c(h,:)=emg_filt(h,:) - [1 e/2]*K;
% end
% emg_filt= mean(emg_c(:,:));
%///////////
        refo= [1 emg_filt]*J;         
        Ep=[Ep; emg_filt refo]; % guardar los EMG con sus pocisiones predichas por el jacobiano
        
        xpixel = (refo(1)-offsetX) * (target_extent * screen_height);
        ypixel = (refo(2)-offsetY) * (target_extent * screen_height);
        
if ypixel>349
    ypixel=349;
end

if ypixel<-349
    ypixel=-349;
end

if xpixel>349
    xpixel=349;
end

if xpixel<-349
    xpixel=-349;
end        
 slider_value1=16 ; %x
 slider_value2 = ((-0.0385*ypixel) + 13.462);  %y
 slider_value3 = ((0.0732*xpixel)  + 12.572);  %z
 [l_shoulder_y,l_shoulder_x,l_elbow_y] = robot3_inv(slider_value1,slider_value2,slider_value3);
 motor_l_shoulder_y=Cadena_4char(l_shoulder_y);
 motor_l_shoulder_x=Cadena_4char(l_shoulder_x);
 motor_l_elbow_y=Cadena_4char(l_elbow_y);
                           fprintf(tcp,'%s',motor_l_shoulder_y)
                           fprintf(tcp,'%s',',')
                           fprintf(tcp,'%s',motor_l_shoulder_x)  
                           fprintf(tcp,'%s',',-090,')
                           fprintf(tcp,'%s',motor_l_elbow_y)
                           fwrite(tcp,10,'uchar');            
%         
        
        cgpencol(1,0,0)        
        cgellipse (0,0,zero_pos_tolerance * target_extent * screen_height / 100,zero_pos_tolerance * target_extent * screen_height / 100) % unfiled zero-pos_tolerence circle at center
        cgpencol(0,1,0); % green for the target dot
        if stop_trial == 1;
            cgpencol(0,0,0); % black target to disappear once achieved
        end
        cgellipse(xy_target_pixel(1),xy_target_pixel(2),target_tolerence * target_extent * screen_height / 100,target_tolerence * target_extent * screen_height / 100,'f') 
        cgpencol(1,0,0)
        cgellipse(xpixel,ypixel,9,9,'f') 
        cgflip(0,0,0)        
        if sqrt((xpixel - xy_target_pixel(1))^2 + (ypixel -xy_target_pixel(2))^2) < target_tolerence * target_extent * screen_height / 100
            t = t+1;
        else
            t = 0;
        end        
        
        if t > time_on_target * frame_rate %  % TIME ON TARGET
            stop_trial = 1;
            cgsound('play',2) % sound for target acquisition   
        end                
    end 
    %cgsound('play',1) % sound for end of sweep
      
% stop(AI)
% data = daqread('log.daq');
    calllib('itc18', 'ITC18_Stop', Heka.itcPtr);% 0:external trig inactif, 0: pas output, 1: stop fifo plein, 0: pour rien
    calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
    nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions;
    calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);

% trimm data from target appearance to sweep duration
    target_appear_ind = find(Heka.FullDatas(:,9)>0.5,1);
    targetTimeMatrix=target_appear_ind/Heka.frequence;
% if isempty(target_appear_ind)==1 % to flag error if trigger for target appear not plugged in
%     'error - plug the target appear trigger'
%     aa % just to generate an error
% end
% datatrimmed = data(target_appear_ind-499 : target_appear_ind+(sweep_duration-0.1)*sample_rate , : ); % trimming start and end so file is not so large...
datatrimmed =Heka.FullDatas(target_appear_ind-499 : target_appear_ind+(sweep_duration-0.1)*sample_rate ,:);
% reconstruct visual trajectory
        reco_emg = detrend(datatrimmed(:,4:8),'constant');
        reco_emg_filt=filter(B,A,abs(reco_emg));
reco_emg_filt_norm = (reco_emg_filt - repmat(xymm_pul(:,3)', size(reco_emg_filt,1),1) )./(repmat(xymm_pul(:,4)', size(reco_emg_filt,1),1)-repmat(xymm_pul(:,3)', size(reco_emg_filt,1),1));
        reco_emg_filt_norm = reco_emg_filt_norm.*(reco_emg_filt_norm>0);
%         reco_force = reco_emg_filt_norm*xymm_pul(:,1:2);
%         e=[emg_filt(:,1) emg_filt(:,2) emg_filt(:,3) emg_filt(:,4) emg_filt(:,5) emg_filt(:,1)*emg_filt(:,2) emg_filt(:,1)*emg_filt(:,3) emg_filt(:,1)*emg_filt(:,4) emg_filt(:,1)*emg_filt(:,5) emg_filt(:,2)*emg_filt(:,3) emg_filt(:,2)*emg_filt(:,4) emg_filt(:,2)*emg_filt(:,5) emg_filt(:,3)*emg_filt(:,4) emg_filt(:,3)*emg_filt(:,5) emg_filt(:,4)*emg_filt(:,5) emg_filt(:,1).^2 emg_filt(:,2).^2 emg_filt(:,3).^2 emg_filt(:,4).^2 emg_filt(:,5).^2];
%         reco_force= [1 e]*J; 
        reco_force= [1 emg_filt]*J; ; 
 reco_xpixel = (reco_force(:,1)-offsetX) * (target_extent * screen_height);
 reco_ypixel = (reco_force(:,2)-offsetY) * (target_extent * screen_height);       
 

% analise online to provide feedback (eg, movement time)
[TH,R] = cart2pol(reco_xpixel,reco_ypixel);
[B,A] = butter(2, 50 *  2 / sample_rate); % filtered at 50 hz
Rfilt = filter (B, A, R);

idx_sound = max(find(datatrimmed(:,9)>0))+50*(sample_rate/1000); %index end of sound
list_out_center = find(Rfilt> 0.15*target_extent * screen_height); %list of index with cursor out center
idx_begin_mouv = find(list_out_center>idx_sound,1); % first index of list with cursor out center after sound
idx_begin_mouv = list_out_center(idx_begin_mouv); % index of begin movement



list_90percent = find(Rfilt> 0.9*target_extent * screen_height);
idx_90percent = find(list_90percent>idx_sound,1);
idx_90percent = list_90percent(idx_90percent);
MT = ( idx_90percent - idx_begin_mouv )* 1000 / sample_rate; % in ms
if isempty(MT)==1
    MT = 10; % crazy value if no movement
end

%angular error
idx_BM = idx_begin_mouv; % index at 10% of target_extent after sound
idx_80 = idx_BM + 80*(sample_rate/1000); % index at 10% of target_extent + 80 ms
xpixel_BM = reco_xpixel(idx_BM); ypixel_BM = reco_ypixel(idx_BM); % cursor coordinates (pixel) at 10% of target_extent 
xpixel_80 = reco_xpixel(idx_80); ypixel_80 = reco_ypixel(idx_80); % cursor coordinates (pixel) at 10% of target_extent + 80 ms 
[TH_80, R_80] = cart2pol (xpixel_80-xpixel_BM, ypixel_80-ypixel_BM); % Reel angle movement
[TH_target, R_target] = cart2pol (xy_target_pixel(1),xy_target_pixel(2));
Ang_Err = TH_80 - TH_target;
Ang_Err = atan2(sin(Ang_Err),cos(Ang_Err));
if isempty(Ang_Err)==1 
    Ang_Err = 0.00001; %valeur de l'erreur par défaut
end

    
% feedback on movement time
cgpencol(1,1,1); 
    cgrect(200,0,20,200);
    if MT < expected_MT(1) || MT > expected_MT(2)
        cgpencol(1,0,0);
        cgsound('play',3) % sound for end of sweep
    else 
        cgpencol(0,1,0)
        cgsound('play',1) % sound for end of sweep        
    end
    cgrect(200,(MT*200/500)/2 - 100,20,MT*200/500);    
    cgpenwid(2)    
    cgpencol(0,0,0);    
    cgdraw(190,expected_MT(1)*200/500 -100,210,expected_MT(1)*200/500 -100);
    cgdraw(190,expected_MT(2)*200/500 -100,210,expected_MT(2)*200/500 -100);
        
    cgfont('times',80,0)
    if MT < expected_MT(1) 
        cgpencol(1,0,0)
        cgtext('too quick',0,0)
    elseif MT > expected_MT(2)
        cgpencol(1,0,0)
        cgtext('too slow',0,0)
    else
        cgpencol(0,1,0)
        cgtext('good timing',0,0)
    end
    cgflip(0,0,0)
    pause(1)


% save data
% data2save = [ datatrimmed , reco_xpixel , reco_ypixel];
% 
% eval(['Block',num2str(block),'trial',num2str(i),' = data2save;'])
% filename=['Block',num2str(block),'trial',num2str(i)];
% save(filename, filename,'config')
% 
% 
% data2save2 = [ Ang_Err , MT , xymm_pul(:,1)' , xymm_pul(:,2)'];
% eval(['Erreur_Block',num2str(block),'trial',num2str(i),' = data2save2;'])
% Erreur_filename=['Erreur_Block',num2str(block),'trial',num2str(i)];
% save(Erreur_filename,Erreur_filename,'config')

end

calllib('itc18', 'ITC18_Close', Heka.itcPtr);
cgshut
fclose(tcp);

