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
name = "walk/young/"+name
end
if s == 2
name = "walk/old/"+name
end
if s == 3
name = "walk/stroke/"+name
end
M = csvread(name,2,1);
M = M(:,1:3)
Str = readtable(name);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = M;

xAcc = normalize(out1(:,1));
yAcc = normalize(out1(:,2));
zAcc = normalize(out1(:,3));
tAcc = xAcc + yAcc + zAcc
input = diff(tAcc)
shortMe =length(TimeStamp);
TimeStamp=TimeStamp(1:shortMe);
delays = diff(TimeStamp)
fps=1000/mean(delays)
js = JerkCalc(input)
area(rot90(input)); 
hold off;if s == 1
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
function jerk = JerkCalc(in)
    jerk=cov(in)
    
end

function normal = normalize(x)
    normal= x
end

function output = timeStampToActualTime(in)
    output = zeros(size(in(:,1)));
    for i = 2:height(in)
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
