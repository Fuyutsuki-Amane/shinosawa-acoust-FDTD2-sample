clear;
close;

%t = 0.05;
t=0.01;
x = 1;
y = 1;

%変数
f_max = 2000;
c = 340;
dd = c / (10 * f_max);
dt = 1 / (sqrt(2) * 10 * f_max);

T = round(t/dt);
X = round(x/dd);
Y = round(y/dd);

P1 = zeros(X+2,Y+2);
P2 = zeros(X+2,Y+2);
P3 = zeros(X+2,Y+2);
kai = c*dt/dd;

%% 信号
f_sp = 1000;
jiku = 0:dt:t;
sinlength=0:dt:1/f_sp;
s = zeros(1, T);
s(1:size(0:dt:1/f_sp,2)) = 0.5 * sin(2*pi*f_sp*sinlength);
sp = [round(X/2) round(Y/2)];

%% 受音点
mk=zeros(1,T);
mk_position=zeros(1,2);
mk_position(1,:)=[round((X+2)*2/3),round((Y+2)/3)];

%%
for n=1:T
    %音圧更新
    P3(2:X+1,2:Y+1) = 2*P2(2:X+1,2:Y+1) - P1(2:X+1,2:Y+1) + kai^2 * (P2(3:X+2,2:Y+1) + P2(1:X,2:Y+1) + P2(2:X+1,3:Y+2)+P2(2:X+1,1:Y)) - 4*kai^2*P2(2:X+1,2:Y+1);
   
    %境界条件（吸収）
    P3(1, :) = P2(2, :) + (kai-1)/(kai+1) * (P3(2, :) - P2(1, :));
    %P3(X+2, :) = P2(X+1, :) + (kai-1)/(kai+1) * (P3(X+1, :) - P2(X+2, :));
    %P3(:, 1) = P2(:, 2) + (kai-1)/(kai+1) * (P3(:, 2) - P2(:, 1));
    P3(:, Y+2) = P2(:, Y+1) + (kai-1)/(kai+1) * (P3(:, Y+1) - P2(:, Y+2));

    % 境界条件（反射）
    %P3(1, :) = P2(2, :) + P3(2, :) - P2(1, :);
    P3(X+2, :) = P2(X+1, :) + P3(X+1, :) - P2(X+2, :);
    P3(:, 1) = P2(:, 2) + P3(:, 2) - P2(:, 1);
    %P3(:, Y+2) = P2(:, Y+1) + P3(:, Y+1) - P2(:, Y+2);

    %音源の音圧更新
    P3(sp(1),sp(2)) = P3(sp(1),sp(2)) + s(n);

    %時間ステップの更新
    P1 = P2;
    P2 = P3;

end
disp('Simulation finished.');
