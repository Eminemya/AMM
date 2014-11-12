function out = getOutDir()
% Gets correct root directory on vision01 through vision37, doesn't work on
% europe, antartica, etc. 

    hostname = char(getHostName( java.net.InetAddress.getLocalHost ));
    if(strcmp(hostname(1:6), 'vision'))
    %        out = '/csail/vision-billf2/Neal/Videos/';
        out = '/scratch/neal/Videos/';
    else
        out = '/home/nwadhwa/Downloads/output/';
    end
end

