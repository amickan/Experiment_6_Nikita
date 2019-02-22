data_clean = data_all %Use when using data before articfact rejection
%1
%Unknown versus known at first exposure
%equals target versus filler at first exposure
%targets of comparison
cfg                 = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0) and whose fillers were known(col10=1)
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)); 
    data_tar_unknown_1   = ft_selectdata(cfg, data_clean);

%fillers of same comparison
cfg                 = [];
    % First occurence, beginning of word,(col7=11) only fillers(col6=2), that were known in pretest(col2~=0)
    intermediate          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); 
    numbers =  data_tar_unknown_1.trialinfo(:,9);
    [x,ind] = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind = nonzeros(ind);
    newdata             = data_clean.trialinfo(intermediate,:);
    cfg.trials          = intermediate(ind);
    data_fil_known_1  = ft_selectdata(cfg, data_clean);
%%
%2   
%Learned versus not learned targets during first exposure
%learned targets of comparison
cfg                 = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were learned during first presentation (col2~=0)
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) ~= 0)); 
    data_tar_learned_1   = ft_selectdata(cfg, data_clean);

%not learned targets of comparison
cfg                 = [];
    % First occurence, beginning of word(col7=11), only targets(col6=1), that were unknown in pretest(col2=0), whose fillers were known (col10=1) and were not learned during first presentation (col2=0)
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); 
    data_tar_not_learned_1   = ft_selectdata(cfg, data_clean);
    
%%
%3
%Not learned targets during first occurence versus matched known filler words
%not learned targets
cfg                 = [];
    % Second occurence, beginning of word(col7=21), only
    % targets(col6=1),that were unknown in pretest(col2=0), whose
    % fillers were known (col10=1), and that were not learned in the first
    % occurence (col3=0)
    cfg.trials       = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); 
    data_tar_not_learned_2  = ft_selectdata(cfg, data_clean);
    numbers =  data_tar_not_learned_2.trialinfo(:,9);
%matched known fillers
cfg                 = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate          = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0));
    [x,ind] = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind = nonzeros(ind);
    newdata             = data_clean.trialinfo(intermediate,:);
    cfg.trials          = intermediate(ind);
    data_fill_matched_not_learned   = ft_selectdata(cfg, data_clean);
    
%%
%4
%Learned targets during first occurence versus matched known filler words
%Learned targets
cfg                 = [];
    % Second occurence, beginning of word(col7=21), only targets(col6=1),
    % that were unknown in pretest(col2=0), whose fillers were
    % known(col10=1) and that were learned in the first occurence(col3~=0)
    cfg.trials       = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) ~= 0)); 
    data_tar_learned_2  = ft_selectdata(cfg, data_clean);
    numbers =  data_tar_learned_2.trialinfo(:,9);
%matched known fillers
cfg                 = [];
    % Second occurence, beginning of word(col7=21), fillers(col6=2), that were known in pretest(col2~=0) and which were matched to target words
    intermediate          = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); 
    [x,ind] = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind = nonzeros(ind);
    newdata             = data_clean.trialinfo(intermediate,:);
    cfg.trials          = intermediate(ind);
    data_fill_matched_learned   = ft_selectdata(cfg, data_clean);

 %%   
 %Presenting the number of trials we selected
 
    a = length(data_tar_unknown_1.trial);
    b = length(data_fil_known_1.trial);
    c = length(data_tar_learned_1.trial);
    d = length(data_tar_not_learned_1.trial);
    e = length(data_tar_not_learned_2.trial);
    f = length(data_fill_matched_not_learned.trial);
    g = length(data_tar_learned_2.trial);
    h = length(data_fill_matched_learned.trial);

    disp(['Data_tar_unknown_1: ', num2str(a)]);
    disp(['Data_fill_known_1: ', num2str(b)]);   
    disp(['Data_tar_learned_1: ', num2str(c)]);   
    disp(['Data_tar_not_learned_1: ', num2str(d)]);   
    disp(['Data_tar_not_learned_2: ', num2str(e)]);
    disp(['Data_fill_matched_not_learned: ', num2str(f)]);   
    disp(['Data_tar_learned_2: ', num2str(g)]);   
    disp(['Data_fill_matched_learned: ', num2str(h)]);   
    
    