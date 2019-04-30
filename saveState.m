function saveState(app)
    state.Path      = app.DirectoryTextArea.Value;
    state.FileTag   = app.FileTagEditField.Value;
    state.Freq      = app.FrequencyHzEditField.Value;
    state.Amplitude = app.AmplitudeAEditField.Value;
    state.Averages  = app.AveragesEditField.Value;
    state.Gated     = app.GateSwitch.Value;
    state.BiasStart = app.VgstartVEditField.Value;
    state.BiasStop  = app.VgendVEditField.Value;
    state.BiasStep  = app.VgstepVEditField.Value;
    state.Cycles    = app.CyclesEditField.Value;
	state.Reverse   = app.ReverseSwitch.Value;
    state.Time      = app.TimesEditField.Value;
    save('state.mat','state');
end
    