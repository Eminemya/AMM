%% Script to test reading avis on all machines
function TestAviRead()
    vr = VideoReader('~/faceStable.avi');
    hostname = char(getHostName( java.net.InetAddress.getLocalHost ));
    nF = vr.NumberOfFrames;
    fprintf('%s: %d\n', hostname, nF);
end