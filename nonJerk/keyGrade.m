clc;
close all;
clear all;


%Number Enter~~~~~~~~~~~~

%elder   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename='KN/Name_Key Unlock_12-10-2017_[1h~55m~42s].csv'
%stroke  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%young   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%~~~~~~~~~~~~~~~~~~~~~~~~~

M = csvread(filename,2,1);
M = M(:,1:2)
Str = readtable(filename);
Str = Str(:,1);
TimeStamp = timeStampToActualTime(Str);
out1 = M;

xAcc = out1(:,1);
yAcc = out1(:,2);
shortMe =length(TimeStamp);
TimeStamp=TimeStamp(1:shortMe);
delays = diff(TimeStamp)
fps=1000/mean(delays)
js = JerkCalc(xAcc,yAcc)
plot(xAcc,yAcc); 
hold off;

function jerk = JerkCalc(inX,inY)
total =0;
    count = 0 
    for i = 1:size(inX,1)-1
        count=count+((inX(i+1)-inX(i)^2 + inY(i+1)-inY(i))^2)^.5
    end
    jerk = count
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
