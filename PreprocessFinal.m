%%% EEG analysis script Thesis Nikita %%%
function PreprocessFinal(pNumber) 
    cd('\\cnas.ru.nl\wrkgrp\STD-Julia-Back-Up\') % this is where EEG data is stored
    %cd('C:\Users\tieks\Documents\Thesis\OscillatorySignaturesOfWordLearning');  
    %example number 
    %pNumber = 102;

    % test
    % define files for this participant
    vhdr = strcat('Julia final back up EEG data june 7 2018\P', num2str(pNumber), '.vhdr');
    preprocFile = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_data_all_after_AR');
    all_data_file = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_all_before_AR');
    trial_sel_comp_1_a = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_1_a'); %Unknown versus known at first exposure; unknown target selection
    trial_sel_comp_1_b = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_1_b'); %Unknown versus known at first exposure; known filler selection
    trial_sel_comp_2_a = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_2_a'); %Learned versus not learned targets during first exposure; learned targets
    trial_sel_comp_2_b = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_2_b'); %Learned versus not learned targets during first exposure; not learned targets
    trial_sel_comp_3_a = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_3_a'); %Second occurence, not learned in first occurence versus matched known filler words; not learned targets
    trial_sel_comp_3_b = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_3_b'); %Second occurence, not learned in first occurence versus matched known filler words; matched known fillers
    trial_sel_comp_4_a = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_4_a'); %Second occurence, learned in first occurence versus matched known filler words; learned target words
    trial_sel_comp_4_b = strcat('PROCESSED_DATA_NIKITA\', num2str(pNumber), '_trial_sel_comp_4_b'); %Second occurence, learned in first occurence versus matched known filler words; matched known fillers
    
    
    % defining settings for trial selection
    cfg                     = [];
    cfg.dataset             = vhdr;                                 % raw data file name
    cfg.trialfun            = 'ft_trialfun_general';                % selecting all trials for now
    cfg.trialdef.prestim    = 0.5;                                  % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfg.trialdef.poststim   = 1;                                  % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfg.trialdef.eventvalue = {'S 12', 'S 14', 'S 13', 'S 15'};                     % markers marking stimulus events in the final test
    cfg.trialdef.eventtype  = 'Stimulus';
    
    % Define trials (in cfg.trl)
    cfg                     = ft_definetrial(cfg);                  % fieldtrip function that specifies trials
    
    % rereferencing data
    cfg.reref               = 'yes';                                % data will be rereferenced
    cfg.channel             = setdiff(1:32, [1,12,17,32]);          % in this step only for the EEG channels (including the right mastoid, elec 9)
    cfg.implicitref         = 'Ref';                                % the implicit (non-recorded) reference channel is added to the data representation
    cfg.refchannel          = {'TP10', 'Ref'};                  % the average of these channels is used as the new reference
    % create raw eeg data for possible later inspection
    data_eeg_raw            = ft_preprocessing(cfg); 

    % filtering data
    cfg.lpfilter            = 'yes';                                % data will be lowpass filtered
    cfg.lpfreq              = 40;                                   % lowpass frequency in Hz
    cfg.hpfilter            = 'no';                                 % data will NOT be highpass filtered, as this was already done online

    % baseline correction
    cfg.demean              = 'yes';
    %cfg.baselinewindow      = [-0.2 0];                            % no baseline correction necessary
    

    % apply the set parameters on the data
    data_eeg                = ft_preprocessing(cfg); 
    % only keep the newly created ref channel
    cfg                     = [];
    cfg.channel             = setdiff(1:32, 8);                   % you can use either strings or numbers as selection
    data_eeg                = ft_selectdata(cfg, data_eeg);
    data_eeg_raw            = ft_selectdata(cfg, data_eeg_raw);
    
    %% processing horizontal EOG
    cfgHEOG                     = [];                           % initiate new, empty cfg for the horizontal EOG preprocessing 
    cfgHEOG.dataset             = vhdr;
    cfgHEOG.trialfun            = 'ft_trialfun_general';        % selecting all trials
    cfgHEOG.trialdef.eventvalue = {'S 12', 'S 14', 'S 13', 'S 15'};             % markers marking stimulus events in the final test
    cfgHEOG.trialdef.eventtype  = 'Stimulus';
    cfgHEOG.trialdef.prestim    = 0.5;                          % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfgHEOG.trialdef.poststim   = 1;                          % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfgHEOG.reref               = 'yes';
    cfgHEOG.refchannel          = 'LhorEOG';
    cfgHEOG.channel             = {'LhorEOG', 'RhorEOG'};      % horizontal EOG channels
    cfgHEOG                     = ft_definetrial(cfgHEOG);
    data_HEOG_raw               = ft_preprocessing (cfgHEOG);   % creating raw data for possible later inspection
    cfgHEOG.bpfilter            = 'yes';
    cfgHEOG.bpfilttype          = 'but';
    cfgHEOG.bpfreq              = [1 15];
    cfgHEOG.bpfiltord           = 4;
    cfgHEOG.demean              = 'yes';
    %cfgHEOG.baselinewindow      = [-0.2 0];                     % data will be baseline corrected in a window from -200ms to stimulus onset
    % apply the set parameters on the data
    data_HEOG                   = ft_preprocessing (cfgHEOG);
    data_HEOG.label{1}          = 'EOGH';                      % rename newly created channel
    data_HEOG_raw.label{1}      = 'EOGH';   
    % only keep the newly created channel
    cfgHEOG                     = [];
    cfgHEOG.channel             = 'EOGH';                      % you can use either strings or numbers as selection
    data_HEOG                   = ft_selectdata(cfgHEOG, data_HEOG);
    data_HEOG_raw               = ft_selectdata(cfgHEOG, data_HEOG_raw);
    
    %checking that EOGleft was referenced to itself
    %figure
    %plot(data_HEOG.time{1}, data_HEOG.trial{1}(1,:));
    %hold on
    %plot(data_HEOG.time{1}, data_HEOG.trial{1}(2,:),'g'); 
    %legend({'EOGleft' 'EOGright'}); 

    %% processing vertical EOG
    cfgVEOG                     = [];
    cfgVEOG.dataset             = vhdr;
    cfgVEOG.trialfun            = 'ft_trialfun_general';        % selecting all trials
    cfgVEOG.trialdef.eventvalue = {'S 12', 'S 14', 'S 13', 'S 15'};             % markers marking stimulus events in the final test
    cfgVEOG.trialdef.eventtype  = 'Stimulus';
    cfgVEOG.trialdef.prestim    = 0.5;                          % time before marker in seconds (should be generous to avoid filtering artifacts)
    cfgVEOG.trialdef.poststim   = 1;                          % time after marker in seconds (should be generous to avoid filtering artifacts)
    cfgVEOG.reref               = 'yes';
    cfgVEOG.channel             = {'UpVertEOG', 'LoVertEOG'};
    cfgVEOG.refchannel          = 'UpVertEOG';
    cfgVEOG                     = ft_definetrial(cfgVEOG);
    data_VEOG_raw               = ft_preprocessing (cfgVEOG);
    cfgVEOG.bpfilter            = 'yes';
    cfgVEOG.bpfilttype          = 'but';
    cfgVEOG.bpfreq              = [1 15];
    cfgVEOG.bpfiltord           = 4;
    cfgVEOG.demean              = 'yes';
    %cfgVEOG.baselinewindow      = [-0.2 0];                     % data will be baseline corrected in a window from -200ms to stimulus onset
    % apply the set parameters on the data
    data_VEOG                   = ft_preprocessing (cfgVEOG);
    data_VEOG.label(1)          = {'EOGV'};                     % rename newly created channel
    data_VEOG_raw.label(1)      = {'EOGV'};
    % only keep the newly created channel
    cfgVEOG                     = [];
    cfgVEOG.channel             = 'EOGV';                      % you can use either strings or numbers as selection
    data_VEOG                   = ft_selectdata(cfgVEOG, data_VEOG);
    data_VEOG_raw               = ft_selectdata(cfgVEOG, data_VEOG_raw);
    
    %checking that EOGabove was referenced to itself
    %figure
    %plot(data_VEOG.time{1}, data_VEOG.trial{1}(1,:));
    %hold on
    %plot(data_VEOG.time{1}, data_VEOG.trial{1}(2,:),'g'); 
    %legend({'EOGabove' 'EOGbelow'}); 


    % Combining all the preprocessed data into one dataset
    cfg = [];
    data_all = ft_appenddata(cfg, data_eeg, data_HEOG, data_VEOG);
    data_raw = ft_appenddata(cfg, data_eeg_raw, data_HEOG_raw, data_VEOG_raw);
    
    % Add behavioral information matrix to the trialinfo matrix for later
    % Only works when the log file and data are of same length
    behavFilename = strcat('Logfiles_For_Fieldtrip\', num2str(pNumber), '_logfile.txt');
    behav = load(behavFilename);
    data_all.trialinfo = [data_all.trialinfo behav];
    
    save(all_data_file, 'data_all');
    % load(all_data_file);  % if you want to start from here
    % subset to only useful trials 
    cfg.trials     = find((data_all.trialinfo(:,11) == 1));
    indeces = find((data_all.trialinfo(:,11) == 1));
    data_all  = ft_selectdata(cfg, data_all);

    %% ICA
    %Independent component analysis    
    %Decomposition of EEG data
    % perform the independent component analysis (i.e., decompose the data)
    cfg        = [];
    cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB

    comp = ft_componentanalysis(cfg, data_all);
    
    %Identify components reflecting eye artifacts
    % plot the components for visual inspection
    figure
    cfg = [];
    cfg.component = 1:20;       % specify the component(s) that should be plotted
    cfg.layout    = 'acticap-64ch-standard2_XZ.mat'; % specify the layout file that should be used for plotting
    cfg.comment   = 'no';
    ft_topoplotIC(cfg, comp)
    
    %Further inspection of time course of component
    cfg = [];
    cfg.layout = 'acticap-64ch-standard2_XZ.mat'; % specify the layout file that should be used for plotting
    cfg.viewmode = 'component';
    ft_databrowser(cfg, comp);
    %Display normal data to compare
    cfg = [];
    cfg.layout = 'acticap-64ch-standard2_XZ.mat'; % specify the layout file that should be used for plotting
    cfg.viewmode                = 'vertical';
    ft_databrowser(cfg, data_all);
    
    %Pause until enter is pressed to allow for checking data
    currkey=0;
    % do not move on until enter key is pressed
    while currkey~=1
        pause; % wait for a keypress
        currkey=get(gcf,'CurrentKey'); 
        if strcmp(currkey, 'return') == 1 % You also want to use strcmp here.
            currkey=1 % Error was here; the "==" should be "="
        else
            currkey=0 % Error was here; the "==" should be "="
        end
    end
    %Ask which components have to be removed
    prompt = 'Enter bad components, separate with a comma, inbetween square brackets: ';
    bad_components = inputdlg(prompt);
    
    %Removing bad artifacts and backprojecting data
    cfg = [];
    cfg.component = str2num(bad_components{1}); % to be removed component(s)
    data_all = ft_rejectcomponent(cfg, comp, data_all);
    
    %% Artifact rejection 
    % automatic artifact rejection
    % Threshold artifact detection: trials with amplitudes above or below
    % +-100m or with a difference between min and max of more than 150mV
    cfg                                     = [];
    cfg.continuous                          = 'no';
    cfg.artfctdef.threshold.channel         = 'EEG'; 
    cfg.artfctdef.threshold.lpfilter        = 'no';
    cfg.artfctdef.threshold.hpfilter        = 'no';
    cfg.artfctdef.threshold.bpfilter        = 'no';
    cfg.artfctdef.threshold.demean          = 'no';
    cfg.artfctdef.threshold.reref           = 'no';
    cfg.artfctdef.threshold.range           = 150;
    cfg.artfctdef.threshold.min             = -100; 
    cfg.artfctdef.threshold.max             = 100;
    cfg.trl                                 =  data_all.cfg.previous{1,1}.previous.previous.previous{1,1}.previous.trl(indeces,:);%data_all.cfg.previous.previous{1,1}.previous.trl(indeces,:);
    [cfg, artifact_threshold]               = ft_artifact_threshold(cfg, data_all);

    % Eye-blinks
    cfg.artfctdef.zvalue.channel               = [29,30];  % only HEOG and VEOG
    cfg.artfctdef.zvalue.bpfilter              = 'yes';
    cfg.artfctdef.zvalue.bpfilttype            = 'but';
    cfg.artfctdef.zvalue.bpfreq                = [1 15];
    cfg.artfctdef.zvalue.bpfiltord             = 4;
    cfg.artfctdef.zvalue.hilbert               = 'yes';
    cfg.artfctdef.zvalue.cutoff                = 4;      
    cfg.artfctdef.zvalue.artpadding            = 0.1;       
    [cfg, artifact_eog]                        = ft_artifact_zvalue(cfg, data_all);

    % manual artifact rejection by visual inspection of each trial
    cfg.viewmode                = 'vertical';
    cfg.selectmode              = 'markartifact';
    cfg.eegscale                = 1;
    cfg.eogscale                = 1.5;
    cfg.layout                  = 'acticap-64ch-standard2_XZ.mat';
    cfg                         = ft_databrowser(cfg, data_all);                       % double click on segments to mark them as artefacts, then at the end exist the box by clicking 'q' or the X
    
    % double checking on raw data for dubious eye-artifacts?
    button                      = questdlg('Do you wish to inspect raw data?');
    % if 'Yes' was clicked, the raw data is loaded for the pp in the
    % databrowser
    if (strcmp(button,'Yes') == 1)
       cfg                      = ft_databrowser(cfg, data_raw); 
    else
    end
    
    % once all rejections have been made
    cfg.artfctdef.reject        = 'complete';                                          % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
    cfg.artfctdef.crittoilim    = [0 1];                                            % rejects trial only when artifact is within a certain time window of itnerest
    data_clean                  = ft_rejectartifact(cfg, data_all); 

    
    % OR PURELY VISUAL 
    % Left click on a channel name to mark it as bad, right click on a
    % channel name to reverse the marking, at the end press 'quit' NOT the 'X'
    %cfg = [];
    %cfg.alim = 15;
    cfg.eegscale = 1;
    cfg.eogscale = 1.5;
    cfg.keepchannel = 'nan';
    cfg.method = 'trial';
    cfg.plotlayout = '1col';
    data_clean = ft_rejectvisual(cfg, data_clean);
    save(preprocFile, 'data_clean');
    % load(preprocFile)  % if you want to start from here
    
    %% Cut data in 8 comparison conditions and save datasets seperately 
    %Comparison 1
    %Unknown versus known at first exposure
    %equals target versus filler at first exposure
    %Targets of comparison
    cfg                             = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0) and whose fillers were known(col10=1)
    cfg.trials                      = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)); 
    data_tar_unknown_1              = ft_selectdata(cfg, data_clean);

    %Fillers of same comparison
    cfg                             = [];
    % First occurence, beginning of word,(col7=11) only fillers(col6=2), that were known in pretest(col2~=0)
    intermediate                    = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); 
    numbers                         =  data_tar_unknown_1.trialinfo(:,9);
    [x,ind]                         = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind                             = nonzeros(ind);
    newdata                         = data_clean.trialinfo(intermediate,:);
    cfg.trials                      = intermediate(ind);
    data_fil_known_1                = ft_selectdata(cfg, data_clean);
    
    %Comparison 2   
    %Learned versus not learned targets during first exposure
    %Learned targets of comparison
    cfg                             = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were learned during first presentation (col2~=0)
    cfg.trials                      = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) ~= 0)); 
    data_tar_learned_1              = ft_selectdata(cfg, data_clean);

    %Not learned targets of comparison
    cfg                             = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were not learned during first presentation (col2=0)
    cfg.trials                      = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); 
    data_tar_not_learned_1          = ft_selectdata(cfg, data_clean);

    %Comparison 3
    %Not learned targets during first occurence versus matched known filler words
    %Not learned targets
    cfg                             = [];
    % Second occurence, beginning of word(col7=21), only
    % targets(col6=1),that were unknown in pretest(col2=0), whose
    % fillers were known (col10=1), and that were not learned in the first
    % occurence (col3=0)
    cfg.trials                      = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); 
    data_tar_not_learned_2          = ft_selectdata(cfg, data_clean);
    numbers                         =  data_tar_not_learned_2.trialinfo(:,9);
    %Matched known fillers
    cfg                             = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate                    = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0));
    [x,ind]                         = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind                             = nonzeros(ind);
    newdata                         = data_clean.trialinfo(intermediate,:);
    cfg.trials                      = intermediate(ind);
    data_fill_matched_not_learned   = ft_selectdata(cfg, data_clean);

    %Comparison 4
    %Learned targets during first occurence versus matched known filler words
    %Learned targets
    cfg                         = [];
    % Second occurence, beginning of word(col7=21), only targets(col6=1),
    % that were unknown in pretest(col2=0), whose fillers were
    % known(col10=1) and that were learned in the first occurence(col3~=0)
    cfg.trials                  = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) ~= 0)); 
    data_tar_learned_2          = ft_selectdata(cfg, data_clean);
    numbers                     =  data_tar_learned_2.trialinfo(:,9);
    %Matched known fillers
    cfg                         = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate                = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); 
    [x,ind]                     = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind                         = nonzeros(ind);
    newdata                     = data_clean.trialinfo(intermediate,:);
    cfg.trials                  = intermediate(ind);
    data_fill_matched_learned   = ft_selectdata(cfg, data_clean);
 
    %Save the seperate datasets
    save(trial_sel_comp_1_a, 'data_tar_unknown_1');
    save(trial_sel_comp_1_b, 'data_fil_known_1');
    save(trial_sel_comp_2_a, 'data_tar_learned_1');
    save(trial_sel_comp_2_b, 'data_tar_not_learned_1');
    save(trial_sel_comp_3_a, 'data_tar_not_learned_2');
    save(trial_sel_comp_3_b, 'data_fill_matched_not_learned');
    save(trial_sel_comp_4_a, 'data_tar_learned_2');
    save(trial_sel_comp_4_b, 'data_fill_matched_learned');
        
    %Document how many trials were kept for later analysis
    a = length(data_tar_unknown_1.trial);
    b = length(data_fil_known_1.trial);
    c = length(data_tar_learned_1.trial);
    d = length(data_tar_not_learned_1.trial);
    e = length(data_tar_not_learned_2.trial);
    f = length(data_fill_matched_not_learned.trial);
    g = length(data_tar_learned_2.trial);
    h = length(data_fill_matched_learned.trial);

    % save trial information in txt
    cd('\\cnas.ru.nl\wrkgrp\STD-Julia-Back-Up\') 
    fid = fopen('PROCESSED_DATA_NIKITA\TrialCount_PostPreprocessing.txt','a');
    formatSpec = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n';
    fprintf(fid,formatSpec,pNumber,a,b,c,d,e,f,g,h);

    %Trial selection again but then for before artifact rejection
    %Comparison 1
    %Unknown versus known at first exposure
    %equals target versus filler at first exposure
    %Targets of comparison
    cfg                 = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0) and whose fillers were known(col10=1)
    cfg.trials          = find((data_all.trialinfo(:,7) == 11)& (data_all.trialinfo(:,6) == 1)& (data_all.trialinfo(:,2) == 0)& (data_all.trialinfo(:,10) == 1)); 
    data_tar_unknown_1  = ft_selectdata(cfg, data_all);

    %Fillers of same comparison
    cfg                 = [];
    % First occurence, beginning of word,(col7=11) only fillers(col6=2), that were known in pretest(col2~=0)
    intermediate        = find((data_all.trialinfo(:,7) == 11)& (data_all.trialinfo(:,6) == 2)& (data_all.trialinfo(:,2) ~= 0)); 
    numbers             =  data_tar_unknown_1.trialinfo(:,9);
    [x,ind]             = ismember(numbers, data_all.trialinfo(intermediate,9));
    ind                 = nonzeros(ind);
    newdata             = data_all.trialinfo(intermediate,:);
    cfg.trials          = intermediate(ind);
    data_fil_known_1    = ft_selectdata(cfg, data_all);
    
    %Comparison 2   
    %Learned versus not learned targets during first exposure
    %Learned targets of comparison
    cfg                     = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were learned during first presentation (col2~=0)
    cfg.trials              = find((data_all.trialinfo(:,7) == 11)& (data_all.trialinfo(:,6) == 1)& (data_all.trialinfo(:,2) == 0)& (data_all.trialinfo(:,10) == 1)& (data_all.trialinfo(:,3) ~= 0)); 
    data_tar_learned_1      = ft_selectdata(cfg, data_all);

    %Not learned targets of comparison
    cfg                     = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were not learned during first presentation (col2=0)
    cfg.trials              = find((data_all.trialinfo(:,7) == 11)& (data_all.trialinfo(:,6) == 1)& (data_all.trialinfo(:,2) == 0)& (data_all.trialinfo(:,10) == 1)& (data_all.trialinfo(:,3) == 0)); 
    data_tar_not_learned_1  = ft_selectdata(cfg, data_all);

    %Comparison 3
    %Not learned targets during first occurence versus matched known filler words
    %Not learned targets
    cfg                             = [];
    % Second occurence, beginning of word(col7=21), only
    % targets(col6=1),that were unknown in pretest(col2=0), whose
    % fillers were known (col10=1), and that were not learned in the first
    % occurence (col3=0)
    cfg.trials                      = find((data_all.trialinfo(:,7) == 21)& (data_all.trialinfo(:,6) == 1)& (data_all.trialinfo(:,2) == 0)& (data_all.trialinfo(:,10) == 1)& (data_all.trialinfo(:,3) == 0)); 
    data_tar_not_learned_2          = ft_selectdata(cfg, data_all);
    numbers                         =  data_tar_not_learned_2.trialinfo(:,9);
    %Matched known fillers
    cfg                             = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate                    = find((data_all.trialinfo(:,7) == 21)& (data_all.trialinfo(:,6) == 2)& (data_all.trialinfo(:,2) ~= 0));
    [x,ind]                         = ismember(numbers, data_all.trialinfo(intermediate,9));
    ind                             = nonzeros(ind);
    newdata                         = data_all.trialinfo(intermediate,:);
    cfg.trials                      = intermediate(ind);
    data_fill_matched_not_learned   = ft_selectdata(cfg, data_all);

    %Comparison 4
    %Learned targets during first occurence versus matched known filler words
    %Learned targets
    cfg                         = [];
    % Second occurence, beginning of word(col7=21), only targets(col6=1),
    % that were unknown in pretest(col2=0), whose fillers were
    % known(col10=1) and that were learned in the first occurence(col3~=0)
    cfg.trials                  = find((data_all.trialinfo(:,7) == 21)& (data_all.trialinfo(:,6) == 1)& (data_all.trialinfo(:,2) == 0)& (data_all.trialinfo(:,10) == 1)& (data_all.trialinfo(:,3) ~= 0)); 
    data_tar_learned_2          = ft_selectdata(cfg, data_all);
    numbers                     =  data_tar_learned_2.trialinfo(:,9);
    %Matched known fillers
    cfg                         = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate                = find((data_all.trialinfo(:,7) == 21)& (data_all.trialinfo(:,6) == 2)& (data_all.trialinfo(:,2) ~= 0)); 
    [x,ind]                     = ismember(numbers, data_all.trialinfo(intermediate,9));
    ind                         = nonzeros(ind);
    newdata                     = data_all.trialinfo(intermediate,:);
    cfg.trials                  = intermediate(ind);
    data_fill_matched_learned   = ft_selectdata(cfg, data_all);
        
    %Document how many trials were kept for later analysis
    a1 = length(data_tar_unknown_1.trial);
    b1 = length(data_fil_known_1.trial);
    c1 = length(data_tar_learned_1.trial);
    d1 = length(data_tar_not_learned_1.trial);
    e1 = length(data_tar_not_learned_2.trial);
    f1 = length(data_fill_matched_not_learned.trial);
    g1 = length(data_tar_learned_2.trial);
    h1 = length(data_fill_matched_learned.trial);

    % save trial information in txt
    cd('\\cnas.ru.nl\wrkgrp\STD-Julia-Back-Up\') 
    fid = fopen('PROCESSED_DATA_NIKITA\TrialCount_BeforeArtRej.txt','a');
    formatSpec = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n';
    fprintf(fid,formatSpec,pNumber,a1,b1,c1,d1,e1,f1,g1,h1);
    
    
    disp('##############################################');
    disp(['## Done preprocessing PP_', num2str(pNumber),' ################']);
    disp(['## Trials for trial_sel_comp_1_a: ', num2str(a), ' #####']);
    disp(['## Trials for trial_sel_comp_1_b: ', num2str(b),' ##']);
    disp(['## Trials for trial_sel_comp_2_a: ', num2str(c), ' #####']);
    disp(['## Trials for trial_sel_comp_2_b: ', num2str(d),' ##']);   
    disp(['## Trials for trial_sel_comp_3_a: ', num2str(e), ' #####']);
    disp(['## Trials for trial_sel_comp_3_b: ', num2str(f),' ##']);
    disp(['## Trials for trial_sel_comp_4_a: ', num2str(g), ' #####']);
    disp(['## Trials for trial_sel_comp_4_b: ', num2str(h),' ##']);   
    disp('##############################################');
    
    % change this to your Github folder directory, to be able to run the
    % script again from the start
    cd('C:\Users\tieks\Documents\Thesis\OscillatorySignaturesOfWordLearning');  