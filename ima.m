
function Main
close all;
filename = 'grayscale.jpg'; % 'grayscale.jpg'
global Red; global Green; global Blue;

X = imread(filename);  
global image ;
image = X;
imshow(filename);
Before_Contrast = getContrast(X);

Red = X(:,:,1);Green = X(:,:,2);Blue= X(:,:,3);
DrawHist(X,0); %calculated or not
After_Contrast = getContrast(image);
figure();imshow(image);
end
function [redHist greenHist blueHist]  = DrawHist(image,Calculated)

red = image(:,:,1); green = image(:,:,2); blue=image(:,:,3);
redHis(:,1) = imhist(red); 
greenHist(:,1) = imhist(green); 
blueHist(:,1) = imhist(blue);

figure();
set(gcf, 'Name', 'Histogram', 'NumberTitle', 'Off','position', [500, 0, 800, 800]);

subplot(3,1,1);  histogram(red);  title('Red Histogram');
subplot(3,1,2);  histogram(green); title('Green Histogram');
subplot(3,1,3); histogram(blue);   title('Blue Histogram');

CalculateCDF(redHis,greenHist,blueHist,Calculated);

end
function [redHist greenHist blueHist]  = CalculateCDF(redHist,greenHist,blueHist,Calculated);
global Red; N = length(Red(1,:));   M = length(Red(:,1));
redHist(:,2) = redHist(:,1) / (N*M);    redHist(:,2) = cumsum(redHist(:,2));
greenHist(:,2) = greenHist(:,1) / (N*M);    greenHist(:,2) = cumsum(greenHist(:,2));
blueHist(:,2) = blueHist(:,1) / (N*M);    blueHist(:,2) = cumsum(blueHist(:,2));
image = zeros(1,1);
figure();
set(gcf, 'Name', 'Histogram', 'NumberTitle', 'Off','position', [500, 0, 800, 800]);
subplot(3,1,1);  plot(redHist(:,2));  title('Red CDF');
subplot(3,1,2);  plot(greenHist(:,2)); title('Green CDF');
subplot(3,1,3);  plot(blueHist(:,2));   title('Blue CDF');

if(Calculated == 0)
    CalculateEqualization(redHist,greenHist,blueHist);
end
end
function [RedHist GreenHist BlueHist] = CalculateEqualization (RedHist,GreenHist,BlueHist)
global Red; global Green;   global Blue;
ColorNumber =256;
L_Value = ColorNumber - 1;
RedHist(:,3) = floor(L_Value * RedHist(:,2));
GreenHist(:,3) = floor(L_Value * GreenHist(:,2));
BlueHist(:,3) = floor(L_Value * BlueHist(:,2));
NewHSV(Red,Green,Blue,RedHist,GreenHist,BlueHist)
end
function [Calculated]=NewHSV(Red,Green,Blue,RedHist,GreenHist,BlueHist)
N = length(Red(:,1));
M = length(Red(1,:));
global image;
for i=1:N
    for j=1:M
        Red(i,j)       = RedHist( floor  (Red(i,j)+1 ),3); 
        Green(i,j)     = GreenHist( floor(Green(i,j)+1 ),3); 
        Blue(i,j)      = BlueHist(floor  (Blue(i,j) )+1,3); 
    end
end
image(:,:,1) = Red; image(:,:,2) = Green; image(:,:,3) = Blue;

DrawHist(image,1);
end
function [Contrast] = getContrast(image)
HSV_im = rgb2hsv(image);
Value = HSV_im(:,:,3);
figure(); 
histogram(Value);
title('Value Histogram');
maxValue = max(max(Value));
minValue = min(min(Value));
Contrast = maxValue - minValue
end

  

