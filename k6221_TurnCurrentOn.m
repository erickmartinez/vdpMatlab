function k6221_TurnCurrentOn(app)
    fprintf(app.handle_k6221,'OUTPut:LTEarth OFF');    % Disconnects (floats) triax output low from Earth Ground:
    fprintf(app.handle_k6221,'SOUR:WAVE:ARM');    % Arm waveform.
    fprintf(app.handle_k6221,':OUTP ON');         % Turn on output.
    fprintf(app.handle_k6221,'SOUR:WAVE:INIT ');  % Turn on output, trigger waveform.
end