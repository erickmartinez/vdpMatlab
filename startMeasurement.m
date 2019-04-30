function startMeasurement(app)
    if strcmp(app.StartButton.Text,'Start') % Start button won't respond if mapping is running
        app.acquisitionFlag = 1;
        path = app.DirectoryTextArea.Value;
        if (strcmp(path,'') || isempty(path))
            app.acquisitionFlag = 0;
            warndlg('Choose a directory to save the output');
        end
        filetag = app.FileTagEditField.Value;
        if (strcmp(filetag,'') || isempty(filetag))
            app.acquisitionFlag = 0;
            warndlg('Choose a file tag to save the output');
        end
        
        
        
        if app.acquisitionFlag == 1
            app.StatusLamp.Color = [0 1 0];
            app.stopFlag = 0;
            app.StartButton.Text  = 'Running';
            app.IdleLampLabel.Text = 'Running';
            app.StartButton.BackgroundColor = [0 1 0];
            
            cla(app.RVAxes);
            app.SweeprateVsEditField.Value = 0;
            app.ROhmsEditField.Value = 0;
            app.ElapsedtimesEditField.Value = 0;
            
            ac_freq      = app.FrequencyHzEditField.Value;
            ac_amplitude = app.AmplitudeAEditField.Value;
            averages     = app.AveragesEditField.Value;
            ac_offset    = 0.0; % V
            ac_amp_err   = ac_amplitude*0.034e-2;
            cycle_delay  = 1;

            
            if strcmp(app.GateSwitch.Value,'On')
                biasStart    = app.VgstartVEditField.Value;
                biasEnd      = app.VgendVEditField.Value;
                biasStep     = app.VgstepVEditField.Value;
                reverse      = app.ReverseSwitch.Value;
                NCYCLES      = app.CyclesEditField.Value;
                
                r_line_color   = NaN(NCYCLES,3);
                
                dcolor = 1./NCYCLES;
                for i=1:NCYCLES
                    r_line_color(i,1) = 0;
                    r_line_color(i,2) = 0.75*(1-dcolor*i);
                    r_line_color(i,3) = 0.75*(0+dcolor*i);
                end
                
                hold(app.RVAxes,'on');

                step      = (biasEnd-biasStart)/abs(biasEnd-biasStart)*biasStep;
                forwardV  = biasStart:step:biasEnd;
                reverseV  = (biasEnd-step):(-step):biasStart;
                if strcmp(reverse,'On')
                    Vg = [forwardV,reverseV];
                    timeMultiplier = 2;
                else
                    Vg = forwardV;
                    timeMultiplier = 1;
                end
                
                NPOINTS   = length(Vg);
                
                k6221_ConfigCurrent(app,ac_freq,ac_amplitude,ac_offset);
                k6221_TurnCurrentOn(app);            
%                 writeDigitalPin(app.handle_arduino,'A0',0);
                relayPosition0(app.handle_arduino);

                % Configure the Lock-in amp
                SRS_timeconstant = lockin_SetTimeConstant(app,ac_freq);
                k2400_TurnVgOn(app,0.0);
                lockin_SetSensibility(app,SRS_timeconstant);
                pause(5*SRS_timeconstant);
                fprintf(app.handle_lockin, 'APHS');
                pause(5*SRS_timeconstant);

                % Get the ratio of R_12,34 to R_23,41
                piln2 = pi/log(2);
                [leakage,V1234,V1234_err,phase_1234,freq_1234] ...
                        = lockin_ReadVoltage(app,0,50,SRS_timeconstant);
                % Change the relay with arduino
                relayPosition1(app.handle_arduino);
                [leakage,V2341,V2341_err,phase_2341,freq_2341] ...
                        = lockin_ReadVoltage(app,0,50,SRS_timeconstant);
                R1234 = piln2*abs(V1234/ac_amplitude);
                R2341 = piln2*abs(V2341/ac_amplitude);
                ratio_ab    = R1234/R2341;
                F           = vanDerPauwF(R1234,R2341);
                sprintf('R1234 = %.4f',R1234)
                sprintf('R2341 = %.4f',R2341)
                sprintf('F = %.4f',F)
                
                fprintf(app.handle_k2400,':SENSe:CURRent:NPLC 0.01');
                fprintf(app.handle_k2400,':SENSe:VOLTage:NPLC 0.01');
%                 writeDigitalPin(app.handle_arduino,'A0',0);
                relayPosition0(app.handle_arduino);
                
                
%                 totalCyclingTime    = NCYCLES*NPOINTS*cycle_delay;
%                 TOTAL_TSTEPS        = NCYCLES*NPOINTS;
%                 fullTime            = linspace(0,totalCyclingTime,TOTAL_TSTEPS);
%                 fullCounter         = 1;
                
                
                
                
                for j=1:NCYCLES
                    maxTime     = SRS_timeconstant*NPOINTS*averages*2;
                    RA          = NaN(1,NPOINTS);
                    RA_err      = NaN(1,NPOINTS);
                    RB          = NaN(1,NPOINTS);
                    RB_err      = NaN(1,NPOINTS);
                    rho         = NaN(1,NPOINTS);
                    rho_err     = NaN(1,NPOINTS);
                    G           = NaN(1,NPOINTS);
                    G_err       = NaN(1,NPOINTS);
                    freq_A      = NaN(1,NPOINTS);
                    phase_A     = NaN(1,NPOINTS);
                    eTime       = linspace(0,maxTime,timeMultiplier*NPOINTS);
                    VA          = NaN(1,NPOINTS);
                    VA_err      = NaN(1,NPOINTS);
                    leakage_A   = NaN(1,NPOINTS);
                    

                    app.DatapointEditField.Value = sprintf('%d / %d',0,NPOINTS);
                    app.VgVEditField.Value = 0.0;

                    app.RVAxes.XLabel.String = 'Vg (V)';

                    plot_rho  = errorbar(app.RVAxes,Vg,rho,rho_err,'o-','Color',[r_line_color(j,1),r_line_color(j,2),r_line_color(j,3)]);
                    plot_rho.YDataSource = 'rho';
                    plot_rho.LDataSource = 'rho_err';
                    plot_rho.UDataSource = 'rho_err';
                    
                  

                    if j == 1
                        fprintf(app.handle_k2400,':SOUR:VOLT:LEV %.3E',Vg(1)); % Source output level
                        pause(5);
                    end


                    timeStamp = TimeStamp;
                    totTime = 0;                 
                    
                
                    for i=1:NPOINTS
                        eTime(i) = totTime;
%                         fullTime(fullCounter) = totTime;
                        
                        tstart = tic;
                        app.DatapointEditField.Value = sprintf('%d / %d',i,NPOINTS);
                        app.VgVEditField.Value = Vg(i);

                        app.ElapsedtimesEditField.Value = totTime;
                        % Read the voltage from the lockin
                        [leakage_A(i),VA(i),VA_err(i),phase_A(i),freq_A(i)] ...
                            = lockin_ReadVoltage(app,Vg(i),averages,SRS_timeconstant);
                        
                        
                        RA(i) = piln2*abs(VA(i)/ac_amplitude);
                        RA_err(i) = RA(i)*norm([ac_amp_err/ac_amplitude,VA_err(i)/VA(i)]);
                        RB(i) = RA(i)*ratio_ab;
                        RB_err(i) = RA_err(i)*ratio_ab;

                        app.IleakageAEditField.Value = leakage_A(i);
                        rho(i)      = (RA(i)+RB(i))*F/2.0;
                        rho_err(i)  = norm([RA_err(i),RB_err(i)])*F/2.0;

                        app.ROhmsEditField.Value = rho(i);

                        pause(0.00001);

                        eElapsed = toc(tstart);
                        totTime  = totTime + eElapsed;
                        app.SweeprateVsEditField.Value = abs(step)/eElapsed;

                        refreshdata(plot_rho,'caller');
                        drawnow %limitrate
%                         fullCounter = fullCounter + 1;

                        if app.stopFlag ~= 0
                            break;
                        end

                    end % for i=1:NPOINTS
                    
                    eTime       = linspace(0,totTime,timeMultiplier*NPOINTS);
                    
                    G        = 1./rho;
                    G_err    = G.*rho_err./rho;

                    %%%%%%% SAVE DATA %%%%%%%%
                    if ~isnan(rho(NPOINTS))
                        fulltag = strcat(filetag,'-',TimeStamp);
                        saveFigureRho(app,fulltag,Vg,rho,rho_err);

                        %% Save the configuration %%
                        state.Path      = app.DirectoryTextArea.Value;
                        state.FileTag   = app.FileTagEditField.Value;
                        state.Freq      = app.FrequencyHzEditField.Value;
                        state.Amplitude = app.AmplitudeAEditField.Value;
                        state.Averages  = app.AveragesEditField.Value;
                        state.Gated     = app.GateSwitch.Value;
                        state.BiasStart = app.VgstartVEditField.Value;
                        state.BiasStop  = app.VgendVEditField.Value;
                        state.BiasStep  = app.VgstepVEditField.Value;
                        state.Reverse   = app.ReverseSwitch.Value;
                        state.Time      = app.TimesEditField.Value;
                        save('state.mat','state');

                        save(fulltag,'Vg','VA','VA_err','RA','RA_err','freq_A','phase_A','leakage_A',...
                            'RB','RB_err','rho','rho_err','G','G_err','eTime','F',...
                            'timeStamp','state');

                        fullFname = sprintf('%s.mat',fulltag);

                        if (strcmp(path,pwd) == 0)
                            movefile(fullFname,string(path),'f');
                            movefile(strcat(fulltag,'.png'),string(path),'f');
                            movefile(strcat(fulltag,'.fig'),string(path),'f');
                        end
                    end % isnan(rho(NPOINTS))
                    if app.stopFlag ~= 0
                        break;
                    end
                    pause(cycle_delay);
                end % for j=1:NCYCLES
                hold(app.RVAxes,'off');
                k6221_TurnCurrentOff(app);  
                k2400_TurnVgOff(app);
            else % if strcmp(app.GateSwitch.Value,'Off')
                
                maxTime     = app.TimesEditField.Value;
                timeStep    = app.TimestepsEditField.Value;
                eTime       = 0:timeStep:maxTime;
                NPOINTS     = length(eTime);
                
                RA          = NaN(1,NPOINTS);
                RA_err      = NaN(1,NPOINTS);
                RB          = NaN(1,NPOINTS);
                RB_err      = NaN(1,NPOINTS);
                rho         = NaN(1,NPOINTS);
                rho_err     = NaN(1,NPOINTS);
                G           = NaN(1,NPOINTS);
                G_err       = NaN(1,NPOINTS);
                freq_A      = NaN(1,NPOINTS);
                phase_A     = NaN(1,NPOINTS);
                
                VA          = NaN(1,NPOINTS);
                VA_err      = NaN(1,NPOINTS);
                
                app.DatapointEditField.Value = sprintf('%d / %d',0,NPOINTS);
                app.VgVEditField.Value = 0.0;
                app.SweeprateVsEditField.Value = 0.0;
                app.IleakageAEditField.Value = 0.0;

                app.RVAxes.XLabel.String = 'Time (s)';
                
                plot_rho  = errorbar(app.RVAxes,eTime,rho,rho_err,'o-');
                plot_rho.YDataSource = 'rho';
                plot_rho.LDataSource = 'rho_err';
                plot_rho.UDataSource = 'rho_err';
                
               

                k6221_ConfigCurrent(app,ac_freq,ac_amplitude,ac_offset);
                k6221_TurnCurrentOn(app);            
                relayPosition0(app.handle_arduino);

                SRS_timeconstant = lockin_SetTimeConstant(app,ac_freq);
%                 k2400_TurnVgOn(app,0.0);
                lockin_SetSensibility(app,SRS_timeconstant);
                pause(5*SRS_timeconstant);
                fprintf(app.handle_lockin, 'APHS');
                pause(5*SRS_timeconstant);

                % Get the ratio of R_12,34 to R_23,41
                piln2 = pi/log(2);
                [V1234,V1234_err,phase_1234,freq_1234] ...
                        = lockin_ReadVoltage_ZeroBias(app,50,SRS_timeconstant);
                % Change the relay with arduino
%                 writeDigitalPin(app.handle_arduino,'A0',1);
                relayPosition1(app.handle_arduino);
                [V2341,V2341_err,phase_2341,freq_2341] ...
                        = lockin_ReadVoltage_ZeroBias(app,50,SRS_timeconstant);
                R1234 = piln2*abs(V1234/ac_amplitude);
                R2341 = piln2*abs(V2341/ac_amplitude);
                ratio_ab    = R1234/R2341;
                F           = vanDerPauwF(R1234,R2341);
                sprintf('R1234 = %.4f',R1234)
                sprintf('R2341 = %.4f',R2341)
                sprintf('F = %.4f',F)

%                 writeDigitalPin(app.handle_arduino,'A0',0);
                relayPosition0(app.handle_arduino);
                pause(5);


                timeStamp = TimeStamp;
                totTime = 0;
                for i=1:NPOINTS
                    eTime(i) = totTime;
                    tstart = tic;
                    app.DatapointEditField.Value = sprintf('%d / %d',i,NPOINTS);
                    app.VgVEditField.Value = 0.0;

                    app.ElapsedtimesEditField.Value = totTime;
                    
                    % Read the voltage from the lockin
                    [VA(i),VA_err(i),phase_A(i),freq_A(i)] ...
                    
                    RA(i) = piln2*abs(VA(i)/ac_amplitude);
                    RA_err(i) = RA(i)*norm([ac_amp_err/ac_amplitude,VA_err(i)/VA(i)]);
                    RB(i) = RA(i)*ratio_ab;
                    RB_err(i) = RA_err(i)*ratio_ab;

                    rho(i)      = (RA(i)+RB(i))*F/2.0;
                    rho_err(i)  = norm([RA_err(i),RB_err(i)])*F/2.0;

                    
                    app.ROhmsEditField.Value = rho(i);
                    
                    refreshdata(plot_rho,'caller');
                    pause(timeStep-toc(tstart));
                    eElapsed = toc(tstart);
                    totTime  = totTime + eElapsed;
                    if app.stopFlag ~= 0
                        break;
                    end
                end % for i=1:NPOINTS
                
                k6221_TurnCurrentOff(app);  
                
                G        = 1./rho;
                G_err    = G.*rho_err./rho;
                
                %%%%%%% SAVE DATA %%%%%%%%
                if ~isnan(rho(NPOINTS))
                    fulltag = strcat(filetag,'-',TimeStamp);
                    saveFigureRho(app,fulltag,eTime,rho,rho_err);
                    %% Save the configuration %%
                    state.Path      = app.DirectoryTextArea.Value;
                    state.FileTag   = app.FileTagEditField.Value;
                    state.Freq      = app.FrequencyHzEditField.Value;
                    state.Amplitude = app.AmplitudeAEditField.Value;
                    state.Averages  = app.AveragesEditField.Value;
                    state.Gated     = app.GateSwitch.Value;
                    state.BiasStart = app.VgstartVEditField.Value;
                    state.BiasStop  = app.VgendVEditField.Value;
                    state.BiasStep  = app.VgstepVEditField.Value;
                    state.Reverse     = app.ReverseSwitch.Value;
                    state.Time      = app.TimesEditField.Value;
                    save('state.mat','state');

                    save(fulltag,'VA','VA_err','RA','RA_err','freq_A','phase_A',...
                        'RB','RB_err','rho','rho_err','G','G_err','eTime','F',...
                        'timeStamp','state');

                    fullFname = sprintf('%s.mat',fulltag);

                    if (strcmp(path,pwd) == 0)
                        movefile(fullFname,string(path),'f');
                        movefile(strcat(fulltag,'.png'),string(path),'f');
                        movefile(strcat(fulltag,'.fig'),string(path),'f');
                    end
                end % isnan(rho(NPOINTS))
            end % if strcmp(app.GateSwitch.Value,'On')
            
            if strcmp(app.StartButton.Text, 'Running')
                app.StartButton.Text = 'Start';
                app.StartButton.BackgroundColor = [0.96 0.96 0.96];
                app.StatusLamp.Color = [0.8 0.8 0.8];
                app.IdleLampLabel.Text = 'Idle';
            end
            
        end % if app.acquisitionFlag == 1
        
    end % strcmp(app.StartButton.Text,'Start')