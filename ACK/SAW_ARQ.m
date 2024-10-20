%%
tp = 0.1;                           % propagation time
bps = 30;                           % 
numbering = 3;
window = 1;                         % # of FSMs
BER = 0.01;                         % Bit Error Rate
frame_size = 20;                    % Frame length
ACK_size = 3;                       % Acknowledgement

%%
FER = 1 - ((1-BER)^frame_size);
AER = 1 - ((1-BER)^ACK_size);       % ACK Error Rate
tr = frame_size/bps;                % transmission time
U = tr/(tr+2*tp);                   % Channel Utilization
%%
