function lockin_SetSensibility(app,SRS_timeconstant)
    % Sets the sensibility dynamically
    fprintf(app.handle_lockin, 'SENS 5'); %
    % Query the current sensibility
    pause(5*SRS_timeconstant);

    % Determine if the lockin is ovlded
    ovld = lockin_GetOverload(app);


    fprintf(app.handle_lockin,'SENS ?');
    % sens = int16(11);
    sens = int16(str2double(fscanf(app.handle_lockin)));

    if (ovld ~= 0 && sens < 26)
        % if it is overloaded decrease the sensibility until it is no longer
        % overloaded
        while (ovld == 1 && sens <= 26)
            sens = sens + 1;
            q = sprintf('SENS %d',sens);
            fprintf(app.handle_lockin,q);
            % Determine if the lockin is ovlded
            pause(5*SRS_timeconstant);
            ovld = lockin_GetOverload(app);
        end
    else
        % if it is not overloaded increase the sensibility
        while (sens > 1 && ovld == 0)
            sens = sens - 1;
            q = sprintf('SENS %d',sens);
            fprintf(app.handle_lockin,q);
            % Determine if the lockin is ovlded
            pause(5*SRS_timeconstant);
            ovld = lockin_GetOverload(app);
        end

        if ovld == 1
            sens = sens + 1;
            if (sens > 26) 
                sens = 26;
            end
            q = sprintf('SENS %d',sens);
            fprintf(app.handle_lockin,q);
            ovld = lockin_GetOverload(app);
        end 

    end
    % pause(5*SRS_timeconstant);
    % fprintf(app.handle_lockin,'AGAN');
    % pause(5*SRS_timeconstant);
    final_sens = sens + 0;
    if final_sens <= 26
        q = sprintf('SENS %d',final_sens);
        fprintf(app.handle_lockin,q);
    end
    % fprintf(app.handle_lockin, 'PHAS 0.0');
    pause(10*SRS_timeconstant);
end