%----USE BELOW TWO LINE CODE FOR FINDING PIXEL POSITION IN SPECTRUM----%
% A=imshow('Image_Path.jpg');
% impixelinfo(A) ;
%----------------------------------------------------------------------%


% Note:   Max wavelength = 395 nm
%         Min wavelength = 650 nm


clear all;
clc;

%read images in matlab

%First read spectrum image without sample
A=imread('image_withoutsample.jpg');
gray_image0= rgb2gray(A); %converted into greyscale for single intensity
%Then read spectrum image for sample
B=imread('image_withsample.jpg');
gray_image1= rgb2gray(B); %converted into greyscale for single intensity


% Calibrated wavelength array for pixel position (440-620)from calibration
% excel sheet
wavelength =[397.1770649
398.6087662
400.0404675
401.4721688
402.9038701
404.3355714
405.7672727
407.198974
408.6306753
410.0623766
411.4940779
412.9257792
414.3574805
415.7891818
417.2208831
418.6525844
420.0842857
421.515987
422.9476883
424.3793896
425.8110909
427.2427922
428.6744935
430.1061948
431.5378961
432.9695974
434.4012987
435.833
437.2647013
438.6964026
440.1281039
441.5598052
442.9915065
444.4232078
445.8549091
447.2866104
448.7183117
450.150013
451.5817142
453.0134155
454.4451168
455.8768181
457.3085194
458.7402207
460.171922
461.6036233
463.0353246
464.4670259
465.8987272
467.3304285
468.7621298
470.1938311
471.6255324
473.0572337
474.488935
475.9206363
477.3523376
478.7840389
480.2157402
481.6474415
483.0791428
484.5108441
485.9425454
487.3742467
488.805948
490.2376493
491.6693506
493.1010519
494.5327532
495.9644545
497.3961558
498.8278571
500.2595584
501.6912597
503.122961
504.5546623
505.9863636
507.4180649
508.8497662
510.2814675
511.7131688
513.1448701
514.5765714
516.0082727
517.439974
518.8716753
520.3033766
521.7350779
523.1667792
524.5984805
526.0301818
527.4618831
528.8935844
530.3252857
531.756987
533.1886883
534.6203896
536.0520909
537.4837922
538.9154935
540.3471948
541.7788961
543.2105974
544.6422987
546.074
547.5057013
548.9374026
550.3691039
551.8008052
553.2325065
554.6642078
556.0959091
557.5276104
558.9593117
560.391013
561.8227142
563.2544155
564.6861168
566.1178181
567.5495194
568.9812207
570.412922
571.8446233
573.2763246
574.7080259
576.1397272
577.5714285
579.0031298
580.4348311
581.8665324
583.2982337
584.729935
586.1616363
587.5933376
589.0250389
590.4567402
591.8884415
593.3201428
594.7518441
596.1835454
597.6152467
599.046948
600.4786493
601.9103506
603.3420519
604.7737532
606.2054545
607.6371558
609.0688571
610.5005584
611.9322597
613.363961
614.7956623
616.2273636
617.6590649
619.0907662
620.5224675
621.9541688
623.3858701
624.8175714
626.2492727
627.680974
629.1126753
630.5443766
631.9760779
633.4077792
634.8394805
636.2711818
637.7028831
639.1345844
640.5662857
641.997987
643.4296883
644.8613896
646.2930909
647.7247922
649.1564935
650.5881948
652.0198961
653.4515974
654.8831];


intensity0=zeros(181);  %base intensity array
intensity1=zeros(181);  %Final intensity array

x_axis=zeros(181);
cnt=1;

I_max=0;
for c=440:620
    I = gray_image0(551,c);
    % Finding maximum intensity for normalizing intensity values
    if I>I_max
        I_max=I;
    end 
    intensity0(cnt) = I;
    cnt=cnt+1;
end
cnt=1;

for c=440:620
    I = gray_image1(551,c);
    intensity1(cnt) = I;
    cnt=cnt+1;
end

I_max=double(I_max);
%normalize intensity
Ni0=zeros(size(intensity0));   %Array for normalized base intensity 
Ni1=zeros(size(intensity0));   %Array for normalized final intensity for sample
absorbance=zeros(size(intensity0)); %Array for finding absorbance

for i = 1:181
    Ni0(i)= (intensity0(i)/I_max); 
    Ni1(i)= (intensity1(i)/I_max);
    absorbance(i) = log10(Ni0(i)/Ni1(i));
end


%----------------Graph for spectrum without sample-------------------
% plot(wavelength, Ni0,'linewidth',2,'color',[0.4 1 0.4]); 
% xlim([380 700])
% ylim([0 1.1])
% title ('Base intensity graph');
% xlabel('Wavelength (nm)');
% ylabel('Intensity');
% grid on;
%---------------------------------------------------------------------

%----------------Graph for spectrum with sample-----------------------
% plot(wavelength, Ni1,'linewidth',2,'color',[0.4 0.4 1]);
% xlim([380 700])
% ylim([0 1.1])
% title ('Sample spectrum Graph');
% xlabel('Wavelength (nm)');
% ylabel('Intensity');
% grid on;
%---------------------------------------------------------------------

%----------------Absorbance Graph for sample-----------------------
plot(wavelength, absorbance,'linewidth',2,'color',[1 0.4 0.4]); 
xlim([380 700])
ylim([-0.002 1.2])
title ('Absorbance graph');
xlabel('Wavelength (nm)');
ylabel('absorbance');
grid on;
%---------------------------------------------------------------------
