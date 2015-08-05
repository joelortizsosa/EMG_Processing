
close all
for i=5:9
   eval(['load Block1trial',num2str(i),';']) 
   eval(['data =  Block1trial',num2str(i),';'])
   
   figure(i)
   for m=1:5
       subplot(5,1,m)
       plot(data(:,m+3))
       axis([0 20000 -100 100])
       
   end
end