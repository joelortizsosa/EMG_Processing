
path(path,'\\192.168.1.2\inria-emg\sujet17\datos')


load Block1trial1;
data1=Block1trial1;
load Block1trial2;
data2=Block1trial2;
load Block1trial3;
data3=Block1trial3;
load Block1trial4;
data4=Block1trial4;
load Block1trial5;
data5=Block1trial5;
load Block1trial6;
data6=Block1trial6;
load Block1trial7;
data7=Block1trial7;
load Block1trial8;
data8=Block1trial8;
load Block1trial9;
data9=Block1trial9;
load Block1trial10;
data10=Block1trial10;
load Block1trial11;
data11=Block1trial11;
load Block1trial12;
data12=Block1trial12;
load Block1trial13;
data13=Block1trial13;
load Block1trial14;
data14=Block1trial14;
load Block1trial15;
data15=Block1trial15;
load Block1trial16;
data16=Block1trial16;
%  load modelo_reg_mathilde_suj14;
 
% datam=[data1;data2;data3;data4];
% datam=data1;
datam=[data1;data2;data3;data4;data5;data6;data7;data8;data9;data10;data11;data12;data13;data14;data15;data16];
datam=datam./256;

%     Xc=data(:,10)/256; %11 actual X, 1 being on target ( eq to 256 pixel, 1/2 screen height) 
%     Yc=data(:,11)/256; %12 actual Y Coordination of cursor
    
%  for j=1:10:5300*2 %for j=1:(5300*2)/25:5300*2
%      try
%         xpixel = (mean(datam(j:j+9,10)));
%         ypixel = (mean(datam(j:j+9,11)));
%      end
%      
%      
% %         xpixel = ((data(j,2))-offsetX) * (target_extent * screen_height / force_level);
% %         ypixel = ((data(j,3))-offsetY) * (target_extent * screen_height / force_level);
%         
%          fuerza_x(j,1)=xpixel;
%          fuerza_y(j,1)=ypixel;
% %         [row,col]=size(fuerza_x);
% %             if (row==col)
% %             fuerza_x=xpixel;
% %             end 
% %          fuerza_x=[
% %                     fuerza_x
% %                   
% %                     ];
%                 
%         figure(7)
%         hold on
%         plot(fuerza_x(j,1),fuerza_y(j,1),'ro')
% %         axis([-350 350 -350 350])
% %        axis square
%  end
 
         xpixel = datam(:,10);
        ypixel = datam(:,11);



                 figure(7)
        hold on
        
% for j=1:10600 %for j=1:(5300*2)/25:5300*2

%          fuerza_x(j,1)=xpixel;
%          fuerza_y(j,1)=ypixel;

                
        axis([-1.5 1.5 -1.5 1.5])
        plot(xpixel,ypixel,'r.')
%         axis([-350 350 -350 350])
%        axis square
%  end