rng(2021);
warning('off');
REPS = 100;
%% regularized matrix regression
[RMR_20_20_1_L, RMR_20_20_2_L, RMR_20_20_3_L, RMR_20_20_4_L] = deal(zeros(REPS, 5));
[RMR_20_50_1_L, RMR_20_50_2_L, RMR_20_50_3_L, RMR_20_50_4_L] = deal(zeros(REPS, 5));
[RMR_50_50_1_L, RMR_50_50_2_L, RMR_50_50_3_L, RMR_50_50_4_L] = deal(zeros(REPS, 5));

[RMR_20_20_1_P, RMR_20_20_2_P, RMR_20_20_3_P, RMR_20_20_4_P] = deal(zeros(REPS, 3));
[RMR_20_50_1_P, RMR_20_50_2_P, RMR_20_50_3_P, RMR_20_50_4_P] = deal(zeros(REPS, 3));
[RMR_50_50_1_P, RMR_50_50_2_P, RMR_50_50_3_P, RMR_50_50_4_P] = deal(zeros(REPS, 3));

[RMR_20_20_1_O, RMR_20_20_2_O, RMR_20_20_3_O, RMR_20_20_4_O] = deal(zeros(REPS, 2));
[RMR_20_50_1_O, RMR_20_50_2_O, RMR_20_50_3_O, RMR_20_50_4_O] = deal(zeros(REPS, 2));
[RMR_50_50_1_O, RMR_50_50_2_O, RMR_50_50_3_O, RMR_50_50_4_O] = deal(zeros(REPS, 2));

%% tucker regression
[TUCKER_20_20_1_L, TUCKER_20_20_2_L, TUCKER_20_20_3_L, TUCKER_20_20_4_L] = deal(zeros(REPS, 5));
[TUCKER_20_50_1_L, TUCKER_20_50_2_L, TUCKER_20_50_3_L, TUCKER_20_50_4_L] = deal(zeros(REPS, 5));
[TUCKER_50_50_1_L, TUCKER_50_50_2_L, TUCKER_50_50_3_L, TUCKER_50_50_4_L] = deal(zeros(REPS, 5));

[TUCKER_20_20_1_P, TUCKER_20_20_2_P, TUCKER_20_20_3_P, TUCKER_20_20_4_P] = deal(zeros(REPS, 3));
[TUCKER_20_50_1_P, TUCKER_20_50_2_P, TUCKER_20_50_3_P, TUCKER_20_50_4_P] = deal(zeros(REPS, 3));
[TUCKER_50_50_1_P, TUCKER_50_50_2_P, TUCKER_50_50_3_P, TUCKER_50_50_4_P] = deal(zeros(REPS, 3));

[TUCKER_20_20_1_O, TUCKER_20_20_2_O, TUCKER_20_20_3_O, TUCKER_20_20_4_O] = deal(zeros(REPS, 2));
[TUCKER_20_50_1_O, TUCKER_20_50_2_O, TUCKER_20_50_3_O, TUCKER_20_50_4_O] = deal(zeros(REPS, 2));
[TUCKER_50_50_1_O, TUCKER_50_50_2_O, TUCKER_50_50_3_O, TUCKER_50_50_4_O] = deal(zeros(REPS, 2));

%% kruskal regression
[KRUSKAL_20_20_1_L, KRUSKAL_20_20_2_L, KRUSKAL_20_20_3_L, KRUSKAL_20_20_4_L] = deal(zeros(REPS, 5));
[KRUSKAL_20_50_1_L, KRUSKAL_20_50_2_L, KRUSKAL_20_50_3_L, KRUSKAL_20_50_4_L] = deal(zeros(REPS, 5));
[KRUSKAL_50_50_1_L, KRUSKAL_50_50_2_L, KRUSKAL_50_50_3_L, KRUSKAL_50_50_4_L] = deal(zeros(REPS, 5));

[KRUSKAL_20_20_1_P, KRUSKAL_20_20_2_P, KRUSKAL_20_20_3_P, KRUSKAL_20_20_4_P] = deal(zeros(REPS, 3));
[KRUSKAL_20_50_1_P, KRUSKAL_20_50_2_P, KRUSKAL_20_50_3_P, KRUSKAL_20_50_4_P] = deal(zeros(REPS, 3));
[KRUSKAL_50_50_1_P, KRUSKAL_50_50_2_P, KRUSKAL_50_50_3_P, KRUSKAL_50_50_4_P] = deal(zeros(REPS, 3));

[KRUSKAL_20_20_1_O, KRUSKAL_20_20_2_O, KRUSKAL_20_20_3_O, KRUSKAL_20_20_4_O] = deal(zeros(REPS, 2));
[KRUSKAL_20_50_1_O, KRUSKAL_20_50_2_O, KRUSKAL_20_50_3_O, KRUSKAL_20_50_4_O] = deal(zeros(REPS, 2));
[KRUSKAL_50_50_1_O, KRUSKAL_50_50_2_O, KRUSKAL_50_50_3_O, KRUSKAL_50_50_4_O] = deal(zeros(REPS, 2));

%ABCD命名规则
%A代表模型: r代表regularized matrix, t代表tucker, k代表kruskal
%B代表(p1,p2)的组合，1代表(20,20),2代表(20,50),3代表(50,50)
%C代表样本量,1代表n=0.5p1p2,2代表p1p2,3代表1.5p1p2,4代表2p1p2
%D代表广义线性模型的类型,L代表logistic回归，P代表泊松对数线性模型，O代表普通最小二乘

%开启4个核心并行计算
parpool(4);
tic
parfor rep = 1:REPS
    if rem(rep, 5) == 0
        disp(["This is the" num2str(rep) "th iteration..."]); 
    end
    
    [r11L, r11P, r11O, t11L, t11P, t11O, k11L, k11P, k11O] = simulation(0.5, 20, 20);
    [r12L, r12P, r12O, t12L, t12P, t12O, k12L, k12P, k12O] = simulation(1, 20, 20);
    [r13L, r13P, r13O, t13L, t13P, t13O, k13L, k13P, k13O] = simulation(1.5, 20, 20);
    [r14L, r14P, r14O, t14L, t14P, t14O, k14L, k14P, k14O] = simulation(2, 20, 20);
    
    [r21L, r21P, r21O, t21L, t21P, t21O, k21L, k21P, k21O] = simulation(0.5, 20, 50);
    [r22L, r22P, r22O, t22L, t22P, t22O, k22L, k22P, k22O] = simulation(1, 20, 50);
    [r23L, r23P, r23O, t23L, t23P, t23O, k23L, k23P, k23O] = simulation(1.5, 20, 50);
    [r24L, r24P, r24O, t24L, t24P, t24O, k24L, k24P, k24O] = simulation(2, 20, 50);
    
    [r31L, r31P, r31O, t31L, t31P, t31O, k31L, k31P, k31O] = simulation(0.5, 50, 50);
    [r32L, r32P, r32O, t32L, t32P, t32O, k32L, k32P, k32O] = simulation(1, 50, 50);
    [r33L, r33P, r33O, t33L, t33P, t33O, k33L, k33P, k33O] = simulation(1.5, 50, 50);
    [r34L, r34P, r34O, t34L, t34P, t34O, k34L, k34P, k34O] = simulation(2, 50, 50);
    
    %% Regularized matrix regression value assignment
    RMR_20_20_1_L(rep, :) = r11L;
    RMR_20_20_2_L(rep, :) = r12L;
    RMR_20_20_3_L(rep, :) = r13L;
    RMR_20_20_4_L(rep, :) = r14L;
    RMR_20_50_1_L(rep, :) = r21L;
    RMR_20_50_2_L(rep, :) = r22L;
    RMR_20_50_3_L(rep, :) = r23L;
    RMR_20_50_4_L(rep, :) = r24L;
    RMR_50_50_1_L(rep, :) = r31L;
    RMR_50_50_2_L(rep, :) = r32L;
    RMR_50_50_3_L(rep, :) = r33L;
    RMR_50_50_4_L(rep, :) = r34L;
    
    RMR_20_20_1_P(rep, :) = r11P;
    RMR_20_20_2_P(rep, :) = r12P;
    RMR_20_20_3_P(rep, :) = r13P;
    RMR_20_20_4_P(rep, :) = r14P;
    RMR_20_50_1_P(rep, :) = r21P;
    RMR_20_50_2_P(rep, :) = r22P;
    RMR_20_50_3_P(rep, :) = r23P;
    RMR_20_50_4_P(rep, :) = r24P;
    RMR_50_50_1_P(rep, :) = r31P;
    RMR_50_50_2_P(rep, :) = r32P;
    RMR_50_50_3_P(rep, :) = r33P;
    RMR_50_50_4_P(rep, :) = r34P;
    
    RMR_20_20_1_O(rep, :) = r11O;
    RMR_20_20_2_O(rep, :) = r12O;
    RMR_20_20_3_O(rep, :) = r13O;
    RMR_20_20_4_O(rep, :) = r14O;
    RMR_20_50_1_O(rep, :) = r21O;
    RMR_20_50_2_O(rep, :) = r22O;
    RMR_20_50_3_O(rep, :) = r23O;
    RMR_20_50_4_O(rep, :) = r24O;
    RMR_50_50_1_O(rep, :) = r31O;
    RMR_50_50_2_O(rep, :) = r32O;
    RMR_50_50_3_O(rep, :) = r33O;
    RMR_50_50_4_O(rep, :) = r34O;
    
   %% Tucker regression value assignment
    TUCKER_20_20_1_L(rep, :) = t11L;
    TUCKER_20_20_2_L(rep, :) = t12L;
    TUCKER_20_20_3_L(rep, :) = t13L;
    TUCKER_20_20_4_L(rep, :) = t14L;
    TUCKER_20_50_1_L(rep, :) = t21L;
    TUCKER_20_50_2_L(rep, :) = t22L;
    TUCKER_20_50_3_L(rep, :) = t23L;
    TUCKER_20_50_4_L(rep, :) = t24L;
    TUCKER_50_50_1_L(rep, :) = t31L;
    TUCKER_50_50_2_L(rep, :) = t32L;
    TUCKER_50_50_3_L(rep, :) = t33L;
    TUCKER_50_50_4_L(rep, :) = t34L;
    
    TUCKER_20_20_1_P(rep, :) = t11P;
    TUCKER_20_20_2_P(rep, :) = t12P;
    TUCKER_20_20_3_P(rep, :) = t13P;
    TUCKER_20_20_4_P(rep, :) = t14P;
    TUCKER_20_50_1_P(rep, :) = t21P;
    TUCKER_20_50_2_P(rep, :) = t22P;
    TUCKER_20_50_3_P(rep, :) = t23P;
    TUCKER_20_50_4_P(rep, :) = t24P;
    TUCKER_50_50_1_P(rep, :) = t31P;
    TUCKER_50_50_2_P(rep, :) = t32P;
    TUCKER_50_50_3_P(rep, :) = t33P;
    TUCKER_50_50_4_P(rep, :) = t34P;
    
    TUCKER_20_20_1_O(rep, :) = t11O;
    TUCKER_20_20_2_O(rep, :) = t12O;
    TUCKER_20_20_3_O(rep, :) = t13O;
    TUCKER_20_20_4_O(rep, :) = t14O;
    TUCKER_20_50_1_O(rep, :) = t21O;
    TUCKER_20_50_2_O(rep, :) = t22O;
    TUCKER_20_50_3_O(rep, :) = t23O;
    TUCKER_20_50_4_O(rep, :) = t24O;
    TUCKER_50_50_1_O(rep, :) = t31O;
    TUCKER_50_50_2_O(rep, :) = t32O;
    TUCKER_50_50_3_O(rep, :) = t33O;
    TUCKER_50_50_4_O(rep, :) = t34O;
    
    %% kruskal regression value assignment
    KRUSKAL_20_20_1_L(rep, :) = k11L;
    KRUSKAL_20_20_2_L(rep, :) = k12L;
    KRUSKAL_20_20_3_L(rep, :) = k13L;
    KRUSKAL_20_20_4_L(rep, :) = k14L;
    KRUSKAL_20_50_1_L(rep, :) = k21L;
    KRUSKAL_20_50_2_L(rep, :) = k22L;
    KRUSKAL_20_50_3_L(rep, :) = k23L;
    KRUSKAL_20_50_4_L(rep, :) = k24L;
    KRUSKAL_50_50_1_L(rep, :) = k31L;
    KRUSKAL_50_50_2_L(rep, :) = k32L;
    KRUSKAL_50_50_3_L(rep, :) = k33L;
    KRUSKAL_50_50_4_L(rep, :) = k34L;
    
    KRUSKAL_20_20_1_P(rep, :) = k11P;
    KRUSKAL_20_20_2_P(rep, :) = k12P;
    KRUSKAL_20_20_3_P(rep, :) = k13P;
    KRUSKAL_20_20_4_P(rep, :) = k14P;
    KRUSKAL_20_50_1_P(rep, :) = k21P;
    KRUSKAL_20_50_2_P(rep, :) = k22P;
    KRUSKAL_20_50_3_P(rep, :) = k23P;
    KRUSKAL_20_50_4_P(rep, :) = k24P;
    KRUSKAL_50_50_1_P(rep, :) = k31P;
    KRUSKAL_50_50_2_P(rep, :) = k32P;
    KRUSKAL_50_50_3_P(rep, :) = k33P;
    KRUSKAL_50_50_4_P(rep, :) = k34P;
    
    KRUSKAL_20_20_1_O(rep, :) = k11O;
    KRUSKAL_20_20_2_O(rep, :) = k12O;
    KRUSKAL_20_20_3_O(rep, :) = k13O;
    KRUSKAL_20_20_4_O(rep, :) = k14O;
    KRUSKAL_20_50_1_O(rep, :) = k21O;
    KRUSKAL_20_50_2_O(rep, :) = k22O;
    KRUSKAL_20_50_3_O(rep, :) = k23O;
    KRUSKAL_20_50_4_O(rep, :) = k24O;
    KRUSKAL_50_50_1_O(rep, :) = k31O;
    KRUSKAL_50_50_2_O(rep, :) = k32O;
    KRUSKAL_50_50_3_O(rep, :) = k33O;
    KRUSKAL_50_50_4_O(rep, :) = k34O;
end
toc
delete(gcp('nocreate'));

VARS_RMR = who('-regexp', 'RMR_');
VARS_TUCKER = who('-regexp', 'TUCKER_');
VARS_KRUSKAL = who('-regexp', 'KRUSKAL_');
for item = 1:36
    xlswrite("./result_rmr.xlsx", eval(cell2mat(VARS_RMR(item))), cell2mat(VARS_RMR(item)));
    xlswrite("./result_tucker.xlsx", eval(cell2mat(VARS_TUCKER(item))), cell2mat(VARS_TUCKER(item)));
    xlswrite("./result_kruskal.xlsx", eval(cell2mat(VARS_KRUSKAL(item))), cell2mat(VARS_KRUSKAL(item)));
end