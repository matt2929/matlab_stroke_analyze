clc;
close all;
clear all;

gradesy=[];
gradeso=[];
gradess=[];
figure;
for s = 1:3
    myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.csv')); %gets all wav files in struct

for k = 1:length(myFiles)
name = myFiles(k).name
if s == 1
name = "VPB/young/"+name
end
if s == 2
name = "VPB/old/"+name
end
if s == 3
name = "VPB/stroke/"+name
end
M = csvread(name,2,1);
M = M(:,1:3)
Str = readtable(name);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = (diff(M)).^2;
xAcc = out1(:,1);
yAcc = out1(:,2);
zAcc = out1(:,3);
XpY = sum([xAcc yAcc],2);
tAcc = sum([XpY zAcc],2);
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
    diffS = locs(i)+((locs(i+1)-locs(i))/2)
    midlocs=[midlocs [diffS]]
end

val= (size(tAcc,1)-1)
midlocs=[midlocs [val]]

jerks = [];
for i = 1:size(midlocs,2)-1
    startX=uint32(fix(midlocs(i)))
    i2=i+1
    endX=uint32(fix(midlocs(i2)))
    trimX = tAcc(startX:endX)
    deltaT1=TimeStamp(startX)
    deltaT2=TimeStamp(endX)
    deltaDiff = (deltaT2-deltaT1)/1000
    js = JerkCalc(trimX,deltaDiff)
    jerks = [jerks [js]] 
end

tt=midlocs(:,1:size(midlocs,2)-1)
bar(tt,rot90(jerks),.5);hold on; 
yyaxis right
area(rot90(tAcc)); 
plot(rot90(midlocs),.5,'*','color','g');
hold off;
Med = mean(jerks)
if s == 1
gradesy = [gradesy js]
end
if s == 2
    
gradeso = [gradeso js]
end
if s == 3
    
gradess = [gradess js]
end
end
end
function jerk = JerkCalc(in,DeltaT)
Amplitude = 40;
jerk=sum(in* 0.5 * (((DeltaT)^5)/(Amplitude^2.0)));
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
