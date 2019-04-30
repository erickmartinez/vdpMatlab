function relayPosition0(a)
%relayPosition0
%   Turns the relays off
%   Parameters
%   ----------
%   app : obj
%       A handle to the arduino instance
    pins = "D" + (2:5);
    for i=1:4
        configurePin(a,pins(i),'Unset');
    end
    pause(10);
end

