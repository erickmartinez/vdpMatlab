function k2400_TurnVgOn(app, vg)
    vrange = 0.2;
    if (2e-3 <= abs(vg) && abs(vg) < 2)
        vrange = 2;
    elseif (2 <= abs(vg) && abs(vg) < 20)
        vrange = 20;
    elseif (20 <= abs(vg) && abs(vg) < 200)
        vrange = 200;
    end

    fprintf(app.handle_k2400,':ROUT:TERM REAR'); %  select the rear terminals
    fprintf(app.handle_k2400,':SOUR:FUNC VOLT'); % Select voltage source.  
    fprintf(app.handle_k2400,':SOUR:VOLT:MODE FIXED'); % Fixed voltage source mode..
%     fprintf(app.handle_k2400,':SOUR:VOLT:RANG %.3f',vrange); % Select source range.
    fprintf(app.handle_k2400,':SOUR:VOLT:RANG 200');% Select 200V source range.
    fprintf(app.handle_k2400,':SOUR:VOLT:LEV 0'); % set vg to zero.
    fprintf(app.handle_k2400,':SENS:CURR:PROT 1000E-3'); % Source keithley gate protection lvl
    fprintf(app.handle_k2400,':SENS:FUNC "CURR"'); % Volts measure function.
    % fprintf(gate_handle,':SENS:CURR:RANG:AUTO ON'); % 
    fprintf(app.handle_k2400,':SENS:CURR:RANG 100E-3'); % 
    fprintf(app.handle_k2400,':FORM:ELEM CURR'); % Volts only.
    fprintf(app.handle_k2400,'ARM:SOURce IMMediate'); % ARM immediate
    fprintf(app.handle_k2400,'TRIGger:SOURce IMMediate'); % ARM immediate
%     fprintf(app.handle_k2400,':SOUR:DELay MIN'); % manually set a delay (settling time) for the source. 
    fprintf(app.handle_k2400,':OUTP ON'); % Output on before measuring.
    fprintf(app.handle_k2400,'SYST:BEEP:STAT 0'); %turn beeper on
end
