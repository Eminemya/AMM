%% Mark corners of caltag pattern in unstable video using colors
%
% Neal Wadhwa, June 2013

function markCaltagPoints(vidFile, outVidFile)

    vr = VideoReader(vidFile);


    vw = VideoWriter(outVidFile);
    vw.Quality = 90;
    vw.FrameRate = vr.FrameRate;
    vw.open();

    colors = jet(45);
    T{1} = eye(3);
    for k = 1:80
        k

       [wPt, iPt] = caltag(rgb2y(im2single(vr.read(k))), 'output.mat',false);

       % find matches
       fig = figure('Visible', 'off');
       imshow(im2single(vr.read(k)));
       hold on;
       for j = 1:size(wPt,1)
           colorIdx = wPt(j,1)+8*wPt(j,2);
           color = colors(colorIdx,:);
           plot( iPt(j,2), iPt(j,1), '-m+', 'Color', color, 'MarkerSize',10 );
           plot( iPt(j,2), iPt(j,1), '-mo','Color', color, 'MarkerSize',10 );
           plot( iPt(j,2), iPt(j,1), '-m*','Color', color, 'MarkerSize',10 );              
       end
       frame = getframe(fig);       
       vw.writeVideo(frame.cdata);
       close all;
    end
    vw.close();
end