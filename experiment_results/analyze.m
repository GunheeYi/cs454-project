% algorithm = "NSGA2";
algorithm = "SPEA2";

original = [7000, 0.14, 44, 1, 3000, 1550,  0.325];
lb = [6000, 0.1, 30, 0.8, 2500, 1250, 0.3];
ub = [8000, 0.18, 60, 1.2, 3500, 1850, 0.35];
width = ub-lb;

num_params = 7;
num_objs = 3;

filenames_NSGA = "./NSGA2/" + ...
[
    "NSGA2_1_VAR_A_30_56_0.054.txt", "NSGA2_1_FUN_A_30_56_0.054.txt";
    "NSGA2_2_VAR_A_30_56_0.054.txt", "NSGA2_2_FUN_A_30_56_0.054.txt";
    "NSGA2_3_VAR_A_30_56_0.054.txt", "NSGA2_3_FUN_A_30_56_0.054.txt";
    "NSGA2_4_VAR_A_30_56_0.054.txt", "NSGA2_4_FUN_A_30_56_0.054.txt";
    "NSGA2_5_VAR_A_30_56_0.054.txt", "NSGA2_5_FUN_A_30_56_0.054.txt";
    "NSGA2_6_VAR_A_30_56_0.054.txt", "NSGA2_6_FUN_A_30_56_0.054.txt";
    "NSGA2_7_VAR_A_30_56_0.054.txt", "NSGA2_7_FUN_A_30_56_0.054.txt";
 ];
filenames_RS = "./RS/" + ...
[
    "RS_1_VAR_A_1680_0.054.txt", "RS_1_FUN_A_1680_0.054.txt";
    "RS_2_VAR_A_1680_0.054.txt", "RS_2_FUN_A_1680_0.054.txt";
    "RS_3_VAR_A_1680_0.054.txt", "RS_3_FUN_A_1680_0.054.txt";
    "RS_4_VAR_A_1680_0.054.txt", "RS_4_FUN_A_1680_0.054.txt";
    "RS_5_VAR_A_1680_0.054.txt", "RS_5_FUN_A_1680_0.054.txt";
    "RS_6_VAR_A_1680_0.054.txt", "RS_6_FUN_A_1680_0.054.txt";
    "RS_7_VAR_A_1680_0.054.txt", "RS_7_FUN_A_1680_0.054.txt";
 ];
filenames_SPEA = "./SPEA2/" + ...
[
    "SPEA2_1_VAR_A_30_56_0.054.txt", "SPEA2_1_FUN_A_30_56_0.054.txt";
    "SPEA2_2_VAR_A_30_56_0.054.txt", "SPEA2_2_FUN_A_30_56_0.054.txt";
    "SPEA2_3_VAR_A_30_56_0.054.txt", "SPEA2_3_FUN_A_30_56_0.054.txt";
    "SPEA2_4_VAR_A_30_56_0.054.txt", "SPEA2_4_FUN_A_30_56_0.054.txt";
    "SPEA2_5_VAR_A_30_56_0.054.txt", "SPEA2_5_FUN_A_30_56_0.054.txt";
    "SPEA2_6_VAR_A_30_56_0.054.txt", "SPEA2_6_FUN_A_30_56_0.054.txt";
    "SPEA2_7_VAR_A_30_56_0.054.txt", "SPEA2_7_FUN_A_30_56_0.054.txt";
];

runs_NSGA = size(filenames_NSGA, 1);
runs_RS = size(filenames_RS, 1);
runs_SPEA = size(filenames_SPEA, 1);

% (run count, var/fun, pareto front entry num, var/fun entry num)
NSGA = cell(size(runs_NSGA, 2));
RS = cell(size(runs_RS, 2));
SPEA = cell(size(runs_SPEA, 2));

for i=1:runs_NSGA
    objectives = importdata(filenames_NSGA(i, 2), ' ');
    params= importdata(filenames_NSGA(i, 1), ' ');
    filterCond=objectives(:,2)<0;
    NSGA(i, 1) = {params(filterCond,:)};
    NSGA(i, 2) = {objectives(filterCond,:)};
end
for i=1:runs_SPEA
    objectives = importdata(filenames_SPEA(i, 2), ' ');
    params= importdata(filenames_SPEA(i, 1), ' ');
    filterCond=objectives(:,2)<0;
    SPEA(i, 1) = {params(filterCond,:)};
    SPEA(i, 2) = {objectives(filterCond,:)};
end
for i=1:runs_RS
    objectives = importdata(filenames_RS(i, 2), ' ');
    params= importdata(filenames_RS(i, 1), ' ');
    filterCond=objectives(:,2)<0;
    RS(i, 1) = {params(filterCond,:)};
    RS(i, 2) = {objectives(filterCond,:)};
end

params = [];
totalFronts = [];
objs = [];

for run=1:runs_RS
    totalFronts = [totalFronts; RS{run, 2}];
end

if algorithm=="SPEA2"
    solsByRun = zeros(runs_SPEA, num_params);
elseif algorithm=="NSGA2"
    solsByRun = zeros(runs_NSGA, num_params);
end

for run=1:runs_SPEA
    if algorithm=="SPEA2"
        params = [params; SPEA{run, 1}];
        objs = [objs; SPEA{run, 2}];
        pfs = size(SPEA{run, 2}, 1);
        for pf=1:pfs
            solsByRun(run, SPEA{run, 2}(pf, 3)) = solsByRun(run, SPEA{run, 2}(pf, 3)) + 1;
        end
    end
    totalFronts = [totalFronts; SPEA{run, 2}];
end

for run=1:runs_NSGA
    if algorithm=="NSGA2"
        params = [params; NSGA{run, 1}];
        objs = [objs; NSGA{run, 2}];
        pfs = size(NSGA{run, 2}, 1);
        for pf=1:pfs
            solsByRun(run, NSGA{run, 2}(pf, 3)) = solsByRun(run, NSGA{run, 2}(pf, 3)) + 1;
        end
    end
    totalFronts = [totalFronts; NSGA{run, 2}];
end
num_sols_by_count = sum(solsByRun);
num_sols = sum(num_sols_by_count);

% Compute IGDs, p-value and A_hat_12

IGD_RS = zeros(1, runs_RS);
IGD_NSGA = zeros(1, runs_NSGA);
IGD_SPEA = zeros(1, runs_SPEA);

[referenceFronts, ~] = paretoFront(totalFronts);
for run=1:runs_RS
    IGD_RS(run) = IGD(RS{run, 2}, referenceFronts);
end
for run=1:runs_NSGA
    IGD_NSGA(run) = IGD(NSGA{run, 2}, referenceFronts);
end
for run=1:runs_SPEA
    IGD_SPEA(run) = IGD(SPEA{run, 2}, referenceFronts);
end

p_value_RS_NSGA = ranksum(IGD_RS, IGD_NSGA);
p_value_RS_SPEA = ranksum(IGD_RS, IGD_SPEA);
p_value_NSGA_SPEA = ranksum(IGD_NSGA, IGD_SPEA);
a12_RS_NSGA = a12(IGD_RS', IGD_NSGA');
a12_RS_SPEA = a12(IGD_RS', IGD_SPEA');
a12_NSGA_SPEA = a12(IGD_NSGA', IGD_SPEA');

% normalize total sols per run to 30
if algorithm=="NSGA2"
    for run=1:runs_NSGA
        pfs = size(NSGA{run, 2}, 1);
        solsByRun(run, :) = solsByRun(run, :) ./ pfs * 30;
    end
elseif algorithm=="SPEA2"
    for run=1:runs_SPEA
        pfs = size(SPEA{run, 2}, 1);
        solsByRun(run, :) = solsByRun(run, :) ./ pfs * 30;
    end
end


boxplot(solsByRun);
bx = findobj('Tag','boxplot');
set(bx.Children,'LineWidth',2);
set(gca,'FontSize',12);
set(gca,'LineWidth',2);
xlabel("# changed parameters (j)");
ylabel("# sols with j changed parameters in PF_c_o_l_l")

occurs = zeros(num_params);
changes = zeros(num_params);
for sol=1:num_sols
    count = objs(sol, 3); % changed parameters count
    for param=1:num_params
        change = abs(params(sol, param)-original(param));
        if width(param) >= 1000
            beta = 0.005;
        elseif width(param) >= 100
            beta = 0.01;
        elseif width(param) >= 1
            beta = 0.02;
        else
            beta = 0.04;
        end
        if change >= beta * width(param)
            occurs(param, count) = occurs(param, count) + 1;
            changes(param, count) = changes(param, count) + change;
        end
    end
end

occurs100 = occurs * 100 ./ num_sols_by_count;
occurs100 = round(occurs100);
occursAny = sum(occurs, 2);
occursAny100 = occursAny * 100 / num_sols;
occursAny100 = round(occursAny100);

[~, p] = sort(occursAny100, 'descend');
occursAnyRank = (1:num_params)';
occursAnyRank(p) = occursAnyRank;

changesAny = sum(changes, 2);

changes = changes ./ occurs;
changes(occurs==0) = 0;
changes100 = (changes' * 100 ./ original)';
changesAny = changesAny ./ occursAny;
changesAny(occursAny==0) = 0;
changesAny100 = changesAny * 100 ./ original';

changes = round(changes, 2);
changesAny = round(changesAny, 2);
changes100 = round(changes100);
changesAny100 = round(changesAny100);


table2 = [occurs100 occursAny100 occursAnyRank];

table3 = [];
for i=1:num_params
    table3 = [table3 changes100(:, i)];
    table3 = [table3 changes(:, i)];
end
table3 = [table3 changesAny100 changesAny];










