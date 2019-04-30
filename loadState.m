function loadState(app)
    fileName = 'state.mat';
    if exist(fileName)
        load(fileName);
        if strcmp(state.Path,'')
            app.DirectoryTextArea.Value = pwd;
        else
            app.DirectoryTextArea.Value     = state.Path;
        end
        app.FileTagEditField.Value      = state.FileTag;
        app.FrequencyHzEditField.Value  = state.Freq ;
        app.AmplitudeAEditField.Value   = state.Amplitude;
        app.AveragesEditField.Value     = state.Averages;
        app.GateSwitch.Value            = state.Gated;
        app.VgstartVEditField.Value     = state.BiasStart;
        app.VgendVEditField.Value       = state.BiasStop;
        app.VgstepVEditField.Value      = state.BiasStep;
		app.CyclesEditField.Value		= state.Cycles;
		app.ReverseSwitch.Value			= state.Reverse;
        app.TimesEditField.Value        = state.Time;
        if strcmp(app.GateSwitch.Value,'On')
            app.MeasurementTypeTabGroup.SelectedTab = app.GatedTab;
        else
            app.MeasurementTypeTabGroup.SelectedTab = app.UngatedTab;
        end
        delete(fileName);
    end
end