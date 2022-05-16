% cca_Initialize.m
% --------------------------------

% Author: Ashley Bishop
% Date: 15 May 2022
%
% The function cca_Initialize is called when pressing 'play' in the scenario
%

function box_out = matlab_Initialize(box_in)
%     disp('Matlab intialize function has been called.')
    % we add a field to save the trigger state
    box_in.user_data.trigger_state = false;
    %Don't forget to pass the modified box as output
    box_out = box_in;

end

