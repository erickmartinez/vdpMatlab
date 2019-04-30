function k2400_TurnVgOff(app)
    fprintf(app.handle_k2400,':SOUR:VOLT:LEV 0'); 
    fprintf(app.handle_k2400,'SYST:BEEP:STAT 1'); % Select voltage source.  
    fprintf(app.handle_k2400,':OUTP OFF'); % Fixed voltage source mode..
    fprintf(app.handle_k2400,':ROUT:TERM FRON'); % Select source range.
end
