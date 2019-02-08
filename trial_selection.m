%1
%Unknown versus known at first exposure
%equals target versus filler at first exposure
%targets of comparison
cfg                 = [];
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)); % First occurence, beginning of word, only targets, that were uknown in pretest and whose fillers were known
    data_tar_uknown_1   = ft_selectdata(cfg, data_clean);

%fillers of same comparison
cfg                 = [];
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); % First occurence, beginning of word, only fillers, that were known in pretest 
    data_fil_known_1   = ft_selectdata(cfg, data_clean);
    
%2   
%Learned versus not learned targets during first exposure
%learned targets of comparison
cfg                 = [];
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) ~= 0)); % First occurence, beginning of word, only targets, that were uknown in pretest and whose fillers were known and were learned during first presentation
    data_tar_learned_1   = ft_selectdata(cfg, data_clean);

%not learned targets of comparison
cfg                 = [];
    cfg.trials          = find((data_clean.trialinfo(:,7) == 11)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); % First occurence, beginning of word, only targets, that were uknown in pretest and whose fillers were known and were not learned during first presentation
    data_tar_not_learned_1   = ft_selectdata(cfg, data_clean);

%3
%Not learned targets during first occurence versus matched known filler words
%not learned targets
cfg                 = [];
    cfg.trials       = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 1)& (data_clean.trialinfo(:,2) == 0)& (data_clean.trialinfo(:,10) == 1)& (data_clean.trialinfo(:,3) == 0)); % Second occurence, beginning of word, only targets, that were uknown in pretest and whose fillers were known 
    data_tar_not_learned_2  = ft_selectdata(cfg, data_clean);
    numbers =  data_tar_learned_1.trialinfo(:,9);
%matched known fillers
cfg                 = [];
    intermediate          = find((data_clean.trialinfo(:,7) == 21)& (data_clean.trialinfo(:,6) == 2)& (data_clean.trialinfo(:,2) ~= 0)); % Second occurence, beginning of word, fillers, that were known in pretest and which were matched to target words
    [x,ind] = ismember(numbers, data_clean.trialinfo(intermediate,9));
    ind = nonzeros(ind);
    newdata             = data_clean.trialinfo(intermediate,:);
    cfg.trials          = intermediate(ind);
    data_fill_matched   = ft_selectdata(cfg, data_clean);
   