function relayPosition1(a)
%relayPosition1
%   Turns the relays off
%   Parameters
%   ----------
%   app : obj
%       A handle to the arduino instance
    pins = "D" + (2:5);
    for i=1:4
        writeDigitalPin(a,pins(i),0);
    end
    pause(10);
end