function DisconnectDevices(app)
    instrreset;
%     a = arduino();
%     clear all;
    app.AcquisitionPanel.Visible = 'off';
    app.GraphsPanel.Visible = 'off';
    app.Keithley6221Lamp.Color = [0.149 0.149 0.149];
    app.Keithley2400Lamp.Color = [0.149 0.149 0.149];
    app.LockinLamp.Color = [0.149 0.149 0.149];
    app.ArduinoLamp.Color = [0.149 0.149 0.149];