% cca_Process.m
% ----------------------

% Author: Ashley Bishop
% Date: 15 May 2022

%
% The function cca_Process is called at the clock frequncy
%

function box_out = matlab_Process(box_in)
    
    % we iterate over the pending chunks on input 1 (SIGNAL)
    for i = 1: OV_getNbPendingInputChunk(box_in,1)
         
         % we pop the first chunk to be processed, note that box_in is used as the output
         % variable to continue processing
         [box_in, start_time, end_time, matrix_data] = OV_popInputBuffer(box_in,1);

        Fs = box_in.inputs{1}.header.sampling_rate; % Sampling frequency
        T = 1/Fs; % Sample time
        L = box_in.inputs{1}.header.nb_samples_per_buffer; % Length of signal
        t = (0:L-1)*T; % Time vector

        N = L; %Number of sampling points
        f1 = 12; %12 Hz
        f2 = 15; %15 Hz
        f = [f1,f2];
        K = [];

        %Create the coefficients for N sampling points
        for j = 1:N
            K(j) = (j/Fs);
        end

        Nh = 2; %Number of harmonics


        %We create the reference_Signals
        Rfi = [];
        iter = 1;

        for k = 1:length(f)
            for u = 1:Nh
                for p = 1:length(K)
                    Rfi(p,iter) = sin(2*pi*f(k)*(u)*K(iter));
                    
                end
                iter = iter +1;
            end
        end


        A_mat = []; % - Sample canonical coefficients for X variables
        B_mat = []; % - Sample canonical coefficients for Y variables
        r = []; % - Sample canonical correlations
        

%         fprintf('Size of X %i and %i\n', size(matrix_data,1), size(matrix_data,2))
%         fprintf('Size of Rfi %i and %i\n', size(Rfi,1), size(Rfi,2))

%         fprintf('Size of K %i and %i\n', size(K,1), size(K,2))


        for v = 1:4 % 4 reference signals
            [A,B,r] = canoncorr(matrix_data', Rfi);
            
            r(v) = max(r);

        end
%         fprintf('Size of r %i and %i\n', size(r,1), size(r,2))
        signal = r;
        box_in.outputs = box_in.inputs;

        box_in = OV_addOutputBuffer(box_in,1,start_time,end_time,signal);
    end
    
    

    %box_in = OV_addOutputBuffer(box_in,1,start_time,end_time,signal);
    % Pass the modified box as output to continue processing
    box_out = box_in;
%     box_out = OV_setStreamedMatrixOutputHeader(box_in, 1, [1 4], {'rf1', 'rf2','rf3','rf4'})

end