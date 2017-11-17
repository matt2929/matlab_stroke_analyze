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
filename = 'VPC/strokeB/Name_Verticle Pick up Cup_12-3-2017_[10h~24m~32s]..csv';
%filename = 'VPC/Name_Verticle Pick up Cup_11-31-2017_[10h~25m~20s]..csv'
%filename = 'VPC/Name_Verticle Pick up Cup_11-31-2017_[10h~22m~28s]..csv'

%young      s%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'VPC/strokeB/14_Verticle Pick up Cup_12-14-2017_[14h~38m~29s]..csv';
filename = 'VPC/young/Anne_Verticle Pick up Cup_12-4-2017_[21h~57m~46s]..csv';
%~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~

M = csvread(filename,2,1);
M = M(:,1:3)
Str = readtable(filename);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = (diff(M)).^2;
xAcc = out1(:,1);
yAcc = out1(:,2);
zAcc = out1(:,3);
XpY = sum([xAcc yAcc],2);
tAcc = smooth(sum([XpY zAcc],2));
shortMe =length(TimeStamp)-1;
TimeStamp=TimeStamp(1:shortMe);
[peaks,locs]=findpeaks(rot90(tAcc),'MinPeakDistance',0);
thresehold=0;

while (size(locs,2)> 10)
    [peaks,locs]=findpeaks(rot90(tAcc),'MinPeakDistance',thresehold);
    thresehold=thresehold+1;
end

midlocs = [1];
for i = 1:size(locs,2)-1
    diff = locs(i)+((locs(i+1)-locs(i))/2)
    midlocs=[midlocs [diff]]
end

val= (size(tAcc,1)-1)
midlocs=[midlocs [val]]
scaledMid=[]
scaledMidMid=[]
jerks = [];
for i = 1:size(midlocs,2)-1
    startX=uint32(fix(midlocs(i)))
    
    i2=i+1
    endX=uint32(fix(midlocs(i2)))
    mark = 0
    in = 0
    for j = (startX:endX)
        datum = tAcc(j)
        if datum>.08 && in==0
        in = 1
        scaledMid=[scaledMid TimeStamp(j)]
        startX=j
        end
        if in == 1 && datum<.08 && (j-startX)>10
        endX=j
        scaledMid=[scaledMid TimeStamp(j)]
        scaledMidMid=[scaledMidMid TimeStamp(j)]
        break
        end
    end
    trimX = tAcc(startX:endX)
    deltaT1=startX
    deltaT2=endX
    deltaDiff = (double(deltaT2)-double(deltaT1))/10.0
    js = JerkCalc(trimX,deltaDiff)
    jerks = [jerks [js]] 
end

tt=midlocs(:,1:size(midlocs,2))
jerks=[jerks]

bar(scaledMidMid,(jerks),.5);hold on; 
yyaxis right
yStuff = M(1:size(M,1)-1,2)-9.81
area(TimeStamp,rot90(yStuff)); 
plot(rot90(scaledMid),.5,'*','color','g');
hold off;
Med = mean(jerks)
function jerk = JerkCalc(in,DeltaT)
Amplitude = 40.0;
amp =(Amplitude^2.0)
time = (DeltaT)^5.0
div = amp/time
mul = in.*(0.5)*div
jerkt=(sum(in* 0.5 * (((DeltaT)^5.0)/(Amplitude^2.0))))
jerk=jerkt.^.5;
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