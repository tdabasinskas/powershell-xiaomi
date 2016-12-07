#region Namespaces/Modules
using module .\XiaomiGateway.psm1;
#endregion

<#
.SYNOPSIS
    The class stores information about a Xiaomi sensor
.DESCRIPTION
    The class acts as a container to store the key information about devices (sensors) connected to the Xiaomi
    Gateway. It also contains a reference to the Xiaomi Gateway, to which the sensor is connected to.
#>
Class XiaomiSensor
{
    #region Properties
    # Reference to Xiaomi Gateway instance
    [XiaomiGateway]$Gateway;
    # Sensor SID (ID)
    [String]$SID;
    # Short ID of the sensor
    [Int]$ShortID;
    # Sensor model (type)
    [String]$Model;
    # Authentication token:
    [String]$Token;
    # Current raw value provided by the sensor at the time of quering
    [PSObject]$RawData
    #endregion

    #region Constructors
    <#
    .SYNOPSIS
        Class constructor, which captures the sensor information
    .PARAMETER gateway
        Reference to Xiaomi Gateway instance
    .PARAMETER SID
        Sensor SID (ID)
    .PARAMETER model
        Sensor model (type)
    .PARAMETER shortID
        Short ID of the sensor
    .PARAMETER token
        Authentication token
    .PARAMETER rawData
        Current raw value provided by the sensor at the time of quering
    #>
    XiaomiSensor([XiaomiGateway]$gateway, [String]$SID, [String]$model, [Int]$shortID, [String]$token, `
        [PSObject]$rawData)
    {
        # Assignt the values:
        $This.Gateway = $gateway;
        $This.SID = $SID;
        $This.Model = $model;
        $This.ShortID = $shortID;
        $This.Token = $token;
        $This.RawData = $rawData;
    }
    #endregion
}