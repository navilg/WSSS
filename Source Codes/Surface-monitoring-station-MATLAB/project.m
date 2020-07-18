function [] = project()

%FINAL YEAR PROJECT

% WIRELESS SURVEILLANCE AND SAFETY SYSTEM FOR MINE WORKERS USING ZIGBEE

%EC12015 NAMRATA BHAGAT
%EC12016 NAVRATAN LAL GUPTA
%EC12040 SHALAKA POKLEY
%EC12051 PRAGYA KUMARI
 
clear all; clc; close all;
disp('WELCOME');
disp(' ');
disp('WIRELESS SURVEILLANCE AND SAFETY SYSTEM FOR MINE WORKERS USING ZIGBEE');
disp(' ');
disp('Projectees: ');
disp('EC12015 NAMRATA BHAGAT');
disp('EC12016 NAVRATAN LAL GUPTA');
disp('EC12040 SHALAKA POKLEY');
disp('EC12051 PRAGYA KUMARI');

%handling file
y=wavread('G:\Academic\Mega Project\project\Programs\Alert sound\alarmn2.wav');
sir=wavread('G:\Academic\Mega Project\project\Programs\Alert sound\siren.wav');
file='G:\Academic\Mega Project\project\Programs\Database\record.xlsx';

disp('Choose from following');
disp(' ');
disp('1. Start Monitoring');
disp('2. Read previous records');
disp('3. Exit');
ans1=input('Choose any one from above (1,2 or 3): ');
disp('In case of emergency press CTRL+C to terminate and restart MATLAB again');
switch ans1
    case 1
        
% Try-catch is to prevent Matlab from crashing when the program is finished
try
    s=serial('COM16');
    stopasync(s);
    fclose(s); %Close serial object 
    delete(s); %Delete serial object
    clear s;    
s=serial('COM16'); %initialising com port(here COM16)
set(s,'BaudRate', 115200);
set(s,'DataBits', 8);
set(s,'StopBits', 1);
fopen(s);
s.ReadAsyncMode = 'continuous'; %manual/continuous

% numberOfDatas=288; %maximum nuber of data for 24 hours with 1 reading/5 minutes.
numberOfDatas = 12; % maximum number of data for 1 minute Demo. with 1 reading/5 second
check = zeros(1, numberOfDatas); %initialising array
data1 = zeros(1, numberOfDatas); %initialising array
data2 = zeros(1, numberOfDatas); %initialising array
data3 = zeros(1, numberOfDatas); %initialising array

i = 1; %counter
  
% Main graph figure
figure(1); %for humidity
hold on;
title('Humidity level');
xlabel('Data Number');
ylabel('Humidity in %RH');

figure(2); %for temperature
hold on;
title('Temperature level');
xlabel('Data Number');
ylabel('Temperature in °C');

figure(3); %for methane
hold on;
title('Methane gas level');
xlabel('Data Number');
ylabel('Methane value in ppb');
  
readasync(s); % Start asynchronous reading
 
 
while(i<=numberOfDatas) 
    
    check(i)=fscanf(s,'%d'); %check bits 1
    data1(i) = fscanf(s, '%d'); % Get the humidity value from the serial object
    data2(i) = fscanf(s, '%d'); % Get the temperature value from serial object
    data3(i) = fscanf(s, '%d'); %Get the methane value from serial object
    if(check(i)==110)
        close(1);
        close(2);
        close(3);
        clc;
        disp('EMERGENCY !!!...Need Help... Rush inside mine.');
        for i=1:1:3
        sound(sir,45000,8);
        end
        disp(' ');
disp('Saving... Please Wait...');
humread=xlsread(file,'Humidity'); %read humidity sheet from file
tempread=xlsread(file,'Temperature'); %read temperature sheet from file
methread=xlsread(file,'Methane'); %read methane sheet from file
rh=(size(humread,1)); %Number of rows
rt=(size(tempread,1));
rm=(size(methread,1));
rh=rh+1;
rt=rt+1;
rm=rm+1;
b1=num2str(rh); %convert numerical to string
b2=num2str(rt);
b3=num2str(rm);

 c1=strcat('A',b1); %adding data in column A
 xlswrite(file,data1,'Humidity',c1); %write data in file
 c2=strcat('A',b2);
 xlswrite(file,data2,'Temperature',c2);
 c3=strcat('A',b3);
 xlswrite(file,data3,'Methane',c3);
 
 disp(' ');
 disp('Data saved...');
    disp(' ');
ans=1;
disp('0 Exit');
disp('1 Main Menu');
ans=input('Choose option(0 or 1): ');
if(ans==1) %Closing MATLAB to close COM port
    stopasync(s);
    fclose(s); %Close serial object 
    delete(s); %Delete serial object
    clear s;
    project;
else
    exit;
end
    end
    
    data3(i)=(data3(i)*5)/1023; %converting binary to voltage
    
     if (data3(i)<=3)    % converting voltage to ppb
    data3(i)=1294*data3(i)-1282;
    else
        data3(i)=11667*data3(i)-32800;
    end
   
    % Plotting humidity
    figure(1);
    if(data1(i)<60)
    plot(i, data1(i), '--gs');
    grid on;
    else
        plot(i,data1(i),'--rs');
        grid on;
    end
    if(i>10) % Ensure there are always 10 tick marks on the graph
       xlim([i-8 i+1]);
       set(gca,'xtick',[i-8 i-7 i-6 i-5 i-4 i-3 i-2 i-1 i i+1])
    end
    drawnow; %Refresh figure with new value
     
   % data2(i) = fscanf(s, '%d'); % Get the temperature value from serial object
    
    
 % plotting Temperature
   figure(2);
    if(data2(i)<45)
    plot(i, data2(i), '--gs');
    grid on;
    else
        plot(i,data2(i),'--rs');
        grid on;
    end
    if(i>10)
       xlim([i-8 i+1]);
       set(gca,'xtick',[i-8 i-7 i-6 i-5 i-4 i-3 i-2 i-1 i i+1])
    end
    drawnow;
    
   % data3(i) = fscanf(s, '%d'); %Get the methane value from serial object
    
    
   %Plotting Methane value
   figure(3);
    if(data3(i)<1500)
    plot(i, data3(i), '--gs');
    grid on;
    else
        plot(i,data3(i),'--rs');
        grid on;
    end
    if(i>10)
       xlim([i-8 i+1]);
       set(gca,'xtick',[i-8 i-7 i-6 i-5 i-4 i-3 i-2 i-1 i i+1])
    end
    drawnow;
    if(i>2)
        if(data1(i-2)>60||data2(i-2)>45||data3(i-2)>1500)
            if(data1(i-1)>60||data2(i-1)>45||data3(i-1)>1500)
                if(data1(i)>60||data2(i)>45||data3(i)>1500)
                disp('ALERT !!!');
                sound(y,45000,8);
                end
            end 
        end 
    end 
    
    

    i=i+1;     %Increment the counter
    
end
close(1);
close(2);
close(3);
    stopasync(s);
    fclose(s); %Close serial object 
    delete(s); %Delete serial object
    clear s;
    clc;
    disp(' ');
disp('Saving... Please Wait...');
humread=xlsread(file,'Humidity'); %read humidity sheet from file
tempread=xlsread(file,'Temperature'); %read temperature sheet from file
methread=xlsread(file,'Methane'); %read methane sheet from file
rh=(size(humread,1)); %Number of rows
rt=(size(tempread,1));
rm=(size(methread,1));
rh=rh+1;
rt=rt+1;
rm=rm+1;
b1=num2str(rh); %convert numerical to string
b2=num2str(rt);
b3=num2str(rm);

 c1=strcat('A',b1); %adding data in column A
 xlswrite(file,data1,'Humidity',c1); %write data in file
 c2=strcat('A',b2);
 xlswrite(file,data2,'Temperature',c2);
 c3=strcat('A',b3);
 xlswrite(file,data3,'Methane',c3);
 
 disp(' ');
 disp('Data saved...');
 disp(' ');
ans=1;
disp('0 Exit');
disp('1 Main Menu');
ans=input('Choose option(0 or 1): ');

if(ans==1) %Closing MATLAB to close COM port 
    project;
else
    exit;
end
% Give the external device some time…
pause(5);
return;
catch
                                        
stopasync(s);
fclose(s); % bad
delete(s);
clear s;
 
fprintf(1, 'Sorry, you"re going to have to close out of Matlab to close the serial port\n');
exit;
 
return
 
end

    case 2
        clc
        disp('Reading records... Please Wait...');
        humread=xlsread(file,'Humidity'); %read humidity sheet from file
        tempread=xlsread(file,'Temperature'); %read temperature sheet from file
        methread=xlsread(file,'Methane'); %read methane sheet from file
        clc
        disp('Humidity:');
        disp(' ');
        disp(humread);
        disp(' ');
        disp('Temperature');
        disp(' ');
        disp(tempread);
        disp(' ');
        disp('Methane');
        disp(' ');
        disp(methread);
        disp(' ');
        disp('0 Exit');
        disp('1 Main Menu');
        ans=input('Choose option (0 or 1): ');
        if(ans==1)
            project;
        else
            exit;
        end
      
    case 3
        exit;
end
        
end
