function [backgroundMask] = segmentBackground(imageFile, annotationFile)
ima = imread(imageFile);
annotation_file = load(annotationFile);

% IMTYPE = 'jpg'; 
% GUIDELINE_MODE = 1; 
% LARGEFONT = 28; 
% MEDFONT = 18; 
% BIG_WINDOW = get(0,'ScreenSize'); 
% SMALL_WINDOW = [100 100 512 480]; 

%load(annotation_file, 'box_coord', 'obj_contour');
box_coord = annotation_file.box_coord;
obj_contour = annotation_file.obj_contour;

% %ima = imread(imgfile); 
% ff=figure(1); clf; imagesc(ima); axis image; axis ij; hold on;
% % black and white images
% if length(size(ima))<3
%    colormap(gray);
% end
% set(ff,'Position',SMALL_WINDOW); 
% 
% box_handle = rectangle('position', [box_coord(3), box_coord(1), box_coord(4)-box_coord(3), box_coord(2)-box_coord(1)]);
% set(box_handle, 'edgecolor','y', 'linewidth',5);
% 
% for cc = 1:size(obj_contour,2)
%    if cc < size(obj_contour,2)
%       plot([obj_contour(1,cc), obj_contour(1,cc+1)]+box_coord(3), [obj_contour(2,cc), obj_contour(2,cc+1)]+box_coord(1), 'r','linewidth',4);
%    else
%       plot([obj_contour(1,cc), obj_contour(1,1)]+box_coord(3), [obj_contour(2,cc), obj_contour(2,1)]+box_coord(1), 'r','linewidth',4);
%    end
% end

foregroundMask = roipoly(ima, obj_contour(1, :)+box_coord(3), obj_contour(2, :)+box_coord(1));
backgroundMask = uint8(~foregroundMask);

% r = ima(:, :, 1);
% g = ima(:, :, 2);
% b = ima(:, :, 3);
% backgroundColorR = backgroundMask .* r;
% backgroundColorG = backgroundMask .* g;
% backgroundColorB = backgroundMask .* b;
% numberBackgroundPixels = sum(backgroundMask(:));
% 
% meanBackgroundColorR = sum(backgroundColorR(:))/numberBackgroundPixels;
% meanBackgroundColorG = sum(backgroundColorG(:))/numberBackgroundPixels;
% meanBackgroundColorB = sum(backgroundColorB(:))/numberBackgroundPixels;


%title(imgfile);
 
end