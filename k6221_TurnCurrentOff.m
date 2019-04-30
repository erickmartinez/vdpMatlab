function k6221_TurnCurrentOff(app)
    fprintf(app.handle_k6221,'SOUR:WAVE:ABOR');    % Stop generating waveform.
    fprintf(app.handle_k6221,'SOUR:WAVE:PMAR:STAT OFF');    %  Set offset.
    fprintf(app.handle_k6221,'OUTPut:LTEarth OFF');    % Connects triax output low from Earth Ground:
end