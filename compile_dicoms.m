new_dir = ''; %dicom directory. I created a directory for each subject with the files I wanted to extract shims from.
subdirname = 'I';  % whatever your directories start with. My subjects names were IT### so its starting with an 'I'
filestart = '0'; % all of the files I want to check their shim start with a 0 in the front
fs = filesep;

all_subs = dir(new_dir); % get all the subjects in the directory
tick = 0;
shim_cells = {};
for subs = 1:length(all_subs)
    % this is all code that works its way through different directories 
    if strcmp(all_subs(subs).name(1), subdirname)
        sub_dir_name = all_subs(subs).name;
        sub_dir = [new_dir,fs, sub_dir_name];

        all_dirs = dir(sub_dir); % look inside the subjects folders
        for fold = 1:length(all_dirs)
            % all of my files start with the number 0 in front of them. So
            % I am going to search for that to avoid the '.' and '..' file
            if strcmp(all_dirs(fold).name(1), filestart)
                tick = tick +1;
                this_shim = {};
                smaller_folder = dir([sub_dir, fs,all_dirs(fold).name]);
                scan_grabbed = [sub_dir, fs, all_dirs(fold).name,fs, smaller_folder(3).name];
                info = dicominfo(scan_grabbed);
                [shim_vals] = extract_shim_vals(scan_grabbed); % run the function on the relevant scan
                %format the information in a way to build a cell structure
                this_shim{1}= info.StudyDate;
                this_shim{2}=sub_dir_name;
                this_shim{3} = all_dirs(fold).name;
                this_shim{4} = shim_vals(1);
                this_shim{5} = shim_vals(2);
                this_shim{6} = shim_vals(3);
                this_shim{7} = shim_vals(4);
                this_shim{8} = shim_vals(5);
                shim_cells(tick,:) = this_shim; % add it to the final shim_cells
            end
        end



    end
end

% turn the shim values into a table
shim_table = cell2table(shim_cells, 'Variablenames', {'Date','Sub','Scan_type','val1','val2','val3','val4','val5'});

% write the table to a csv
writetable(shim_table, 'shim_vals.csv')