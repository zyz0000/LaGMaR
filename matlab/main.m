rng(2021);
warning('off');
REPS = 50;
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

%% tucker12 regression
[TUCKER12_20_20_1_L, TUCKER12_20_20_2_L, TUCKER12_20_20_3_L, TUCKER12_20_20_4_L] = deal(zeros(REPS, 5));
[TUCKER12_20_50_1_L, TUCKER12_20_50_2_L, TUCKER12_20_50_3_L, TUCKER12_20_50_4_L] = deal(zeros(REPS, 5));
[TUCKER12_50_50_1_L, TUCKER12_50_50_2_L, TUCKER12_50_50_3_L, TUCKER12_50_50_4_L] = deal(zeros(REPS, 5));

[TUCKER12_20_20_1_P, TUCKER12_20_20_2_P, TUCKER12_20_20_3_P, TUCKER12_20_20_4_P] = deal(zeros(REPS, 3));
[TUCKER12_20_50_1_P, TUCKER12_20_50_2_P, TUCKER12_20_50_3_P, TUCKER12_20_50_4_P] = deal(zeros(REPS, 3));
[TUCKER12_50_50_1_P, TUCKER12_50_50_2_P, TUCKER12_50_50_3_P, TUCKER12_50_50_4_P] = deal(zeros(REPS, 3));

[TUCKER12_20_20_1_O, TUCKER12_20_20_2_O, TUCKER12_20_20_3_O, TUCKER12_20_20_4_O] = deal(zeros(REPS, 2));
[TUCKER12_20_50_1_O, TUCKER12_20_50_2_O, TUCKER12_20_50_3_O, TUCKER12_20_50_4_O] = deal(zeros(REPS, 2));
[TUCKER12_50_50_1_O, TUCKER12_50_50_2_O, TUCKER12_50_50_3_O, TUCKER12_50_50_4_O] = deal(zeros(REPS, 2));

%% tucker22 regression
[TUCKER22_20_20_1_L, TUCKER22_20_20_2_L, TUCKER22_20_20_3_L, TUCKER22_20_20_4_L] = deal(zeros(REPS, 5));
[TUCKER22_20_50_1_L, TUCKER22_20_50_2_L, TUCKER22_20_50_3_L, TUCKER22_20_50_4_L] = deal(zeros(REPS, 5));
[TUCKER22_50_50_1_L, TUCKER22_50_50_2_L, TUCKER22_50_50_3_L, TUCKER22_50_50_4_L] = deal(zeros(REPS, 5));

[TUCKER22_20_20_1_P, TUCKER22_20_20_2_P, TUCKER22_20_20_3_P, TUCKER22_20_20_4_P] = deal(zeros(REPS, 3));
[TUCKER22_20_50_1_P, TUCKER22_20_50_2_P, TUCKER22_20_50_3_P, TUCKER22_20_50_4_P] = deal(zeros(REPS, 3));
[TUCKER22_50_50_1_P, TUCKER22_50_50_2_P, TUCKER22_50_50_3_P, TUCKER22_50_50_4_P] = deal(zeros(REPS, 3));

[TUCKER22_20_20_1_O, TUCKER22_20_20_2_O, TUCKER22_20_20_3_O, TUCKER22_20_20_4_O] = deal(zeros(REPS, 2));
[TUCKER22_20_50_1_O, TUCKER22_20_50_2_O, TUCKER22_20_50_3_O, TUCKER22_20_50_4_O] = deal(zeros(REPS, 2));
[TUCKER22_50_50_1_O, TUCKER22_50_50_2_O, TUCKER22_50_50_3_O, TUCKER22_50_50_4_O] = deal(zeros(REPS, 2));

%% kruskal1 regression
[KRUSKAL1_20_20_1_L, KRUSKAL1_20_20_2_L, KRUSKAL1_20_20_3_L, KRUSKAL1_20_20_4_L] = deal(zeros(REPS, 5));
[KRUSKAL1_20_50_1_L, KRUSKAL1_20_50_2_L, KRUSKAL1_20_50_3_L, KRUSKAL1_20_50_4_L] = deal(zeros(REPS, 5));
[KRUSKAL1_50_50_1_L, KRUSKAL1_50_50_2_L, KRUSKAL1_50_50_3_L, KRUSKAL1_50_50_4_L] = deal(zeros(REPS, 5));

[KRUSKAL1_20_20_1_P, KRUSKAL1_20_20_2_P, KRUSKAL1_20_20_3_P, KRUSKAL1_20_20_4_P] = deal(zeros(REPS, 3));
[KRUSKAL1_20_50_1_P, KRUSKAL1_20_50_2_P, KRUSKAL1_20_50_3_P, KRUSKAL1_20_50_4_P] = deal(zeros(REPS, 3));
[KRUSKAL1_50_50_1_P, KRUSKAL1_50_50_2_P, KRUSKAL1_50_50_3_P, KRUSKAL1_50_50_4_P] = deal(zeros(REPS, 3));

[KRUSKAL1_20_20_1_O, KRUSKAL1_20_20_2_O, KRUSKAL1_20_20_3_O, KRUSKAL1_20_20_4_O] = deal(zeros(REPS, 2));
[KRUSKAL1_20_50_1_O, KRUSKAL1_20_50_2_O, KRUSKAL1_20_50_3_O, KRUSKAL1_20_50_4_O] = deal(zeros(REPS, 2));
[KRUSKAL1_50_50_1_O, KRUSKAL1_50_50_2_O, KRUSKAL1_50_50_3_O, KRUSKAL1_50_50_4_O] = deal(zeros(REPS, 2));

%% kruskal2 regression
[KRUSKAL2_20_20_1_L, KRUSKAL2_20_20_2_L, KRUSKAL2_20_20_3_L, KRUSKAL2_20_20_4_L] = deal(zeros(REPS, 5));
[KRUSKAL2_20_50_1_L, KRUSKAL2_20_50_2_L, KRUSKAL2_20_50_3_L, KRUSKAL2_20_50_4_L] = deal(zeros(REPS, 5));
[KRUSKAL2_50_50_1_L, KRUSKAL2_50_50_2_L, KRUSKAL2_50_50_3_L, KRUSKAL2_50_50_4_L] = deal(zeros(REPS, 5));

[KRUSKAL2_20_20_1_P, KRUSKAL2_20_20_2_P, KRUSKAL2_20_20_3_P, KRUSKAL2_20_20_4_P] = deal(zeros(REPS, 3));
[KRUSKAL2_20_50_1_P, KRUSKAL2_20_50_2_P, KRUSKAL2_20_50_3_P, KRUSKAL2_20_50_4_P] = deal(zeros(REPS, 3));
[KRUSKAL2_50_50_1_P, KRUSKAL2_50_50_2_P, KRUSKAL2_50_50_3_P, KRUSKAL2_50_50_4_P] = deal(zeros(REPS, 3));

[KRUSKAL2_20_20_1_O, KRUSKAL2_20_20_2_O, KRUSKAL2_20_20_3_O, KRUSKAL2_20_20_4_O] = deal(zeros(REPS, 2));
[KRUSKAL2_20_50_1_O, KRUSKAL2_20_50_2_O, KRUSKAL2_20_50_3_O, KRUSKAL2_20_50_4_O] = deal(zeros(REPS, 2));
[KRUSKAL2_50_50_1_O, KRUSKAL2_50_50_2_O, KRUSKAL2_50_50_3_O, KRUSKAL2_50_50_4_O] = deal(zeros(REPS, 2));

%% fix the parameters R and C
k = 3; r = 3;
p1 = 20; q1 = 20;
p2 = 20; q2 = 50;
p3 = 50; q3 = 50;
R1 = random("unif", -sqrt(p1), sqrt(p1), p1, k);
C1 = random("unif", -sqrt(q1), sqrt(q1), q1, r);
R2 = random("unif", -sqrt(p2), sqrt(p2), p2, k);
C2 = random("unif", -sqrt(q2), sqrt(q2), q2, r);
R3 = random("unif", -sqrt(p3), sqrt(p3), p3, k);
C3 = random("unif", -sqrt(q3), sqrt(q3), q3, r);

%ABCD命名规则
%A代表模型: r代表regularized matrix, t12代表tucker12, t22代表tucker22, k1代表kruskal1, k2代表kruskal2
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
    
    [r11L, r11P, r11O, t12_11L, t12_11P, t12_11O, t22_11L, t22_11P, t22_11O, ...
        k1_11L, k1_11P, k1_11O, k2_11L, k2_11P, k2_11O] = simulation(R1, C1, 0.5, 20, 20);
    [r12L, r12P, r12O, t12_12L, t12_12P, t12_12O, t22_12L, t22_12P, t22_12O, ...
        k1_12L, k1_12P, k1_12O, k2_12L, k2_12P, k2_12O] = simulation(R1, C1, 1, 20, 20);
    [r13L, r13P, r13O, t12_13L, t12_13P, t12_13O, t22_13L, t22_13P, t22_13O, ...
        k1_13L, k1_13P, k1_13O, k2_13L, k2_13P, k2_13O] = simulation(R1, C1, 1.5, 20, 20);
    [r14L, r14P, r14O, t12_14L, t12_14P, t12_14O, t22_14L, t22_14P, t22_14O, ...
        k1_14L, k1_14P, k1_14O, k2_14L, k2_14P, k2_14O] = simulation(R1, C1, 2, 20, 20);
    
    [r21L, r21P, r21O, t12_21L, t12_21P, t12_21O, t22_21L, t22_21P, t22_21O, ...
        k1_21L, k1_21P, k1_21O, k2_21L, k2_21P, k2_21O] = simulation(R2, C2, 0.5, 20, 50);
    [r22L, r22P, r22O, t12_22L, t12_22P, t12_22O, t22_22L, t22_22P, t22_22O, ...
        k1_22L, k1_22P, k1_22O, k2_22L, k2_22P, k2_22O] = simulation(R2, C2, 1, 20, 50);
    [r23L, r23P, r23O, t12_23L, t12_23P, t12_23O, t22_23L, t22_23P, t22_23O, ...
        k1_23L, k1_23P, k1_23O, k2_23L, k2_23P, k2_23O] = simulation(R2, C2, 1.5, 20, 50);
    [r24L, r24P, r24O, t12_24L, t12_24P, t12_24O, t22_24L, t22_24P, t22_24O, ...
        k1_24L, k1_24P, k1_24O, k2_24L, k2_24P, k2_24O] = simulation(R2, C2, 2, 20, 50);
    
    [r31L, r31P, r31O, t12_31L, t12_31P, t12_31O, t22_31L, t22_31P, t22_31O, ...
        k1_31L, k1_31P, k1_31O, k2_31L, k2_31P, k2_31O] = simulation(R3, C3, 0.5, 50, 50);
    [r32L, r32P, r32O, t12_32L, t12_32P, t12_32O, t22_32L, t22_32P, t22_32O, ...
        k1_32L, k1_32P, k1_32O, k2_32L, k2_32P, k2_32O] = simulation(R3, C3, 1, 50, 50);
    [r33L, r33P, r33O, t12_33L, t12_33P, t12_33O, t22_33L, t22_33P, t22_33O, ...
        k1_33L, k1_33P, k1_33O, k2_33L, k2_33P, k2_33O] = simulation(R3, C3, 1.5, 50, 50);
    [r34L, r34P, r34O, t12_34L, t12_34P, t12_34O, t22_34L, t22_34P, t22_34O, ...
        k1_34L, k1_34P, k1_34O, k2_34L, k2_34P, k2_34O] = simulation(R3, C3, 2, 50, 50);
    
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
    
   %% Tucker12 regression value assignment
    TUCKER12_20_20_1_L(rep, :) = t12_11L;
    TUCKER12_20_20_2_L(rep, :) = t12_12L;
    TUCKER12_20_20_3_L(rep, :) = t12_13L;
    TUCKER12_20_20_4_L(rep, :) = t12_14L;
    TUCKER12_20_50_1_L(rep, :) = t12_21L;
    TUCKER12_20_50_2_L(rep, :) = t12_22L;
    TUCKER12_20_50_3_L(rep, :) = t12_23L;
    TUCKER12_20_50_4_L(rep, :) = t12_24L;
    TUCKER12_50_50_1_L(rep, :) = t12_31L;
    TUCKER12_50_50_2_L(rep, :) = t12_32L;
    TUCKER12_50_50_3_L(rep, :) = t12_33L;
    TUCKER12_50_50_4_L(rep, :) = t12_34L;
    
    TUCKER12_20_20_1_P(rep, :) = t12_11P;
    TUCKER12_20_20_2_P(rep, :) = t12_12P;
    TUCKER12_20_20_3_P(rep, :) = t12_13P;
    TUCKER12_20_20_4_P(rep, :) = t12_14P;
    TUCKER12_20_50_1_P(rep, :) = t12_21P;
    TUCKER12_20_50_2_P(rep, :) = t12_22P;
    TUCKER12_20_50_3_P(rep, :) = t12_23P;
    TUCKER12_20_50_4_P(rep, :) = t12_24P;
    TUCKER12_50_50_1_P(rep, :) = t12_31P;
    TUCKER12_50_50_2_P(rep, :) = t12_32P;
    TUCKER12_50_50_3_P(rep, :) = t12_33P;
    TUCKER12_50_50_4_P(rep, :) = t12_34P;
    
    TUCKER12_20_20_1_O(rep, :) = t12_11O;
    TUCKER12_20_20_2_O(rep, :) = t12_12O;
    TUCKER12_20_20_3_O(rep, :) = t12_13O;
    TUCKER12_20_20_4_O(rep, :) = t12_14O;
    TUCKER12_20_50_1_O(rep, :) = t12_21O;
    TUCKER12_20_50_2_O(rep, :) = t12_22O;
    TUCKER12_20_50_3_O(rep, :) = t12_23O;
    TUCKER12_20_50_4_O(rep, :) = t12_24O;
    TUCKER12_50_50_1_O(rep, :) = t12_31O;
    TUCKER12_50_50_2_O(rep, :) = t12_32O;
    TUCKER12_50_50_3_O(rep, :) = t12_33O;
    TUCKER12_50_50_4_O(rep, :) = t12_34O;
    
    %% Tucker22 regression value assignment
    TUCKER22_20_20_1_L(rep, :) = t22_11L;
    TUCKER22_20_20_2_L(rep, :) = t22_12L;
    TUCKER22_20_20_3_L(rep, :) = t22_13L;
    TUCKER22_20_20_4_L(rep, :) = t22_14L;
    TUCKER22_20_50_1_L(rep, :) = t22_21L;
    TUCKER22_20_50_2_L(rep, :) = t22_22L;
    TUCKER22_20_50_3_L(rep, :) = t22_23L;
    TUCKER22_20_50_4_L(rep, :) = t22_24L;
    TUCKER22_50_50_1_L(rep, :) = t22_31L;
    TUCKER22_50_50_2_L(rep, :) = t22_32L;
    TUCKER22_50_50_3_L(rep, :) = t22_33L;
    TUCKER22_50_50_4_L(rep, :) = t22_34L;
    
    TUCKER22_20_20_1_P(rep, :) = t22_11P;
    TUCKER22_20_20_2_P(rep, :) = t22_12P;
    TUCKER22_20_20_3_P(rep, :) = t22_13P;
    TUCKER22_20_20_4_P(rep, :) = t22_14P;
    TUCKER22_20_50_1_P(rep, :) = t22_21P;
    TUCKER22_20_50_2_P(rep, :) = t22_22P;
    TUCKER22_20_50_3_P(rep, :) = t22_23P;
    TUCKER22_20_50_4_P(rep, :) = t22_24P;
    TUCKER22_50_50_1_P(rep, :) = t22_31P;
    TUCKER22_50_50_2_P(rep, :) = t22_32P;
    TUCKER22_50_50_3_P(rep, :) = t22_33P;
    TUCKER22_50_50_4_P(rep, :) = t22_34P;
    
    TUCKER22_20_20_1_O(rep, :) = t22_11O;
    TUCKER22_20_20_2_O(rep, :) = t22_12O;
    TUCKER22_20_20_3_O(rep, :) = t22_13O;
    TUCKER22_20_20_4_O(rep, :) = t22_14O;
    TUCKER22_20_50_1_O(rep, :) = t22_21O;
    TUCKER22_20_50_2_O(rep, :) = t22_22O;
    TUCKER22_20_50_3_O(rep, :) = t22_23O;
    TUCKER22_20_50_4_O(rep, :) = t22_24O;
    TUCKER22_50_50_1_O(rep, :) = t22_31O;
    TUCKER22_50_50_2_O(rep, :) = t22_32O;
    TUCKER22_50_50_3_O(rep, :) = t22_33O;
    TUCKER22_50_50_4_O(rep, :) = t22_34O;
    
    %% kruskal1 regression value assignment
    KRUSKAL1_20_20_1_L(rep, :) = k1_11L;
    KRUSKAL1_20_20_2_L(rep, :) = k1_12L;
    KRUSKAL1_20_20_3_L(rep, :) = k1_13L;
    KRUSKAL1_20_20_4_L(rep, :) = k1_14L;
    KRUSKAL1_20_50_1_L(rep, :) = k1_21L;
    KRUSKAL1_20_50_2_L(rep, :) = k1_22L;
    KRUSKAL1_20_50_3_L(rep, :) = k1_23L;
    KRUSKAL1_20_50_4_L(rep, :) = k1_24L;
    KRUSKAL1_50_50_1_L(rep, :) = k1_31L;
    KRUSKAL1_50_50_2_L(rep, :) = k1_32L;
    KRUSKAL1_50_50_3_L(rep, :) = k1_33L;
    KRUSKAL1_50_50_4_L(rep, :) = k1_34L;
    
    KRUSKAL1_20_20_1_P(rep, :) = k1_11P;
    KRUSKAL1_20_20_2_P(rep, :) = k1_12P;
    KRUSKAL1_20_20_3_P(rep, :) = k1_13P;
    KRUSKAL1_20_20_4_P(rep, :) = k1_14P;
    KRUSKAL1_20_50_1_P(rep, :) = k1_21P;
    KRUSKAL1_20_50_2_P(rep, :) = k1_22P;
    KRUSKAL1_20_50_3_P(rep, :) = k1_23P;
    KRUSKAL1_20_50_4_P(rep, :) = k1_24P;
    KRUSKAL1_50_50_1_P(rep, :) = k1_31P;
    KRUSKAL1_50_50_2_P(rep, :) = k1_32P;
    KRUSKAL1_50_50_3_P(rep, :) = k1_33P;
    KRUSKAL1_50_50_4_P(rep, :) = k1_34P;
    
    KRUSKAL1_20_20_1_O(rep, :) = k1_11O;
    KRUSKAL1_20_20_2_O(rep, :) = k1_12O;
    KRUSKAL1_20_20_3_O(rep, :) = k1_13O;
    KRUSKAL1_20_20_4_O(rep, :) = k1_14O;
    KRUSKAL1_20_50_1_O(rep, :) = k1_21O;
    KRUSKAL1_20_50_2_O(rep, :) = k1_22O;
    KRUSKAL1_20_50_3_O(rep, :) = k1_23O;
    KRUSKAL1_20_50_4_O(rep, :) = k1_24O;
    KRUSKAL1_50_50_1_O(rep, :) = k1_31O;
    KRUSKAL1_50_50_2_O(rep, :) = k1_32O;
    KRUSKAL1_50_50_3_O(rep, :) = k1_33O;
    KRUSKAL1_50_50_4_O(rep, :) = k1_34O;
    
    %% kruskal2 regression value assignment
    KRUSKAL2_20_20_1_L(rep, :) = k2_11L;
    KRUSKAL2_20_20_2_L(rep, :) = k2_12L;
    KRUSKAL2_20_20_3_L(rep, :) = k2_13L;
    KRUSKAL2_20_20_4_L(rep, :) = k2_14L;
    KRUSKAL2_20_50_1_L(rep, :) = k2_21L;
    KRUSKAL2_20_50_2_L(rep, :) = k2_22L;
    KRUSKAL2_20_50_3_L(rep, :) = k2_23L;
    KRUSKAL2_20_50_4_L(rep, :) = k2_24L;
    KRUSKAL2_50_50_1_L(rep, :) = k2_31L;
    KRUSKAL2_50_50_2_L(rep, :) = k2_32L;
    KRUSKAL2_50_50_3_L(rep, :) = k2_33L;
    KRUSKAL2_50_50_4_L(rep, :) = k2_34L;
    
    KRUSKAL2_20_20_1_P(rep, :) = k2_11P;
    KRUSKAL2_20_20_2_P(rep, :) = k2_12P;
    KRUSKAL2_20_20_3_P(rep, :) = k2_13P;
    KRUSKAL2_20_20_4_P(rep, :) = k2_14P;
    KRUSKAL2_20_50_1_P(rep, :) = k2_21P;
    KRUSKAL2_20_50_2_P(rep, :) = k2_22P;
    KRUSKAL2_20_50_3_P(rep, :) = k2_23P;
    KRUSKAL2_20_50_4_P(rep, :) = k2_24P;
    KRUSKAL2_50_50_1_P(rep, :) = k2_31P;
    KRUSKAL2_50_50_2_P(rep, :) = k2_32P;
    KRUSKAL2_50_50_3_P(rep, :) = k2_33P;
    KRUSKAL2_50_50_4_P(rep, :) = k2_34P;
    
    KRUSKAL2_20_20_1_O(rep, :) = k2_11O;
    KRUSKAL2_20_20_2_O(rep, :) = k2_12O;
    KRUSKAL2_20_20_3_O(rep, :) = k2_13O;
    KRUSKAL2_20_20_4_O(rep, :) = k2_14O;
    KRUSKAL2_20_50_1_O(rep, :) = k2_21O;
    KRUSKAL2_20_50_2_O(rep, :) = k2_22O;
    KRUSKAL2_20_50_3_O(rep, :) = k2_23O;
    KRUSKAL2_20_50_4_O(rep, :) = k2_24O;
    KRUSKAL2_50_50_1_O(rep, :) = k2_31O;
    KRUSKAL2_50_50_2_O(rep, :) = k2_32O;
    KRUSKAL2_50_50_3_O(rep, :) = k2_33O;
    KRUSKAL2_50_50_4_O(rep, :) = k2_34O;
end
toc
delete(gcp('nocreate'));

VARS_RMR = who('-regexp', 'RMR_');
VARS_TUCKER12 = who('-regexp', 'TUCKER12_');
VARS_TUCKER22 = who('-regexp', 'TUCKER22_');
VARS_KRUSKAL1 = who('-regexp', 'KRUSKAL1_');
VARS_KRUSKAL2 = who('-regexp', 'KRUSKAL2_');
for item = 1:36
    xlswrite("./result_rmr.xlsx", eval(cell2mat(VARS_RMR(item))), cell2mat(VARS_RMR(item)));
    xlswrite("./result_tucker12.xlsx", eval(cell2mat(VARS_TUCKER12(item))), cell2mat(VARS_TUCKER12(item)));
    xlswrite("./result_tucker22.xlsx", eval(cell2mat(VARS_TUCKER22(item))), cell2mat(VARS_TUCKER22(item)));
    xlswrite("./result_kruskal1.xlsx", eval(cell2mat(VARS_KRUSKAL1(item))), cell2mat(VARS_KRUSKAL1(item)));
    xlswrite("./result_kruskal2.xlsx", eval(cell2mat(VARS_KRUSKAL2(item))), cell2mat(VARS_KRUSKAL2(item)));
end
