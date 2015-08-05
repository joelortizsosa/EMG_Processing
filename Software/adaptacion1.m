close all; 
% J=[Model_2_X.Coefficients.Estimate Model_2_Y.Coefficients.Estimate]
%  save J J -v7
%  save W W -v7
 
datos=Block1trial1;
forceX=datos(:,10)/256;
forceY=datos(:,11)/256;

 plot(forceX(:,1),forceY(:,1))
 
electrodo1 = remmean( datos(:,4));
electrodo2 = remmean( datos(:,5));
electrodo3 = remmean( datos(:,6));
electrodo4 = remmean( datos(:,7));
electrodo5 = remmean( datos(:,8));

        mixedsig = [ electrodo1'
                     electrodo2'
                     electrodo3'
                     electrodo4'
                     electrodo5'];
        source=W*mixedsig;   
        source=source';
        source1 = source(:,1); source2 = source(:,2); source3 = source(:,3); source4 = source(:,4); source5 = source(:,5);         
        elec = Filt_Enveloppe(source1,source2,source3,source4,source5);
        
%         XY= [1 elec(1,1) elec(1,2) elec(1,3) elec(1,4) elec(1,5)]*J
%         i=47;
%         XY= ([ elec(i,1) elec(i,2) elec(i,3) elec(i,4) elec(i,5)]*J(2:6,:))+[J(1,1) J(1,2)]
%         
        XY=[forceX forceY];
        emg=zeros(5300,5);
        temporal=zeros(5300,20);
        for j=1:5300
        temporal(j,:)=(XY(j,:)-[J(1,1) J(1,2)])*pinv(J(2:21,:));
        emg(j,:)=temporal(j,1:5);
        end
        
%  
%         error=(error1+error2)/2;
%           error =  nthroot((error1.^7 + error2.^7 + error3.^7 + error4.^7 + error5.^7 + error6.^7 + error7.^7 + error8.^7 + error9.^7 + error10.^7 + error11.^7 + error12.^7 + error13.^7 + error14.^7 + error15.^7 + error16.^7)/16,7) ;
%           error =  ((error1 + error2 + error3 + error4 + error5 + error6 + error7 + error8 + error9 + error10 + error11 + error12 + error13 + error14 + error15 + error16)/16) ;

%          error1=elec-emg;
% error16=zeros(5300,20);         
% for h=1:5300
%     e=[elec(h,1) elec(h,2) elec(h,3) elec(h,4) elec(h,5) elec(h,1)*elec(h,2) elec(h,1)*elec(h,3) elec(h,1)*elec(h,4) elec(h,1)*elec(h,5) elec(h,2)*elec(h,3) elec(h,2)*elec(h,4) elec(h,2)*elec(h,5) elec(h,3)*elec(h,4) elec(h,3)*elec(h,5) elec(h,4)*elec(h,5) elec(h,1).^2 elec(h,2).^2 elec(h,3).^2 elec(h,4).^2 elec(h,5).^2];
%     error16(h,:)=e-temporal(h,:);
% end         
     
%         error=[ones(size(elec,1),1) elec]*K;
%         plot(error(:,5))
%         hold on;
%         plot(erro(:,5),'r')
%          error=[ones(size(error,1),1) error8]*K;
%%

for h=1:5300
%     e=[elec(h,1) elec(h,2) elec(h,3) elec(h,4) elec(h,5) elec(h,1)*elec(h,2) elec(h,1)*elec(h,3) elec(h,1)*elec(h,4) elec(h,1)*elec(h,5) elec(h,2)*elec(h,3) elec(h,2)*elec(h,4) elec(h,2)*elec(h,5) elec(h,3)*elec(h,4) elec(h,3)*elec(h,5) elec(h,4)*elec(h,5) elec(h,1).^2 elec(h,2).^2 elec(h,3).^2 elec(h,4).^2 elec(h,5).^2];
    XY(h,:)=([1 elec(h,:)]*J);
end

    hold on;
    plot(XY(:,1),XY(:,2),'k')
%%
% %%
X_Y=[];
for h=1:5300
%     XY(h,:)=([1 elec(h,:)]*J);
%     emg(h,:)=(XY(h,:)-[J(1,1) J(1,2)])*pinv(J(2:6,:));
%     e=[emg(h,1) emg(h,2) emg(h,3) emg(h,4) emg(h,5) emg(h,1)*emg(h,2) emg(h,1)*emg(h,3) emg(h,1)*emg(h,4) emg(h,1)*emg(h,5) emg(h,2)*emg(h,3) emg(h,2)*emg(h,4) emg(h,2)*emg(h,5) emg(h,3)*emg(h,4) emg(h,3)*emg(h,5) emg(h,4)*emg(h,5) emg(h,1).^2 emg(h,2).^2 emg(h,3).^2 emg(h,4).^2 emg(h,5).^2];
%     error(h,:)=[1 XY(h,:)]*K ;
e=[elec(h,1) elec(h,2) elec(h,3) elec(h,4) elec(h,5) elec(h,1)*elec(h,2) elec(h,1)*elec(h,3) elec(h,1)*elec(h,4) elec(h,1)*elec(h,5) elec(h,2)*elec(h,3) elec(h,2)*elec(h,4) elec(h,2)*elec(h,5) elec(h,3)*elec(h,4) elec(h,3)*elec(h,5) elec(h,4)*elec(h,5) elec(h,1).^2 elec(h,2).^2 elec(h,3).^2 elec(h,4).^2 elec(h,5).^2];
    emg(h,:)=elec(h,:)-[1 (e)]*K;
    X_Y(h,:)=([1 emg(h,:)]*J);

%     drawnow
end

    hold on;
    plot(X_Y(:,1),X_Y(:,2),'r')
%%

        emg=elec-(error1);
    for h=1:5300        
%         eq=[emg(h,1) emg(h,2) emg(h,3) emg(h,4) emg(h,5) emg(h,1)*emg(h,2) emg(h,1)*emg(h,3) emg(h,1)*emg(h,4) emg(h,1)*emg(h,5) emg(h,2)*emg(h,3) emg(h,2)*emg(h,4) emg(h,2)*emg(h,5) emg(h,3)*emg(h,4) emg(h,3)*emg(h,5) emg(h,4)*emg(h,5) emg(h,1).^2 emg(h,2).^2 emg(h,3).^2 emg(h,4).^2 emg(h,5).^2];        
%         e=[elec(h,1) elec(h,2) elec(h,3) elec(h,4) elec(h,5) elec(h,1)*elec(h,2) elec(h,1)*elec(h,3) elec(h,1)*elec(h,4) elec(h,1)*elec(h,5) elec(h,2)*elec(h,3) elec(h,2)*elec(h,4) elec(h,2)*elec(h,5) elec(h,3)*elec(h,4) elec(h,3)*elec(h,5) elec(h,4)*elec(h,5) elec(h,1).^2 elec(h,2).^2 elec(h,3).^2 elec(h,4).^2 elec(h,5).^2];
%         emg=e-error(h,:);
        XY(h,:)=([1 emg(h,:)]*J);
    end
%         XY= (emg*J(2:6,:))+[J(1,1) J(1,2)];
% %         err=emg-[ elec(i,1) elec(i,2) elec(i,3) elec(i,4) elec(i,5)];
%         emg_e=emg-err
%         XY= (emg_e*J(2:6,:))+[J(1,1) J(1,2)]
%         Xp_ICA_Butter = predict(Model_2_X, (emg) );
%         Yp_ICA_Butter = predict(Model_2_Y, (emg) );   
        hold on;
%         plot(Xp_ICA_Butter,Yp_ICA_Butter,'r')
        plot(XY(:,1),XY(:,2),'r')
%         hold on
%          XY=([ones(5300,1) elec]*J);
%         plot(XY(:,1),XY(:,2),'k')
%%        
date1=Block3trial12;        
date2=Block3trial15;
date3=Block3trial18;
date4=Block3trial21;
date5=Block3trial24;
date6=Block3trial27;
date7=Block3trial3;
date8=Block3trial30;
date9=Block3trial33;
date10=Block3trial36;
date11=Block3trial39;
date12=Block3trial42;
date13=Block3trial45;
date14=Block3trial48;
date15=Block3trial6;
date16=Block3trial9;

% date=[date1;date2;date3;date4;date5;date6;date7;date8;date9;date10;date11;date12;date13;date14;date15;date16];
% 
% axis([-400 400 -400 400])
% hold on;
% plot(date2(:,10),date2(:,11))
% grid
% date=[emg1;emg2;emg3;emg4;emg5;emg6;emg7;emg8;emg9;emg10;emg11;emg12;emg13;emg14;emg15;emg16];
 date=[date1;date8];
% er =  [error1;error2;error3;error4;error5;error6;error7;error8;error9;error10;error11;error12;error13;error14;error15;error16] ;
error =  ((error1 + error2 + error3 + error4 + error5 + error6 + error7 + error8 + error9 + error10 + error11 + error12 + error13 + error14 + error15 + error16)/16) ;
er=[error1;error8];
% er=[error1;error1(1279:-1:1,:);error8;error8(1200:-1:1,:)];
% er=[error1;error1(1279:-1:1,:)];
% er=[error8;error8(1200:-1:1,:)];

%   er =  [error;error;error;error;error;error;error;error;error;error;error;error;error;error;error;error];
e1 = remmean( date(:,4));
e2 = remmean( date(:,5));
e3 = remmean( date(:,6));
e4 = remmean( date(:,7));
e5 = remmean( date(:,8));

        mixedsig = [ e1'
                     e2'
                     e3'
                     e4'
                     e5'];
        s=W*mixedsig;   
        s=s';
        s1 = s(:,1); s2 = s(:,2); s3 = s(:,3); s4 = s(:,4); s5 = s(:,5);         
        e = Filt_Enveloppe(s1,s2,s3,s4,s5);

%  em2=[e(1:5300,:);e(1200:-1:1,:)];

% er=[error1;error1(1279:-1:1,:);error8;error8(1200:-1:1,:)];
me4=fitlm(([e]),er(:,4), 'quadratic', 'RobustOpts', 'on')
% me1=fitlm(e, er(:,1), 'interactions')
%         me=predict(me1, ([em1;em2]) );
% 
% 
%        plot(er(:,1))
%        grid;
%      hold on;
%      plot(me,'r')

% [e(1:5300,:);e(1279:-1:1,:)]
%%
K=[me1.Coefficients.Estimate me2.Coefficients.Estimate me3.Coefficients.Estimate me4.Coefficients.Estimate me5.Coefficients.Estimate]
save K K -v7


%%

f=[abs(forceX) error];
% test=zeros(5300,6);
test=[];
c=0;
for r=1:5300
    if f(r,1)>=1 && f(r,1)<2
        c=c+1;
        test(c,:)=f(r,:);
    end
end

%%
for h=1:5300
    XY(h,:)=([1 emg8(h,:)]*J);
end
    hold on;
    plot(XY(:,1),XY(:,2),'k')
% er0=[sum(test(:,2))/size(test,1) sum(test(:,3))/size(test,1) sum(test(:,4))/size(test,1) sum(test(:,5))/size(test,1) sum(test(:,6))/size(test,1)]

%% APRENDIZAJE CON MODIFICACIONES EN LAS TRAYECTORIAS
date1=Block3trial12;        
date2=Block3trial15;
date3=Block3trial18;
date4=Block3trial21;
date5=Block3trial24;
date6=Block3trial27;
date7=Block3trial3;
date8=Block3trial30;
date9=Block3trial33;
date10=Block3trial36;
date11=Block3trial39;
date12=Block3trial42;
date13=Block3trial45;
date14=Block3trial48;
date15=Block3trial6;
date16=Block3trial9;

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
% er=[error1;error1(5300:-1:1,:);error2;error2(5300:-1:1,:);error3;error3(5300:-1:1,:);error4;error4(5300:-1:1,:);error5;error5(5300:-1:1,:);error6;error6(5300:-1:1,:);error7;error7(5300:-1:1,:);error8;error8(5300:-1:1,:);error9;error9(5300:-1:1,:);error10;error10(5300:-1:1,:);error11;error11(5300:-1:1,:);error12;error12(5300:-1:1,:);error13;error13(5300:-1:1,:);error14;error14(5300:-1:1,:);error15;error15(5300:-1:1,:);error16;error16(5300:-1:1,:)];
er=[error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:);error;error(5300:-1:1,:)];
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

%%
K=[me1.Coefficients.Estimate me2.Coefficients.Estimate me3.Coefficients.Estimate me4.Coefficients.Estimate me5.Coefficients.Estimate me6.Coefficients.Estimate me7.Coefficients.Estimate me8.Coefficients.Estimate me9.Coefficients.Estimate me10.Coefficients.Estimate me11.Coefficients.Estimate me12.Coefficients.Estimate me13.Coefficients.Estimate me14.Coefficients.Estimate me15.Coefficients.Estimate me16.Coefficients.Estimate me17.Coefficients.Estimate me18.Coefficients.Estimate me19.Coefficients.Estimate me20.Coefficients.Estimate]
save K K -v7