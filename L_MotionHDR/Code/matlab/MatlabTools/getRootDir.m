function out = getRootDir()
% Gets correct root directory on vision01 through vision37, doesn't work on
% europe, antartica, etc. 

    hostname = char(getHostName( java.net.InetAddress.getLocalHost ));
    if(strcmp(hostname(1:6), 'vision'))
        %out = '/csail/vision-billf2/Neal/data/';
        out = '/data/vision/billf/phase-video/';
    elseif(strcmp(hostname, 'MIKI1'))
        out = 'E:\';
    else
        out = '/home/nwadhwa/Downloads/';
    end
end

