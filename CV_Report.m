Actual  = CumulativeActualMulti;
Predict = CumulativePredictMulti;

Act{1} = CumulativeActualClass0;
Act{2} = CumulativeActualClass1;
Act{3} = CumulativeActualClass2;
Act{4} = CumulativeActualClass3;
Act{5} = CumulativeActualClass4;

Pre{1} = CumulativePredictClass0;
Pre{2} = CumulativePredictClass1;
Pre{3} = CumulativePredictClass2;
Pre{4} = CumulativePredictClass3;
Pre{5} = CumulativePredictClass4;

sumspec=0; sumsens=0; %initialize before any runs

for i=1:5,
  %Statistics for Binary Matrices
  [c,cm,ind,per] = confusion(Act{i},Pre{i});

  spec(i) = cm(2,2) / (cm(2,2) + cm(1,2));
  sens(i) = cm(1,1) / (cm(1,1) + cm(2,1));
  prec(i) = per(1,3);
  accu(i) = (cm(1,1) + cm(2,2)) / (cm(1,1) + cm(1,2) + cm(2,1) + cm(2,2));

  %I would like to store the values of each binary calculation.
  sumspec = spec(i) + sumspec;
  sumsens = sens(i) + sumsens;
end

title      = input('Please enter a title (CV Confusion Matrices): ', 's');
classifier = input('Please enter classifier type (Random Forest): ', 's');
dataset    = input('Please enter Data Set Name (AprilDataSet-10Fold): ', 's');
parameters = input('Please enter any parameters used (mtry=.8, ntrees=100): ', 's');
outfile    = input('Please enter an output filename: ', 's');
FH = fopen(outfile, 'w');

fprintf(FH, 'Title, Classifier, Data Set, Parameters, , , , \n');
fprintf(FH, '%s, %s, %s, %s, , , , \n', title, classifier, dataset, parameters);
fprintf(FH, '\n');

%Statistics for Multinomial Matrices
[c,cm,ind,per]=confusion(Actual,Predict);
cm=cm';   %transposed for personal readability

[nr,nc]=size(cm);
specificity=sumspec/nr; 
sensitivity=sumsens/nr;
precision=sum(per(:,3))/nr;  %average the precisions of each class

tot=0;
sumcor=0; %initialize
for r=1:nr
    for c=1:nc
    if r==c
        sumcor=sumcor+cm(r,c);
    end
    tot=tot+cm(r,c);
    end
end
accuracy=sumcor/tot; 

fprintf(FH, 'Class,Multi,,A0,A1,A2,A3,A4\n');
fprintf(FH, 'Accuracy,%f,P0,%f,%f,%f,%f,%f\n', accuracy,    cm(1,1), cm(1,2), cm(1,3), cm(1,4), cm(1,5));
fprintf(FH, 'Precision,%f,P1,%f,%f,%f,%f,%f\n', precision,   cm(2,1), cm(2,2), cm(2,3), cm(2,4), cm(2,5));
fprintf(FH, 'Sensitivity,%f,P2,%f,%f,%f,%f,%f\n', sensitivity, cm(3,1), cm(3,2), cm(3,3), cm(3,4), cm(3,5));
fprintf(FH, 'Specificity,%f,P3,%f,%f,%f,%f,%f\n', specificity, cm(4,1), cm(4,2), cm(4,3), cm(4,4), cm(4,5));
fprintf(FH, ',,P4,%f,%f,%f,%f,%f\n',              cm(5,1), cm(5,2), cm(5,3), cm(5,4), cm(5,5));
fprintf(FH, '\n');

for i=1:5,

  %Statistics for Binary Matrices
  [c,cm,ind,per] = confusion(Act{i},Pre{i});

  % ca{i}  = c; 
  % cma{i} = cm; 
  % inda{i} = ind; 
  % pera{i} = per;

  spec(i) = cm(2,2) / (cm(2,2) + cm(1,2));
  sens(i) = cm(1,1) / (cm(1,1) + cm(2,1));
  prec(i) = per(1,3);
  accu(i) = (cm(1,1) + cm(2,2)) / (cm(1,1) + cm(1,2) + cm(2,1) + cm(2,2));

  fprintf(FH, 'Class,      %d,  ,  0,  1, , , \n', i-1);
  fprintf(FH, 'Accuracy,   %f, 0, %f, %f, , , \n', accu(i), cm(1,1), cm(1,2));
  fprintf(FH, 'Precision,  %f, 1, %f, %f, , , \n', prec(i), cm(2,1), cm(2,2));
  fprintf(FH, 'Sensitivity,%f,  ,   ,   , , , \n', sens(i));
  fprintf(FH, 'Specificity,%f,  ,   ,   , , , \n', spec(i));
  fprintf(FH, '\n');
end
fclose(FH);


% Title, Classifier, Data Set, Parameters, , , , , 
% CV Confusion Matrices, RF, April_Partitions, ntrees=100, , , , , 
% 
% Class, Multi, ,0, 1, 2, 3, 4
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , ,
% Sensitivity, ,2, , , , , 
% Specificity, ,3, , , , , 
% , ,4, , , , , 
% 
% Class, 0, ,0, 1,  , , 
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , , 
% Sensitivity, , , , , , , 
% Specificity, , , , , , , 
% 
% Class, 1, ,0, 1, , , 
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , , 
% Sensitivity, , , , , , , 
% Specificity, , , , , , , 
% 
% Class, 2, ,0, 1,  , , 
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , , 
% Sensitivity, , , , , , , 
% Specificity, , , , , , , 
% 
% Class, 3, ,0, 1,  , , 
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , , 
% Sensitivity, , , , , , , 
% Specificity, , , , , , , 
% 
% Class, 4, ,0, 1,  , , 
% Accuracy, ,0, , , , ,
% Precision, ,1, , , , , 
% Sensitivity, , , , , , , 
% Specificity, , , , , , , 
% 

