function [ovld] = lockin_GetOverload(app)
    fprintf(app.handle_lockin,'LIAS? 0');
    rsrvinovld = int16(str2double(fscanf(app.handle_lockin)));
    pause(1e-5);
    fprintf(app.handle_lockin,'LIAS? 1');
    fltrovld = int16(str2double(fscanf(app.handle_lockin)));
    pause(1e-5);
    fprintf(app.handle_lockin,'LIAS? 2');
    outovld = int16(str2double(fscanf(app.handle_lockin)));
    ovld = 0;
    if (rsrvinovld == 0 && fltrovld == 0 && outovld==0)
        ovld = 0;
    else
        ovld = 1;
    end
    % clear the LIAS byte
    fprintf(app.handle_lockin,'LIAS?');
    lias = fscanf(app.handle_lockin);
end
