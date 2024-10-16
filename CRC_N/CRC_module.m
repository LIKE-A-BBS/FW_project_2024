%% Initial conditions
clearvars;

N = 100;                % Number of input
p = 0.02;               %bit error rate(BER)
input_bit = 4;          % input bitwidth
CRC_bit = 3;      % CRC bitwidth
divisor = 0b1011u32;    % Divisor

%% Generate input & Calc CRC
input = randi(power(2,input_bit)-1,[N 1]);

codeword_length = input_bit + CRC_bit;
shift_input = bitshift(input,CRC_bit);
CRC = zeros([N 1]);
divisor = bitshift(divisor,input_bit-1);
remainder = shift_input;

for i = 1:N
    for j = 1:input_bit
        if bitget(remainder(i),codeword_length)
            remainder(i) = bitxor(remainder(i),divisor);
        end
        remainder(i) = bitshift(remainder(i),1);
    end
    CRC(i)= bitshift(remainder(i),-input_bit);
end
codeword = shift_input + CRC;

%% 전송과정 중 오류 
noisy_data = zeros([N 1]);
for l = 1:N
    for i = 0:codeword_length-1
        noisy_data(l) = noisy_data(l) + power(2,i) * binornd(1,p);
    end
end
noisy_codeword = bitxor(codeword,noisy_data);
%% 오류 검증
remainder2 = noisy_codeword;
error_detect = zeros([N 1]);
out = zeros([N 1]);
for i = 1:N
    for j = 1:input_bit
        if bitget(remainder2(i),codeword_length)
            remainder2(i) = bitxor(remainder2(i),divisor);
        end
        remainder2(i) = bitshift(remainder2(i),1);
    end
    if remainder2(i)
        error_detect(i) = 1;
    else
        out(i) = bitshift(noisy_codeword(i),-CRC_bit);
    end
end

%% File export
% Sender
input_hex = fopen('./input_hex.txt', 'w');
for k = 1:N
    pr_input_h = input(k);
    fprintf(input_hex,'%x \n', pr_input_h);
end
CRC_hex = fopen('./CRC_hex.txt', 'w');
for k = 1:N
    pr_CRC_h = CRC(k);
    fprintf(CRC_hex,'%x \n', pr_CRC_h);
end
Codeword_hex = fopen('./Codeword_hex.txt', 'w');
for k = 1:N
    pr_codeword_h = codeword(k);
    fprintf(Codeword_hex,'%x \n', pr_codeword_h);
end

% Receiver
noisy_codeword_hex = fopen('./noisy_codeword_hex.txt', 'w');
for k = 1:N
    pr_noisy_codeword_h = noisy_codeword(k);
    fprintf(noisy_codeword_hex,'%x \n', pr_noisy_codeword_h);
end
error_detect_hex = fopen('./error_detect_hex.txt', 'w');
for k = 1:N
    pr_error_detect_h = error_detect(k);
    fprintf(error_detect_hex,'%x \n', pr_error_detect_h);
end
out_hex = fopen('./out_hex.txt', 'w');
for k = 1:N
    pr_out_h = out(k);
    fprintf(out_hex,'%x \n', pr_out_h);
end