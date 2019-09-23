%% Loading all preprocessed data 

subjects = [101,102,103,108,109, 111, 114, 116, 119, 120,121, 126,133, 134]; % subjects that should be included in grand average
cd('\\cnas.ru.nl\wrkgrp\STD-Julia-Back-Up\'); % directory with all preprocessed files 

cfg = [];
cfg.keeptrials='no';
cfg.baseline = [-0.2 0];

Condition1 = cell(1,length(subjects));
for i = 1:length(subjects)
    % condition 1 for each participant
    filename1 = strcat('PROCESSED_DATA_NIKITA\',  num2str(subjects(i)), '_trial_sel_comp_1_a');
    dummy = load(filename1);
    Condition1{i} = ft_timelockanalysis(cfg, dummy.data_tar_unknown_1);
    Condition1{i} = ft_timelockbaseline(cfg, Condition1{i});
    clear dummy filename1
    disp(subjects(i));
end
%save('\\cnas.ru.nl\wrkgrp\STD-Back-Up-Exp2-EEG\Condition1', 'Condition1', '-v7.3')
% grand-average over subjects per condition 
cfg = [];
cfg.keepindividuals='no';
cond1 = ft_timelockgrandaverage(cfg, Condition1{:});
clear Condition1

% load data Condition 2
cfg = [];
cfg.keeptrials='no';
cfg.baseline = [-0.2 0];
Condition2 = cell(1,length(subjects));
for i = 1:length(subjects)
    % condition 2 for each participant
    filename2 = strcat('PROCESSED_DATA_NIKITA\',num2str(subjects(i)), '_trial_sel_comp_1_b'); %Learned versus not learned targets during first exposure; learned targets
    dummy2 = load(filename2);
    Condition2{i} = ft_timelockanalysis(cfg, dummy2.data_fil_known_1);
    Condition2{i} = ft_timelockbaseline(cfg, Condition2{i});
    clear dummy2 filename2
    disp(subjects(i));
end
% grand-average over subjects per condition 
cfg = [];
cfg.keepindividuals='no';
cond2 = ft_timelockgrandaverage(cfg, Condition2{:});
clear Condition2

% plotting average
cfg = [];
cfg.layout = 'actiCAP_64ch_Standard2.mat';
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
cfg.showlabels = 'yes'; 
cfg.fontsize = 6; 
%cfg.ylim = [-3e-13 3e-13];
ft_multiplotER(cfg, cond1, cond2);

% manual plot with some electrodes
fig = figure;

subplot(4,3,1);
plot ((cond1.time)*1000, cond1.avg(27,:), 'k', (cond1.time)*1000, cond2.avg(27,:), 'r','Linewidth', 1);
title('F3');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');
 
subplot(4,3,2);
plot ((cond1.time)*1000, cond1.avg(24,:), 'k', (cond1.time)*1000, cond2.avg(24,:), 'r','Linewidth', 1);
title('Fz');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');
 
subplot(4,3,3);
plot ((cond1.time)*1000, cond1.avg(1,:), 'k', (cond1.time)*1000, cond2.avg(1,:), 'r','Linewidth', 1);
title('F4');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');
 
subplot(4,3,4); 
plot ((cond1.time)*1000, cond1.avg(20,:), 'k', (cond1.time)*1000, cond2.avg(20,:), 'r', 'Linewidth', 1);
title('C3');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');
 
subplot(4,3,5);
plot ((cond1.time)*1000, cond1.avg(11,:),'k', (cond1.time)*1000, cond2.avg(11,:), 'r', 'Linewidth', 1);
title('Cz');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');
 
subplot(4,3,6);
plot ((cond1.time)*1000, cond1.avg(4,:),'k', (cond1.time)*1000, cond2.avg(4,:), 'r', 'Linewidth', 1);
title('C4');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');


subplot(4,3,7);
plot ((cond1.time)*1000, cond1.avg(16,:),'k', (cond1.time)*1000, cond2.avg(16,:), 'r', 'Linewidth', 1);
title('P3');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

subplot(4,3,8);
plot ((cond1.time)*1000, cond1.avg(12,:),'k', (cond1.time)*1000, cond2.avg(12,:), 'r', 'Linewidth', 1);
title('Pz');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

subplot(4,3,9);
plot ((cond1.time)*1000, cond1.avg(10,:),'k', (cond1.time)*1000, cond2.avg(10,:), 'r', 'Linewidth', 1);
title('P4');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

subplot(4,3,10);
plot ((cond1.time)*1000, cond1.avg(14,:),'k', (cond1.time)*1000, cond2.avg(14,:), 'r', 'Linewidth', 1);
title('O1');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

subplot(4,3,11);
plot ((cond1.time)*1000, cond1.avg(13,:),'k', (cond1.time)*1000, cond2.avg(13,:), 'r', 'Linewidth', 1);
title('Oz');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

subplot(4,3,12);
plot ((cond1.time)*1000, cond1.avg(9,:),'k', (cond1.time)*1000, cond2.avg(9,:), 'r', 'Linewidth', 1);
title('O2');
line('XData', [-200 1000], 'YData', [0 0], 'LineWidth', 1);
line('XData', [0 0], 'YData', [-8 8], 'LineWidth', 0.5);
ylim([-8 8]);
xlim([-200 1000]);
set(gca,'YDir','reverse');

h = get(gca,'Children');
v = [h(1) h(3)];