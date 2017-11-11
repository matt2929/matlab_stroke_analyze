clc;
close all;
clear all;


%Verticle Cup~~~~~~~~~~~~
%elder  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'VPC/7_Verticle Pick up Cup_12-7-2017_[14h~27m~21s]..csv';
%filename = 'VPC/7_Verticle Pick up Cup_12-7-2017_[14h~25m~27s]..csv';
%filename = 'VPC/8_Verticle Pick up Cup_12-8-2017_[13h~19m~57s]..csv';
%filename = 'VPC/8_Verticle Pick up Cup_12-8-2017_[13h~18m~42s]..csv';
%stroke  %%%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'VPC/Name_Verticle Pick up Cup_12-3-2017_[10h~26m~23s]..csv';
%filename = 'VPC/Name_Verticle Pick up Cup_12-3-2017_[10h~24m~32s]..csv';
%filename = 'VPC/Name_Verticle Pick up Cup_11-31-2017_[10h~25m~20s]..csv'
%filename = 'VPC/Name_Verticle Pick up Cup_11-31-2017_[10h~22m~28s]..csv'

%young      s%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'VPC/emily walker_Verticle Pick up Cup_12-4-2017_[21h~43m~14s]..csv';
%filename = 'VPC/Anne_Verticle Pick up Cup_12-4-2017_[21h~57m~46s]..csv';
%~~~~~~~~~~~~~~~~~~~~~~~~~

%Horizontal Bowl~~~~~~~~~~~~
%elder  %%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'HPC/8_Horizontal Pick up Cup_12-8-2017_[13h~24m~38s]..csv';
filename = 'HPC/8_Horizontal Pick up Cup_12-8-2017_[13h~23m~44s]..csv';
filename = 'HPC/7_Horizontal Pick up Cup_12-7-2017_[14h~30m~57s]..csv';
filename = 'HPC/7_Horizontal Pick up Cup_12-7-2017_[14h~29m~41s]..csv';

%stroke  %%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'HPC/Name_Horizontal Pick up Cup_11-31-2017_[10h~28m~16s]..csv';
filename = 'HPC/Name_Horizontal Pick up Cup_11-31-2017_[10h~26m~41s]..csv';
filename = 'HPC/Name_Horizontal Pick up Cup_12-3-2017_[10h~29m~22s]..csv';
filename = 'HPC/Name_Horizontal Pick up Cup_12-3-2017_[10h~28m~32s]..csv';

%young      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'HPC/emily walker_Horizontal Pick up Cup_12-4-2017_[21h~45m~49s]..csv';
filename = 'HPC/Anne_Horizontal Pick up Cup_12-4-2017_[21h~58m~49s]..csv';

%~~~~~~~~~~~~~~~~~~~~~~~~~


M = csvread(filename,2,1);
M = M(:,1:3)
Str = readtable(filename);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = M;
xAcc = out1(:,1);
yAcc = out1(:,2);
zAcc = out1(:,3);

for i = 1:size(yAcc,1)-1
    yAcc(i)=yAcc(i)-9.8
end

shortMe =length(TimeStamp);
TimeStamp=TimeStamp(1:shortMe);
[peaks,locs]=findpeaks(rot90(yAcc),'MinPeakDistance',0);
thresehold=0;

while (size(locs,2)> 10)
    [peaks,locs]=findpeaks(rot90(yAcc),'MinPeakDistance',thresehold);
    thresehold=thresehold+1;
end

midlocs = [1];
for i = 1:size(locs,2)-1
    diff = locs(i)+((locs(i+1)-locs(i))/2)
    midlocs=[midlocs [diff]]
end

val= (size(yAcc,1)-1)
midlocs=[midlocs [val]]

jerks = [];
for i = 1:size(midlocs,2)-1
    startX=uint32(fix(midlocs(i)))
    i2=i+1
    endX=uint32(fix(midlocs(i2)))
    trimX = yAcc(startX:endX)
    deltaT1=TimeStamp(startX)
    deltaT2=TimeStamp(endX)
    deltaDiff = (deltaT2-deltaT1)/1000
    js = JerkCalc(trimX)
    jerks = [jerks [js]] 
end

tt=midlocs(:,1:size(midlocs,2)-1)
bar(tt,rot90(jerks),.5);hold on; 
%yyaxis right
area(rot90(yAcc)); 
plot(rot90(midlocs),0,'*','color','g');
hold off;
Med = mean(jerks)

function jerk = JerkCalc(in)
    jerk= size(peaks(in),1)
end

function output = timeStampToActualTime(in)
    output = zeros(size(in(:,1)));
    for i = 1:height(in)
        str = char(in{i,1});
        hI=extractBetween(str,"","h");
        hI=hI{1,1};
        hI=str2num(hI);
        mI=extractBetween(str,"h","m");
        mI=mI{1,1};
        mI=str2num(mI);
        sI=extractBetween(str,"m","s");
        sI=sI{1,1};
        sI=str2num(sI);
        msI=extractBetween(str,"s","ms");
        msI=msI{1,1};
        msI=str2num(msI);
        totalTime=(hI*60*60*1000)+(mI*60*1000)+(sI*1000)+(msI);
        output(i)=totalTime;
    end
       output(1)=(output(2)-(output(3)-output(2)));
       for i = 2:height(in)
       output(i)=output(i)-output(1);
       end
       output(1)=0;
end
