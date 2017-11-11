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
%filename = 'HPC/8_Horizontal Pick up Cup_12-8-2017_[13h~24m~38s]..csv';
%filename = 'HPC/8_Horizontal Pick up Cup_12-8-2017_[13h~23m~44s]..csv';
%filename = 'HPC/7_Horizontal Pick up Cup_12-7-2017_[14h~30m~57s]..csv';
%filename = 'HPC/7_Horizontal Pick up Cup_12-7-2017_[14h~29m~41s]..csv';

%stroke  %%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'HPC/Name_Horizontal Pick up Cup_11-31-2017_[10h~28m~16s]..csv';
%filename = 'HPC/Name_Horizontal Pick up Cup_11-31-2017_[10h~26m~41s]..csv';
%filename = 'HPC/Name_Horizontal Pick up Cup_12-3-2017_[10h~29m~22s]..csv';
%filename = 'HPC/Name_Horizontal Pick up Cup_12-3-2017_[10h~28m~32s]..csv';

%young      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filename = 'HPC/emily walker_Horizontal Pick up Cup_12-4-2017_[21h~45m~49s]..csv';
%filename = 'HPC/Anne_Horizontal Pick up Cup_12-4-2017_[21h~58m~49s]..csv';

%~~~~~~~~~~~~~~~~~~~~~~~~~

M = csvread(filename,2,1);
M = M(:,1:3)
Str = readtable(filename);
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
hold off;

function jerk = JerkCalc(in)
    count = 0 
    for i = 1:size(in,1)-1
        if (in(i) < 0 &&  in(i+1) >= 0 || in(i+1) < 0 && in(i+1) >= 0)
            count = count + 1 
        end
    end
    jerk = count
end

function normal = normalize(x)
    normal = x/(max(x))
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
