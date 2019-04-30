function k6221_ConfigCurrent(app,freq,amplitude,offset)
    fprintf(app.handle_k6221,'*RST');    % Restore defauls.
    fprintf(app.handle_k6221,'SOUR:WAVE:FUNC SIN');    % Select sine wave
    fprintf(app.handle_k6221,'SOUR:WAVE:FREQ %.3e',freq); % Set frequency 
    fprintf(app.handle_k6221,'SOUR:WAVE:AMPL %.3e',amplitude);    % Set amplitude
    fprintf(app.handle_k6221,'SOUR:WAVE:OFFS %.3e',offset);    %  Set offset.
    fprintf(app.handle_k6221,'SOUR:WAVE:PMAR:STAT ON');    %  Set offset.
    fprintf(app.handle_k6221,'SOUR:WAVE:PMAR 0'); %  Sets the marker phase to 0.
    fprintf(app.handle_k6221,'SOUR:WAVE:PMAR:OLIN 1'); %  Sets phase marker trigger line
    fprintf(app.handle_k6221,'SOUR:WAVE:DUR:TIME INF'); % Select infinite duration
    fprintf(app.handle_k6221,'SOUR:WAVE:RANG BEST'); %  Select best fixed source range
    fprintf(app.handle_k6221,'OUTPut:LTEarth OFF'); %  Float current source
end