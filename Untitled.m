% a

% 132
%%  这是注释
str = 'zheshizifuchuan'
%% 那这个是不是注释
length(str)

%% 矩阵
A = [1 2 3;4 5 6;7 8 9]
% 转置
B = A'
% 竖着拉伸 以列为基准转换为列向量
C = A(:)
% 求逆矩阵 方阵
D = inv(A)
% 生成全是0的矩阵 （行数，列数，维度）
E = zeros(10,5,3)
% rand(0-1之间，随机均匀分布,m*n的随机矩阵),randn(0-1之间，正态分布,m*n的随机矩阵) randi(iMax,[m,n]) {(0,IMax]之间左开右闭，m*x随机整数矩阵}
E(:,:,1) = rand(10,5)
E(:,:,2) = randn(10,5)
E(:,:,3) = randi(5,10,5)

grade = 'B';
switch(grade)
    case 'A' 
        fprintf('Excellent!\n' )
        
    case 'B' 
        fprintf('Well done\n' )
        grade = 'C';
    case 'C' 
        fprintf('Well done\n' )
    case 'D'
        fprintf('You passed\n' )

    case 'F' 
        fprintf('Better try again\n' )

    otherwise
        fprintf('Invalid grade\n' )
end

%% 官网案例

a = [1,2,7;3,4,8;5,6,10];

c = a * inv(a);

a = a + 10;

a = [1,2,7;3,4,8;5,6,10]

b = a(1:2:3,2)

seq = "zxcvb"
seq(1) = "d"
seq1 = 'xxxxx'
seq2 = [seq seq1]
seq3 = ['1' '2']
seq4 = "1" + "2"
seq5 = seq4(2)


x = linspace(0,2*pi)
y = sin(x)
plot(x,y)



xlabel("x")
ylabel("y")
title("title")



hold on
y2 = cos(x);
plot(x,y2,":")
legend("sin","cos")
%hold off


edit foot

A = [16 3 2 13; 5 10 11 8; 9 6 7 12; 4 15 14 1]
A(1) = []
B = A(1:end,1:end)
B = A . 2
C = 2 .* A

n = (0:9)

x = [2.1 1.7 1.6 1.5 NaN; 1.9 1.8 1.5 5.1 1.8; 1.4 2.2 1.6 1.8 1.9];
x = x(x <= 10)lkooooooooooooooo
x(:,[1,2,3]) = 0
x(isfinite(x)) = 0


x = [1 2 3 4 5; 6 7 8 9 10;11 12 13 14 15;16 17 18 19 20]
a = find(x<=10)'
x(a) = 0

S.name = 'Ed Plum';
S.score = 83;
S.grade = 'B+'

S(2).name = 'Toni Miller';
S(2).score = 91;
S(2).grade = 'A-';

[N1 N2 N3] = S.score

%{
132132123123
%}

matrix = (0:9)
matrix1 = [0:9]

h = ['hello';' world']
s = char('hello',' world')

S.name = 'Ed Plum';
S.score = 83;
S.grade = 'B+'

S(2).name = 'Toni Miller';
S(2).score = 91;
S(2).grade = 'A-';

S(3) = struct('name','Jerry Garcia',... 
               'score',70,'grade','C')
           
[n1 n2 n3] = S

a = [1 1]
b = [1 1 2]
c = any(a)

