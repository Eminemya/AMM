%% Script to test reading avis on all machines
function TestMP4Read()
    vr = VideoReader('~/guitar.mp4');
    hostname = char(getHostName( java.net.InetAddress.getLocalHost ));
    nF = vr.NumberOfFrames;
    fprintf('%s: %d\n', hostname, nF);
end