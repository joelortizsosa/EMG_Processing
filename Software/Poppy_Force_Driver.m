path(path,'C:\INRIA-EMG\library');

%Definition of global variables
global coord_x_l_shoulder_x  coord_y_l_elbow_y 

coord_x_l_shoulder_x = 60;
coord_y_l_elbow_y    = 71;

%% A MOFIDIER
subject_name='sujet17';    % Enter Observer's name
block = 1;
sweep_duration = 2.5; % in seconds, from target appearance DEFAULT VALUE, redefine in BlockData 15; 2.5 . PARA TOMAR MUESTRAS A 20
force_level = 10.54; % in newton to target 16.54  . PARA TOMAR MUESTRAS A 50
%% DO NOT MODIFY %%%%%%%%%%%%%%%%%%%%%

close all; clc
cogentPath=fullfile(pwd,'CogGphTB');
addpath(cogentPath)

% Force Driven Wrist Experiment
% pause(2)

nb_Ecran=0;%%%% 0 pour 1 ecran, 2 pour 2 ecrans
PortSeriePulse='COM1';
serialOut=0;%% attention, delai de 45ms!
tailleAffichage=get(0,'ScreenSize');
frame_rate = 60;
targetsettletime = 0.5 * frame_rate;
zero_pos_tolerance = 10; % in percent of target extent
target_tolerence = 20;   % in percent of target extent
target_extent = 0.5; % in screen unit, 1 being the uper edge of the screen from the center
time_on_target = 1; % in seconds
expected_MT = [50 150]; % range (min and max) of expected movement time, in ms
rotation = -2.618 ; % in rad
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
% try
%  fclose(tcp);
% end
%  tcp = tcpip('192.168.1.3',50007);
%  fclose(tcp);
%  fopen(tcp);

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
%     message=['La stimulation a �t� tronqu�e � ' num2str(round(nbsecondes)) ' secondes!!!!'];
%     warndlg(message,'ATTENTION');
% end
% stimPtr = libpointer('int16Ptr', int16(sampstim));
% calllib('itc18', 'ITC18_WriteFIFO', itcPtr,numel(sampstim),stimPtr);

Heka.readPtr = libpointer('int32Ptr', 0);% pour mesurer le nb de donn�es dans le buffer
Heka.itc18dataPtr = libpointer('int16Ptr', int16(zeros(Heka.fifosize, 1)));% pour stocker les donn�es

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
screen_width = gsd.ScreenWidth/2       % in pixels, from center
screen_height = gsd.ScreenHeight/2     % in pixels, from center

% load Sounds
cgsound('open')
cgsound('WavFilSND',1,'beep.wav') % Load Tone
cgsound('vol',1,1) % Set volume to zero e.g. last argument = 0.

cgsound('WavFilSND',2,'Arcade Explo A.wav') % Load Tone
cgsound('vol',2,1) % Set volume to zero e.g. last argument = 0.

cgsound('WavFilSND',3,'Metal Clang.wav') % Load Tone
cgsound('vol',3,1) % Set volume to zero e.g. last argument = 0.

cgsound('WavFilSND',4,'Emilie.wav') % Load Tone
cgsound('vol',4,1) % Set volume to zero e.g. last argument = 0.

% create dir and go there
%dir_path = ['C:\users\Aymar\Prog_WristForce\',sprintf('%s',subject_name)];
dir_path = fullfile(pwd,subject_name);
mkdir (dir_path);
cd(dir_path); 

% load things from the subject folder
eval(['load target_orderB',num2str(block),'']); % load target order for that block, generated by ExpTargetOrder prog
eval(['target_order = target_orderB',num2str(block),';']);

% Set data acquisition
% daqreset;
% AI = analoginput('nidaq','Dev1');
% set(AI,'InputType','SingleEnded');
% addchannel(AI,0:15);% 16 channels,

% %% give the Expected wrist position
% Last_wristpos=target_order(1,2);
% Last_catch=target_order(1,4);
% waitWrist=num2str(Last_wristpos);
% if sign(Last_wristpos)==1;
%     sens=' deg LEFT';
% elseif sign(Last_wristpos)==-1;
%     sens=' deg RIGHT';
% else
%     sens='';
% end
% cgsound('play',4) % sound target appear
% texto_over = ['Wrist ', waitWrist, sens];
% cgflip(0,0,0)
% cgfont('times',100,0)
% cgpencol(0,0,1)
% cgtext(texto_over,0,0)
% cgflip(0,0,0)
% % wait for key press
% kd(16) = 0;
% while ~kd(16) %% A or Q depending the keyboard
%     [kd,kp]=cgkeymap;
%     %kp=find(kp);
% end % end of break setup here



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
    

for i = 1:size(target_order,2)  %15

%     if Last_wristpos~=target_order(i,2) | (~Last_catch & target_order(i,4));
%        
%         waitWrist=num2str(target_order(i,2));
%         if sign(target_order(i,2))==1;
%             sens=' deg LEFT';
%         elseif sign(target_order(i,2))==-1;
%             sens=' deg RIGHT';
%         else
%             sens='';
%         end
%         
%         if (~Last_catch & target_order(i,4)) & Last_wristpos==target_order(i,2)
%             texto_over=['Move and Back wrist to ' , waitWrist, sens];    
%             cgfont('times',75,0)
%         else
%             texto_over = ['Wrist ', waitWrist, sens];
%             cgfont('times',100,0)
%         end
%         
%          Last_wristpos=target_order(i,2);
%         Last_catch=target_order(i,4);
%         
%         cgsound('play',4) % sound target appear       
%         cgflip(0,0,0)
%         cgpencol(0,0,1)
%         cgtext(texto_over,0,0)
%         cgflip(0,0,0)
%         % wait for key press
%         kd(16) = 0;
%         while ~kd(16) %% A or Q depending the keyboard
%             [kd,kp]=cgkeymap;
%             %kp=find(kp);
%         end % end of break setup here
%     end

    config={};
    % set(AI,'TimeOut', 10) % keep for 10 s after collection
    % set(AI,'SampleRate',2000)
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
        [kd,kp]=cgkeymap;
        %kp=find(kp);
    end % end of break setup here

    running_ave_pos(1:targetsettletime)=1000; % this is the array used for the running average for when to start the trial... filled with some dummy values

    %start(AI); % configure and start the ai engine
    %pause(0.2); % small delay to let the ai engine configure properly before triggering occurs
    %trigger(AI); % start the data acquisition
    calllib('itc18', 'ITC18_InitializeAcquisition', Heka.itcPtr); % reset and clear Input output
    calllib('itc18', 'ITC18_Start', Heka.itcPtr,Heka.externalTrigger,Heka.AOready,1,0);% 0:external trig inactif, 0: pas output, 1: stop fifo plein, 0: pour rien
    startHeka=tic;
    pause(0.52)% Pour avoir au moins 1000 valeurs
    %     aidata = peekdata(AI,1000);
    %     aidata_calb=(transf_matrix*aidata(:,2:7)')';
    calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
    nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions
    calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);
    Fulldata = double(Heka.itc18dataPtr.value)*scallingF;
    chan1samp=4:Heka.nbinstructions:nbsamptorecup;
    aidata=[];
    for ichan=1:numel(Heka.channels)
        aidata(1:numel(chan1samp),ichan)= Fulldata(chan1samp+ichan-1)*Heka.itcfactor;
    end
    Heka.FullDatas=aidata;
    trimeIndex=size(aidata,1);
    offsetX = mean(aidata(end-999:end,2));% end-999:end prend les 500 derni�res ms
    offsetY = mean(aidata(end-999:end,3));

    stop_trial = 0;
    while stop_trial == 0
        global coord_x_l_shoulder_x
        %         aidata = peekdata(AI,200);
        %         aidata_cal=(transf_matrix*aidata(:,2:7)')';
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
        xpixel = (mean(aidata(:,2))-offsetX) * (target_extent * screen_height / force_level);
        ypixel = (mean(aidata(:,3))-offsetY) * (target_extent * screen_height / force_level);

        [tpixel,rpixel] = cart2pol(xpixel,ypixel);
        [xpixel,ypixel] = pol2cart(tpixel + rotation,rpixel);
        % Calcule de coord pour x et y , en relation au moteurs de poppy
% if ypixel>349
%     ypixel=349;
% end
% 
% if ypixel<-349
%     ypixel=-349;
% end
% 
% if xpixel>349
%     xpixel=349;
% end
% 
% if xpixel<-349
%     xpixel=-349;
% end
%  slider_value1=16 ; %x
%  slider_value2 = ((-0.0385*ypixel) + 13.462);  %y
%  slider_value3 = ((0.0732*xpixel)  + 12.572);  %z
%  [l_shoulder_y,l_shoulder_x,l_elbow_y] = robot3_inv(slider_value1,slider_value2,slider_value3);
%  motor_l_shoulder_y=Cadena_4char(l_shoulder_y);
%  motor_l_shoulder_x=Cadena_4char(l_shoulder_x);
%  motor_l_elbow_y=Cadena_4char(l_elbow_y);
%                            fprintf(tcp,'%s',motor_l_shoulder_y)
%                            fprintf(tcp,'%s',',')
%                         fprintf(tcp,'%s',motor_l_shoulder_x)  
%                            fprintf(tcp,'%s',',-090,')
%                            fprintf(tcp,'%s',motor_l_elbow_y)
%                            fwrite(tcp,10,'uchar');   
%                            
%         coord_x_l_shoulder_x = int16((0.2*xpixel) + 60);
%         coord_y_l_elbow_y = int16((-0.2*ypixel) - 70);
%///////////////////////////////////////////////////////////////////////
%           op_str = num2str(coord_y_l_elbow_y);
%          
%           longitud_cadena = length(op_str);
%           
%               switch longitud_cadena
%                   case 1
%                           mostrar = strcat('000',op_str);
%                   case 2
%                       if op_str(1)=='-'
%                           mostrar = strcat(op_str(1),'00',op_str(2));
%                       else    
%                           mostrar = strcat('00',op_str);
%                       end
%                   case 3
%                       if op_str(1)=='-'
%                           mostrar = strcat(op_str(1),'0',op_str(2),op_str(3));
%                       else    
%                           mostrar = strcat('0',op_str);
%                       end
%                  
%                   otherwise
%                       mostrar = num2str(op_str);
%               end 
%  
%           op_str = num2str(coord_x_l_shoulder_x);
%           
%           longitud_cadena = length(op_str);
%           
%               switch longitud_cadena
%                   case 1
%                           mostrar_X = strcat('000',op_str);
%                   case 2
%                       if op_str(1)=='-'
%                           mostrar_X = strcat(op_str(1),'00',op_str(2));
%                       else    
%                           mostrar_X = strcat('00',op_str);
%                       end
%                   case 3
%                       if op_str(1)=='-'
%                           mostrar_X = strcat(op_str(1),'0',op_str(2),op_str(3));
%                       else    
%                           mostrar_X = strcat('0',op_str);
%                       end
%                  
%                   otherwise
%                       mostrar_X = num2str(op_str);
%               end               
%               
%                             fprintf(tcp,'%s','-010,')
%                             fprintf(tcp,'%s',mostrar_X)  
%                             fprintf(tcp,'%s',',0000,')
%                             fprintf(tcp,'%s',mostrar)
%                             fwrite(tcp,10,'uchar');             
%///////////////////////////////////////////////////////////////////////
        

        cgpencol(1,0,0)
        cgellipse (0,0,zero_pos_tolerance * target_extent * screen_height / 100,zero_pos_tolerance * target_extent * screen_height / 100) % unfiled zero-pos_tolerence circle at center

        if 0 %  target_order(i,4)   Cercle vs Cible lors des CATCHS
            cgpencol(0,1,0)
            rayon=sqrt(xpixel.^2+ypixel.^2);
            cgellipse(0,0,2*rayon,2*rayon)
        else
            cgpencol(1,0,0)
            cgellipse(xpixel,ypixel,9,9,'f')
        end

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
    %[xy_target(1) , xy_target(2)] = pol2cart( target_order(i,1) * pi/180 , 1);
    xy_target_pixel = xy_target .* (target_extent * screen_height);

    config.TARGET_X_Y_Tolerence=[xy_target_pixel(1),xy_target_pixel(2), target_tolerence];
    config.time_on_target=time_on_target;
    %config.wrist_angle=target_order(i,2);
    %config.VisuoMot_Transformation=target_order(i,3);
    rayonCible=sqrt(xy_target_pixel(1).^2+xy_target_pixel(2).^2);

    jj=0;
    stop_trial = 0;
    t = 0;
    frames = 0;
    for jj = 1:sweep_duration*frame_rate

        calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
        nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions;
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
        %///////////Calculo de pixeles cuando aparece el punto verde////
        %////////////////////////////////////////////////////////////////
        xpixel = (mean(aidata(:,2))-offsetX) * (target_extent * screen_height / force_level);
        ypixel=  (mean(aidata(:,3))-offsetY) * (target_extent * screen_height / force_level);
        [tpixel,rpixel] = cart2pol(xpixel,ypixel) ;
        [xpixel,ypixel] = pol2cart(tpixel + rotation,rpixel);

        % Calcule de coord pour x et y , en relation au moteurs de poppy
% if ypixel>349
%     ypixel=349;
% end
% 
% if ypixel<-349
%     ypixel=-349;
% end
% 
% if xpixel>349
%     xpixel=349;
% end
% 
% if xpixel<-349
%     xpixel=-349;
% end        
%  slider_value1=16 ; %x
%  slider_value2 = ((-0.0385*ypixel) + 13.462);  %y
%  slider_value3 = ((0.0732*xpixel)  + 12.572);  %z
%  [l_shoulder_y,l_shoulder_x,l_elbow_y] = robot3_inv(slider_value1,slider_value2,slider_value3);
%  motor_l_shoulder_y=Cadena_4char(l_shoulder_y);
%  motor_l_shoulder_x=Cadena_4char(l_shoulder_x);
%  motor_l_elbow_y=Cadena_4char(l_elbow_y);
%                            fprintf(tcp,'%s',motor_l_shoulder_y)
%                            fprintf(tcp,'%s',',')
%                            fprintf(tcp,'%s',motor_l_shoulder_x)  
%                            fprintf(tcp,'%s',',-090,')
%                            fprintf(tcp,'%s',motor_l_elbow_y)
%                            fwrite(tcp,10,'uchar');        
%         
%         coord_x_l_shoulder_x = int16((0.2*xpixel) + 60);
%         coord_y_l_elbow_y = int16((-0.2*ypixel) - 70) ;
        
%///////////////////////////////////////////////////////////////////////
%           op_str = num2str(coord_y_l_elbow_y);
%           
%           longitud_cadena = length(op_str);
%           
%               switch longitud_cadena
%                   case 1
%                           mostrar = strcat('000',op_str);
%                   case 2
%                       if op_str(1)=='-'
%                           mostrar = strcat(op_str(1),'00',op_str(2));
%                       else    
%                           mostrar = strcat('00',op_str);
%                       end
%                   case 3
%                       if op_str(1)=='-'
%                           mostrar = strcat(op_str(1),'0',op_str(2),op_str(3));
%                       else    
%                           mostrar = strcat('0',op_str);
%                       end
%                  
%                   otherwise
%                       mostrar = num2str(op_str);
%               end 
%  
%           op_str = num2str(coord_x_l_shoulder_x);
%           
%           longitud_cadena = length(op_str);
%           
%               switch longitud_cadena
%                   case 1
%                           mostrar_X = strcat('000',op_str);
%                   case 2
%                       if op_str(1)=='-'
%                           mostrar_X = strcat(op_str(1),'00',op_str(2));
%                       else    
%                           mostrar_X = strcat('00',op_str);
%                       end
%                   case 3
%                       if op_str(1)=='-'
%                           mostrar_X = strcat(op_str(1),'0',op_str(2),op_str(3));
%                       else    
%                           mostrar_X = strcat('0',op_str);
%                       end
%                  
%                   otherwise
%                       mostrar_X = num2str(op_str);
%               end               
%               
%                             fprintf(tcp,'%s','-010,')
%                             fprintf(tcp,'%s',mostrar_X)  
%                             fprintf(tcp,'%s',',0000,')
%                             fprintf(tcp,'%s',mostrar)
%                             fwrite(tcp,10,'uchar');             
%///////////////////////////////////////////////////////////////////////        
        
        
        cgpencol(1,0,0)
        cgellipse (0,0,zero_pos_tolerance * target_extent * screen_height / 100,zero_pos_tolerance * target_extent * screen_height / 100) % unfiled zero-pos_tolerence circle at center
        cgpencol(0,1,0); % green for the target dot
        if frames==1;
            targetTimer=toc(startHeka);
            targetappear=tic;
        end
        if stop_trial == 1;
            cgpencol(0,0,0); % black target to disappear once achieved
        end
        cgellipse(xy_target_pixel(1),xy_target_pixel(2),target_tolerence * target_extent * screen_height / 100,target_tolerence * target_extent * screen_height / 100,'f')
        cgpencol(1,0,0)
        if 0% target_order(i,4)     Cercle vs Cible lors des CATCHS
            CatchRadius=1;
            cgpencol(0,1,0)
            rayon=sqrt(xpixel.^2+ypixel.^2);
            cgellipse(0,0,2*rayon,2*rayon)
        else
            CatchRadius=0;
            cgpencol(1,0,0)
            cgellipse(xpixel,ypixel,9,9,'f')
        end
        cgflip(0,0,0)

        if ~CatchRadius & (sqrt((xpixel - xy_target_pixel(1))^2 + (ypixel -xy_target_pixel(2))^2) < target_tolerence * target_extent * screen_height / 100)
            t = t+1;
            if ~isfield(config,'FirstReach')
                config.FirstReach=toc(targetappear);
            end
        elseif CatchRadius & (abs(rayon- rayonCible)< target_tolerence * target_extent * screen_height / 100)
            t = t+1;
            if ~isfield(config,'FirstReach')
                config.FirstReach=toc(targetappear);
            end
        else
            t = 0;
        end

        if t > time_on_target * frame_rate %  % TIME ON TARGET
            stop_trial = 1;
            config.EndReach=toc(targetappear);
            cgsound('play',2) % sound for target acquisition
        end
    end
    %cgsound('play',1) % sound for end of sweep

    %     stop(AI)
    %data = daqread('log.daq');
    calllib('itc18', 'ITC18_Stop', Heka.itcPtr);% 0:external trig inactif, 0: pas output, 1: stop fifo plein, 0: pour rien
    calllib('itc18', 'ITC18_GetFIFOReadAvailable', Heka.itcPtr, Heka.readPtr);
    nbsamptorecup=floor(get(Heka.readPtr, 'value')/Heka.nbinstructions)*Heka.nbinstructions;
    calllib('itc18', 'ITC18_ReadFIFO', Heka.itcPtr, nbsamptorecup, Heka.itc18dataPtr);


    % trimm data from target appearance to sweep duration
    target_appear_ind = find(Heka.FullDatas(:,9)>0.5,1);
    targetTimeMatrix=target_appear_ind/Heka.frequence;
    %     if isempty(target_appear_ind)==1 % to flag error if trigger for target appear not plugged in
    %         'error - plug the target appear trigger'
    %         aa % just to generate an error
    %     end
    %     datatrimmed = data(target_appear_ind-499 : target_appear_ind+(sweep_duration-0.1)*sample_rate , : ); % trimming start and end so file is not so large...
    datatrimmed =Heka.FullDatas(target_appear_ind-499 : target_appear_ind+(sweep_duration-0.1)*sample_rate ,:);
    %datatrimmed =Heka.FullDatas(end-(sweep_duration-0.1)*sample_rate/end
    %,:)
    % reconstruct visual trajectory
    %reco_aidata_cal=(transf_matrix*datatrimmed(:,2:7)')';

    reco_aidata_cal=datatrimmed;
    reco_xpixel = (reco_aidata_cal(:,2)-offsetX) .* (target_extent * screen_height / force_level);
    reco_ypixel = (reco_aidata_cal(:,3)-offsetY) .* (target_extent * screen_height / force_level);
    [reco_tpixel,reco_rpixel] = cart2pol(reco_xpixel,reco_ypixel) ;
    [reco_xpixel,reco_ypixel] = pol2cart(reco_tpixel + rotation ,reco_rpixel);

    % analize online to provide feedback (eg, movement time)
    [TH,R] = cart2pol(reco_xpixel,reco_ypixel);
    [B,A] = butter(2, 50 *  2 / sample_rate); % filtered at 50 hz
    Rfilt = filter (B, A, R);
    MT = ( find(Rfilt>0.9*target_extent * screen_height,1) - find(Rfilt> 0.1*target_extent * screen_height,1) )* 1000 / sample_rate; % in ms
    if isempty(MT)==1
        MT = 10; % crazy value if no movement
    end
    
    %angular error
    t_BG = find(Rfilt> 0.1*target_extent * screen_height,1); % time at 10% of target_extent
    t_80 = find(Rfilt> 0.1*target_extent * screen_height,1)+80*(sample_rate/1000); % time at 10% of target_extent + 80 ms
    xpixel_BG = reco_xpixel(t_BG); ypixel_BG = reco_ypixel(t_BG); % cursor coordinates (pixel) at 10% of target_extent 
    xpixel_80 = reco_xpixel(t_80); ypixel_80 = reco_ypixel(t_80); % cursor coordinates (pixel) at 10% of target_extent + 80 ms 
    [TH_80, R_80] = cart2pol (xpixel_80-xpixel_BG, ypixel_80-ypixel_BG); % Reel angle movement
    [TH_target, R_target] = cart2pol (xy_target_pixel(1),xy_target_pixel(2));
    Ang_Err = TH_80 - TH_target;
    Ang_Err = atan2(sin(Ang_Err),cos(Ang_Err));
    if isempty(Ang_Err)==1 
        Ang_Err = 0.00001; %valeur de l'erreur par d�faut
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
    data2save = [ datatrimmed , reco_xpixel , reco_ypixel ];

    eval(['Block',num2str(block),'trial',num2str(i),' = data2save;'])
    filename=['Block',num2str(block),'trial',num2str(i)];
    save(filename, filename,'config')
    %eval(['save Block',num2str(block),'trial',num2str(i),' Block',num2str(block),'trial',num2str(i),''])

    data2save2 = [ Ang_Err , MT ]
    eval(['Erreur_Block',num2str(block),'trial',num2str(i),' = data2save2;'])
    Erreur_filename=['Erreur_Block',num2str(block),'trial',num2str(i)];
    save(Erreur_filename,Erreur_filename,'config')
end
calllib('itc18', 'ITC18_Close', Heka.itcPtr);
cgshut
% fclose(tcp);
