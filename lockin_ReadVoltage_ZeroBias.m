function [V,V_err,phase,freq] ...
    = lockin_ReadVoltage_ZeroBias(app,repetitions,SRS_timeconstant)
    voltages        = NaN(1,repetitions);
    v_errors        = NaN(1,repetitions);
    timeConstant    = SRS_timeconstant ;% seconds
    ENBW            = 5/(64*timeConstant); % Equivalent Noise Bandwith for SRS830


    % Set the gate voltage

    fprintf(app.handle_lockin, 'PHAS 0.0');
%     pause(SRS_timeconstant);
    pause(0.0001);
    for nPoint = 1:repetitions
        fprintf(app.handle_lockin,'OUTP? 3'); %reads R
        voltages(nPoint) = str2double(fscanf(app.handle_lockin));   
        v_errors(nPoint) = (0.13E-9)*sqrt(voltages(nPoint))*sqrt(ENBW) ; % See SRS380 manual page 5-21
%         if app.stopFlag ~= 0
%             break;
%         end
    end


    V = mean(voltages)*sqrt(2); % rms to 0.5Vpp
    V_err = max(mean(v_errors),std(voltages)*sqrt(2));
    fprintf(app.handle_lockin, 'OUTP? 4');
    phase = str2double(fscanf(app.handle_lockin)); 
    fprintf(app.handle_lockin,'FREQ?');
    freq = str2double(fscanf(app.handle_lockin));
end