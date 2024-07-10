%**************************************************************************
clear all ;
clc;

%**************************************************************************
%  USER SHOULD EDIT 
%**************************************************************************
% Debug mode or Run mode
global logFile;
debugMode = 0;                  % 1(0) : debug(run)

if debugMode
    logFile = 1;   % Console
else
    logFile  = fopen('logFile.txt','w');
end

%**************************************************************************
%  SERIAL PORT SETUP
%**************************************************************************
serialport = 'COM9';         % Serial Port name
baud = 19200;                 % Baud Rate 
instruments = instrfind('Port',serialport);  % Search for specific serial port
if(~isempty(instruments))
    s = instruments(1);
else
    s = serial(serialport);
end
set(s,'BaudRate',baud);       % Change the baud rate

if(~strcmp(s.Status,'open'))  % Open serial port connection
    fopen(s);
end

%**************************************************************************
%  TEST FOR CONNECTIVITY
%**************************************************************************
% fprintf('Start...\n');
% % Test UART and PicoBlaze
% while(1)
%     if(byteAvailabe(s) && fread(s,1,'uchar') == 'h' )
%       A=fread(s,4,'uchar');
%       fprintf('\nFrom PicoBlaze: H%s',A);
%       break;
%     end  
% end
emptyBuffer(s);

write_challenge(s,c,nWord)