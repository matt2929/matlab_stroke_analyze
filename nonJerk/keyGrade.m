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
name = "KN/young/"+name
end
if s == 2
name = "KN/old/"+name
end
if s == 3
name = "KN/stroke/"+name
end
M = csvread(name,2,1);
M = M(:,1:2)
Str = readtable(name);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = M;

good = out1(:,2);
shortMe =length(TimeStamp);
TimeStamp=TimeStamp(1:shortMe);
delays = diff(TimeStamp)
fps=1000/mean(delays)
js = JerkCalc(M)

hold off;
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

function jerk = JerkCalc(in)
    count = 0
    x=in(:,1)
    y=in(:,2)
    plot(x,y)
    for i = 1:size(in,1)-1
            count=count+(x(i)-x(i+1)).^2+((y(i)-y(i+1)).^2).^.5
      end
    jerk = (3200000-count)/3200000
    %jerk= cov(x)+cov(y)
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
