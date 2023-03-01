function [Burst, SpikeBurstNumber] = BurstDetectISIn( Spike, N, ISI_N )
    % 当连续的 N 个神经元的时间间隔小于等于该值 ISI_N 时，这些神经元就被认为是处于突发状态。
    
    fprintf('Beginning burst detection.\n');
    % Find when the ISI_N burst condition is met
    % Look both directions from each spike
    dT = zeros(N,length(Spike))+inf;
    for j = 0:N-1
        dT(j+1,N:length(Spike)-(N-1)) = Spike( (N:end-(N-1))+j ) - ...
            Spike( (1:end-(N-1)*2)+j );
    end
    Criteria = zeros(size(Spike)); % Initialize to zero
    Criteria( min(dT)<=ISI_N ) = 1; % Spike passes condition if it is
    % included in a set of N spikes
    % with ISI_N <= threshold.
    % %% Assign burst numbers to each spike
    SpikeBurstNumber = zeros(size(Spike)) - 1; % Initialize to '-1'
    INBURST = 0; % In a burst (1) or not (0)
    NUM_ = 0; % Burst Number iterator
    NUMBER = -1; % Burst Number assigned
    BL = 0; % Burst Length
    for i = N:length(Spike)
        if INBURST == 0 % Was not in burst.
            if Criteria(i) % Criteria met, now in new burst.
                INBURST = 1; % Update.
                NUM_ = NUM_ + 1;
                NUMBER = NUM_;
                BL = 1;
            else %Still not in burst, continue
                % continue %
            end
        else % Was in burst.
            if ~ Criteria(i) % Criteria no longer met.
                INBURST = 0; % Update.
                if BL<N % Erase if not big enough.
                    SpikeBurstNumber(SpikeBurstNumber==NUMBER) = -1;
                    NUM_ = NUM_ - 1;
                end
                NUMBER = -1;
            elseif diff(Spike([i-(N-1) i])) > ISI_N && BL >= N
                % This conditional statement is necessary to split apart
                % consecutive bursts that are not interspersed by a tonic spike
                % (i.e. Criteria == 0). Occasionally in this case, the second
                % burst has fewer than 'N' spikes and is therefore deleted in
                % the above conditional statement (i.e. 'if BL<N').
                %
                % Skip this if at the start of a new burst (i.e. 'BL>=N'
                % requirement).
                %
                NUM_ = NUM_ + 1; % New burst, update number.
                NUMBER = NUM_;
                BL = 1; % Reset burst length.
            else % Criteria still met.
                BL = BL + 1; % Update burst length.
            end
        end
        SpikeBurstNumber(i) = NUMBER; % Assign a burst number to
        % each spike.
    end
    % %% Assign Burst information
    fprintf('Assigning Burst information.\n');
    MaxBurstNumber = max(SpikeBurstNumber);
    Burst.T_start = zeros(1,MaxBurstNumber); % Burst start time [sec]
    Burst.T_end = zeros(1,MaxBurstNumber); % Burst end time [sec]
    Burst.S = zeros(1,MaxBurstNumber); % Size (total spikes)
    Burst.C = zeros(1,MaxBurstNumber); % Size (total channels)
    for i = 1:MaxBurstNumber
        ID = find( SpikeBurstNumber==i );
        Burst.T_start(i) = Spike(ID(1));
        Burst.T_end(i) = Spike(ID(end));
        Burst.S(i) = length(ID);
        if isfield( Spike, 'C' )
            Burst.C(i) = length( unique(Spike.C(ID)) );
        end
    end
    fprintf('Finished burst detection using %0.2f minutes of spike data.\n', ...
        diff(Spike([1 end]))/60);
    end