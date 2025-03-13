function [shim_vals] = extract_shim_vals(filename)
% function that reads shim information from a siemen's 3T Skyra machine
%STRING -> ARRAY
% file -> array of shim_vals


file_data = fileread(filename);
subsplits = split(file_data,'sGRADSPEC.alShimCurrent'); % find where in the file is the specific name of the shim values

%values to be filled
idx_vals = [];
shim_vals = [];
for its = 1:length(subsplits) 
    if strcmp(subsplits{its}(1), '[')  % find the bracket denoting the starting of the shims
        if length(subsplits{its}) < 70000 && length(subsplits{its}) > 30 % make sure it doesn't grab the wrong portion
            continue
        end
        idx_val = str2num(subsplits{its}(2))+1; % extract which number this shim value is 
        idx_vals = [idx_vals, str2num(subsplits{its}(2))]; % place the shim value
        %extracting the shim is a little more difficult
        l =split(subsplits{its},' 	');
        if length(l) < 30
            shim = str2num(l{2}(1:length(l{2}) - 1));
        else % the last one has a bunch of extra stuff I have to remove
            k = split(l{2}, 'sTX');
            shim = str2num(k{1}(1:length(k{1})-1));
        end
        
        shim_vals(idx_val) = shim;
    end
end










