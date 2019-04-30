function [h_k6221,h_k2400,h_lockin,h_arduino] = ConnectDevices(app)
    h_k6221 = 0;
    h_k2400 = 0;
    h_lockin = 0;
    h_arduino = 0;
    
    DisconnectDevices(app);
    success = 1;
    
    % Connecting to Arduino
    try
        h_arduino = arduino(app.ArduinoAddressEditField.Value)%,...
        app.ArduinoLamp.Color = [0 1 0];
    catch err
        arduino_error = err.message
        success = 0;
    end
    
    %Connecting to lock-in amplifier, if fail update connect_success
    try
        h_lockin = gpib('KEYSIGHT',7,app.LockinAddressEditField.Value);
        set(h_lockin, 'Name', 'SRSLockin_GPIB');
        fopen(h_lockin);
        set(h_lockin,'EOSMode','read&write');
        set(h_lockin,'EOSCharCode','LF');
        fprintf(h_lockin, '*RST');
        fprintf(h_lockin, 'OUTX 1');
        fprintf(h_lockin, 'PHAS 0.0'); % Set the phase to zero
        fprintf(h_lockin, 'FAST 2'); % Set the fast data transfer on for windows (i=2)
        fprintf(h_lockin, 'FMOD 0'); %external reference
        fprintf(h_lockin, 'RSLP 1'); % sine zero crossing i=0), TTL rising edge (i=1), or TTL falling edge (i=2)
        fprintf(h_lockin, 'ISRC 1'); % (0)Ch A input, (1) A - B
        fprintf(h_lockin, 'IGND 0'); % Floating
        fprintf(h_lockin, 'ICPL 0'); % The ICPL command sets or queries the input coupling. The parameter i selects AC (i=0) or DC (i=1).
        fprintf(h_lockin, 'ILIN 2'); % no filters (i=0), Line notch in (i=1), 2xLine notch in (i=2) or Both notch filters in (i=3)
        fprintf(h_lockin, 'RMOD 1'); %  High Reserve (i=0), Normal (i=1) or Low Noise (minimum) (i=2).
        fprintf(h_lockin, 'SENS 1'); % 
        fprintf(h_lockin, 'OFSL 3'); %Low Pass Filter at 24 db/octave
        fprintf(h_lockin, 'SYNC 1'); %synchronous filter on
        fprintf(h_lockin, 'OFLT 9'); % 300 ms time constant ??
        fprintf(h_lockin, 'DDEF 1,1,0'); % disp R and theta, no expand
        fprintf(h_lockin, 'DDEF 2,1,0'); % disp R and theta, no expand
        app.LockinLamp.Color = [0 1 0];
    catch err
        LCR_error = err.identifier
        success = 0;
    end
    
    % % Connecting to keithley 2400, if fail update connect_success
    try
        h_k2400 = gpib('KEYSIGHT',7,app.k2400AddressEditField.Value);
        set(h_lockin, 'Name', 'Keithley2400_GPIB');
        fopen(h_k2400);
        fprintf(h_k2400,':*RST'); 
        fprintf(h_k2400,':*CLS');
        fprintf(h_k2400,':SOUR:VOLT:MODE FIXED'); % Restore keithley defaults.
        fprintf(h_k2400,':SOUR:VOLT:RANG 200'); 
        fprintf(h_k2400,':SOUR:VOLT:LEV 0'); 
        app.Keithley2400Lamp.Color = [0 1 0];
    catch err
        keithley2400_error = err.message
        success = 0;
        try
            fclose(h_k2400);
            delete(h_k2400);
        catch err2
            display(err2);
        end
        h_k2400 = 0;
    end
    
    % Connecting to keithley 6221, if fail update connect_success
    try
        h_k6221 = gpib('KEYSIGHT',7,app.k6621AddressEditField.Value);
        set(h_k6221, 'Name', 'Keithley6221_GPIB');
        fopen(h_k6221);
        fprintf(h_k6221,':*RST'); 
        fprintf(h_k6221,':*CLS');
        fprintf(h_k6221,'SOUR:WAVE:FUNC SIN'); % Select sine wave..
        fprintf(h_k6221,'SOUR:WAVE:FREQ 1e3'); % Set frequency to 1kHz.
        fprintf(h_k6221,'SOUR:WAVE:AMPL 1e-9'); % Set amplitude to 10mA.
        fprintf(h_k6221,'SOUR:WAVE:OFFS 0.0'); % Set offset to 1mA.
        fprintf(h_k6221,'SOUR:WAVE:RANG BEST'); % Select best fixed source range.
        fprintf(h_k6221,'CURRent:COMPliance 10'); % Compliance 10 V
        app.Keithley6221Lamp.Color = [0 1 0];
%         fprintf(h_k6221,'CURRent:COMPliance 10'); % Compliance 10 V
    catch err
        h_gate_error = err.message
        success = 0;
        try
            fclose(h_k6221);
            delete(h_k6221);
        catch err2
            display(err2);
        end
        h_k6221 = 0;
    end
    
    % Ready to run experiment if all devices are found
    if (success) 
        app.AcquisitionPanel.Visible = 'on';
        app.GraphsPanel.Visible = 'on';
    end