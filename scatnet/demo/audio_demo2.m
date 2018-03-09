% Prepare file index & class assignments.
clc
clear
%src = gtzan_src('/path/to/gtzan/dataset');
src = gtzan_src('C:\Users\HaoChris\Documents\MATLAB\genres');

% Sound files will be truncated to 5*2^17 samples by default, so let's define
% the filters for this length.
N = 5*2^17;

% Calculate coefficients with averaging scale of 8192 samples (~370 ms @
% 22050 Hz sampling rate).
T = 8192;

% First-order filter bank with 8 wavelets per octave. Second-order filter bank
% with 1 wavelet per octave.
filt_opt.Q = [8 1];
% Calculate maximal wavelet scale so that largest wavelet will be of bandwidth 
% T.
filt_opt.J = T_to_J(T, filt_opt);

% Only calculate scattering coefficients up to second order.
scat_opt.M = 2;

% Prepare wavelet transforms to be used for scattering.
Wop = wavelet_factory_1d(N, filt_opt, scat_opt);

% Define feature function, taking a signal as input and returning a table
% of feature vectors.
feature_fun = @(x)(format_scat(log_scat(renorm_scat(scat(x, Wop)))));

% Only store every eighth feature vector (to reduce training complexity 
% later).
database_options.feature_sampling = 8;

% Calculate feature vectors for all files in src using feature_fun.
database = prepare_database(src, feature_fun, database_options);

%% PCA 

db= database;

prop = 0.5;
% split between training and testing
[train_set, test_set] = create_partition(src, prop);
% dimension of the affine pca classifier
train_opt.dim = 20;
% training
model = affine_train(db, train_set, train_opt);
% testing
labels = affine_test(db, model, test_set);
% compute the error
error = classif_err(labels, test_set, src);

%% SVM --not working

%{
% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
% Split files into training and testing sets 80-20.
[train_set, test_set] = create_partition(src, 0.8);

% Precalculate a Gaussian kernel for the feature vectors to speed up training
% and testing.
database = svm_calc_kernel(database, 'gaussian');

% Specify kernel type and range of parameters to test.
svm_options.kernel_type = 'gaussian';
svm_options.C = 2.^[0:4:8];
svm_options.gamma = 2.^[-16:4:-8];

% For each combination of parameters, calculate the five-fold cross-validation
% error over the trainings et.
[err,C,gamma] = svm_param_search(database, train_set, [], svm_options);

% Identify the best-performing set of parameters.
[temp,ind] = min(mean(err,2));
C_best = C(ind);
gamma_best = gamma(ind);

svm_options.C = C_best;
svm_options.gamma = gamma_best;

% Train model on the whole training set using the optimal parameters.
model = svm_train(database, train_set, svm_options);
% Predict the labels on the test set using the model.
labels = svm_test(database, model, test_set);

% Calculate the error with respect to ground truth.
test_err = classif_err(labels, test_set, src);

%}
