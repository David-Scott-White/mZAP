function imageData = projectROIsNew(imageData)
% David S. White
% dswhite2012@gmail.com
% Updates:
% --------
% 2019-11-27 DSW Began writing code. Will work from data provided by
% imageProjectionGUI

% details about imageData structure

% check to see if data is loaded
if ~exist('imageData','var')
    [file,path] = uigetfile('*.mat');
    load([path,file]);
end

numImages = imageData.info.numImages; 
numChannels = imageData.info.numChannels;

% need to loop thorugh all number of images
for i = 1:numImages
    imageStacks = cell(numChannels,1);
    imageAlign = cell(numChannels,1);
    imageMask = [];
    for n = 1:numChannels
        % load the image stacks
        imagePath = imageData.stacks.path{n};
        imageFile = imageData.stacks.files{n}{i,1};
        imageStack{1,1} = loadTiffStack(fullfile(imagePath,imageFile));
        
        % background substraction
        if imageData.background.applyToChannels(n)
            imageStack{1,1} = subBackground(imageStack{1,1},'White Top Hat');
        end
        
        % load alignment files
        if imageData.alignment.peformAlignment
            % write function here...
            
            % perform affinement for affine transform
            
            % store transforms 
        end
        
    end
    % load image mask if it exists
    maskChannel = imageData.masks.maskChannel;
    if imageData.masks.createMask
        
        % temp until function edit
        options = []; 
        show = 1; 
        mask = createMask(imageStack{maskChannel,1},options,show);
           
    else
        % should be returned as a cell but it is not... hmmm
        maskPath = imageData.masks.path
        % should be files not maskFiles... ugh 
        maskFile = imageData.masks.maskFiles{n}
        imageMask = loadTiffStack(fullfile(maskPath,maskFile)); 
    end

    % find rois in image mask
    
    
end



% need to change maskFiles to just files in the mask output of imageData


% load the mask file
fp = fullfile(imageData.ImageStacks.path{1},char(imageData.ImageStacks.files{1,1}))

fp = '/Users/dwhite7/Desktop/testimages/img001_loc180-A1-BL_BF.tif'
image1 = loadTiffStack(fp);
figure
original = image1(:,:,1)
imshow(original,[])

nhood = [0,1,1,0; 1,1,1,1; 1,1,1,1;0,1,1,0];

muimage1 = mean(image1(:,:,1:100),3);
muimage1 = subtractBackground(muimage1,'White Top Hat', nhood);

normImage = mat2gray(muimage1);

%mask = im2bw(normImage, 0.1);
mask = imbinarize(normImage,'global');
figure
imshowpair(normImage,mask,'montage');


filtered = subtractBackground(image1,'White Top Hat', nhood);

figure
filtered = image1;
tic
for i= 1:size(image1,3);
    filtered(:,:,i) = imtophat(image1(:,:,i),nhood);
end
toc
imshow(imtophat(image1(:,:,1),nhood),[])


