function num_objects = object(img,detector)
img = preprocess(detector,img);
img = im2single(img);
[bboxes,scores,labels] = detect(detector,img,'DetectionPreprocessing','none');
num_objects = sum(scores>0.5);
