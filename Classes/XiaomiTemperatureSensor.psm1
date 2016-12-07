#region Namespaces/Modules
using module .\XiaomiGateway.psm1;
using module .\XiaomiSensor.psm1;
#endregion

<#
.SYNOPSIS
    The class acts as a container, which stores information provided by a temperature sensor
.DESCRIPTION
    The class extends the general sensor container with an additional data, which is applicable only for
    Xiaomi Temperature sensors, in this case, the temperature (in Celcius and Fahrenheit) and humidity (in %).
#>
Class XiaomiTemperatureSensor: XiaomiSensor
{
    #region Properties
    # Temperature in Celcius
    [Float]$TemperatureC;
    # Temperature in Fahrenheit
    [Float]$TemperatureF;
    # Humidity
    [Float]$Humidity;
    #endregion

    #region Constructors
    <#
    .SYNOPSIS
        Class constructor, which calculates the temperature and humidity based on the data provided by the device
    .PARAMETER gateway
        Reference to Xiaomi Gateway instance
    .PARAMETER SID
        Sensor SID (ID)
    .PARAMETER model
        Sensor model (type)
    .PARAMETER shortID
        Short ID of the sensor
    .PARAMETER token
        Authenticaiton token
    .PARAMETER rawData
        Current raw value provided by the sensor at the time of quering
    #>
    XiaomiTemperatureSensor([XiaomiGateway]$gateway, [String]$SID, [String]$model, [Int]$shortID, [String]$token, `
        [PSObject]$rawData): base($gateway, $SID, $model, $shortID, $token, $rawData)
    {
        # Get temperature in Celcius:
        $This.TemperatureC = $rawData.temperature / 100;
        # Convert the temperature to Fahrenheit:
        $This.TemperatureF = $This.TemperatureC * 9 / 5 + 32;
        # Get humidity:
        $This.Humidity = $rawData.humidity / 100;
    }
    #endregion
}