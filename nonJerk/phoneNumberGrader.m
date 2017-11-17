clc;
close all;
clear all;

gradesy=[];
gradeso=[];
gradess=[];
speedsy=[];
speedso=[];
speedss=[];
figure;
for s = 1:3
    myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.csv')); %gets all wav files in struct

for k = 1:length(myFiles)
name = myFiles(k).name
if s == 1
name = "PN/young/"+name
end
if s == 2
name = "PN/old/"+name
end
if s == 3
name = "PN/stroke/"+name
end
a = read_mixed_csv(name,',')
x=a(:,4)
Str = readtable(name);
%StrT = cell2mat(x)
%StrB = Str(:,4);
TimeStamp = timeStampToActualTime(a(3:size(a,1),1));
input = diff(TimeStamp)
shortMe =length(TimeStamp);
TimeStamp=TimeStamp(1:shortMe);
delays = diff(TimeStamp)
fps=1000/mean(delays)
js = JerkCalc(x)
ts = timeCalc(x,TimeStamp)

area(rot90(input)); 
hold off;
if s == 1
gradesy = [gradesy js]
speedsy = [speedsy ts]
end
if s == 2
    
gradeso = [gradeso js]
speedso = [speedso ts]
end
if s == 3
speedss = [speedss ts]
gradess = [gradess js]
end
end
end
subplot(3,1,1)
boxplot(gradesy, 'colors', 'r')
subplot(3,1,2)
boxplot(gradeso, 'colors', 'b')
subplot(3,1,3)
boxplot(gradess, 'colors', 'g')

function jerk = JerkCalc(in)
    false = 0
    true =0
    for i = 1:size(in,1)-1
        strX = char(cell2mat(in(i)))
        strX = strX
        if (strcmp(strX,'false') == 1)
            false = false + 1 
        end
         if (strcmp(strX,'true') == 1)
            true = true + 1 
        end
    end
    jerk = ((true-false)/(true))*100
end

function jerk = timeCalc(in,inT)
    last=0
    totalSum=0
    totalCount=0
    for i = 1:size(in,1)-1
        strX = char(cell2mat(in(i)))
        strX = strX
        if (strcmp(strX,'false') == 1)
            totalSum = totalSum + inT(i)
            totalCount = totalCount + 1
            last = inT(i)
        end
         if (strcmp(strX,'true') == 1)
            totalSum = totalSum + inT(i)
            totalCount = totalCount + 1
            last = inT(i)
        end
    end
    jerk = (totalSum/totalCount)
end

function normal = normalize(x)
    normal = x/(max(x))
end

function output = timeStampToActualTime(in)
    output = zeros(size(in(:,1)));
    for i = 1:size(in,1)
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
       for i = 2:size(in,1)
       output(i)=output(i)-output(1);
       end
       output(1)=0;
end
function lineArray = read_mixed_csv(fileName,delimiter)
  fid = fopen(fileName,'r');   %# Open the file
  lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly
                               %#   larger than is needed)
  lineIndex = 1;               %# Index of cell to place the next line in
  nextLine = fgetl(fid);       %# Read the first line from the file
  while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
    lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
    lineIndex = lineIndex+1;          %# Increment the line index
    nextLine = fgetl(fid);            %# Read the next line from the file
  end
  fclose(fid);                 %# Close the file
  lineArray = lineArray(1:lineIndex-1);  %# Remove empty cells, if needed
  for iLine = 1:lineIndex-1              %# Loop over lines
    lineData = textscan(lineArray{iLine},'%s',...  %# Read strings
                        'Delimiter',delimiter);
    lineData = lineData{1};              %# Remove cell encapsulation
    if strcmp(lineArray{iLine}(end),delimiter)  %# Account for when the line
      lineData{end+1} = '';                     %#   ends with a delimiter
    end
    lineArray(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
  end
end
