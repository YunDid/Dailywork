function [NBurst_Parameters, SpikeBurstNumber] = BurstDetectISIn( Spike, N, ISI_N )
    % 当连续的 N 个神经元的时间间隔小于等于该值 ISI_N 时，这些神经元就被认为是处于突发状态。
    
    fprintf('Beginning NBurst_Parameters detection.\n');
    % Find when the ISI_N NBurst_Parameters condition is met
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
    % %% Assign NBurst_Parameters numbers to each spike
    SpikeBurstNumber = zeros(size(Spike)) - 1; % Initialize to '-1'
    INBURST = 0; % In a NBurst_Parameters (1) or not (0)
    NUM_ = 0; % NBurst_Parameters Number iterator
    NUMBER = -1; % NBurst_Parameters Number assigned
    BL = 0; % NBurst_Parameters Length
    for i = N:length(Spike)
        if INBURST == 0 % Was not in NBurst_Parameters.
            if Criteria(i) % Criteria met, now in new NBurst_Parameters.
                INBURST = 1; % Update.
                NUM_ = NUM_ + 1;
                NUMBER = NUM_;
                BL = 1;
            else %Still not in NBurst_Parameters, continue
                % continue %
            end
        else % Was in NBurst_Parameters.
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
                % NBurst_Parameters has fewer than 'N' spikes and is therefore deleted in
                % the above conditional statement (i.e. 'if BL<N').
                %
                % Skip this if at the start of a new NBurst_Parameters (i.e. 'BL>=N'
                % requirement).
                %
                NUM_ = NUM_ + 1; % New NBurst_Parameters, update number.
                NUMBER = NUM_;
                BL = 1; % Reset NBurst_Parameters length.
            else % Criteria still met.
                BL = BL + 1; % Update NBurst_Parameters length.
            end
        end
        SpikeBurstNumber(i) = NUMBER; % Assign a NBurst_Parameters number to
        % each spike.
    end
    % %% Assign NBurst_Parameters information
    fprintf('Assigning NBurst_Parameters information.\n');
    MaxBurstNumber = max(SpikeBurstNumber);
    NBurst_Parameters.T_start = zeros(1,MaxBurstNumber); % NBurst_Parameters start time [sec]
    NBurst_Parameters.T_end = zeros(1,MaxBurstNumber); % NBurst_Parameters end time [sec]
    NBurst_Parameters.S = zeros(1,MaxBurstNumber); % Size (total spikes)
    NBurst_Parameters.C = zeros(1,MaxBurstNumber); % Size (total channels)
    for i = 1:MaxBurstNumber
        ID = find( SpikeBurstNumber==i );
        NBurst_Parameters.T_start(i) = Spike(ID(1));
        NBurst_Parameters.T_end(i) = Spike(ID(end));
        NBurst_Parameters.S(i) = length(ID);
        if isfield( Spike, 'C' )
            NBurst_Parameters.C(i) = length( unique(Spike.C(ID)) );
        end
    end
    fprintf('Finished NBurst_Parameters detection using %0.2f minutes of spike data.\n', ...
        diff(Spike([1 end]))/60);
    end