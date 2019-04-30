function [humidityPercent,TempC] = DHT_Read(app)
    dht = app.dht;
    humidityPercent = app.relativeHumidity;
    TempC = app.temperature;
    out = app.dht.readDHT;
    if out == 0
        humidityPercent = dht.readHumidity;
        TempC = dht.readTemperature;
    end
    app.relativeHumidity = humidityPercent;
    app.temperature = TempC;
end