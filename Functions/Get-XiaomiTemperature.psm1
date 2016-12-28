#region Namespaces/Modules
using module ..\Classes\XiaomiSession.psm1;
using module ..\Classes\XiaomiGateway.psm1;
using module ..\Classes\XiaomiSensor.psm1;
using module ..\Classes\XiaomiTemperatureSensor.psm1;
#endregion

<#
.SYNOPSIS
    Returns data from temperature sensors
.DESCRIPTION
    The function queries the provided temperature sensors to get the temperature (both C and F) and humidity
    information.
.PARAMETER Sensor
    The list on sensors that we would like to get the temperature data from
.INPUTS
    [XiaomiSensor[]]. The list of Xiaomi sensors
.OUTPUTS
    [XiaomiTemperatureSensor[]]. Temperature data from each thermometer sensor
.EXAMPLE
    C:\PS> Connect-XiaomiSession | Get-XiaomiGateway | Get-XiaomiSensor | Get-XiaomiTemperature | FT
        SID            ShortID TemperatureC TemperatureF Humidity Gateway
    ---            ------- ------------ ------------ -------- -------
    158d0001178e6b   55693        22.65        72.77    37.45 XiaomiGateway
    158d00010f7446   21438        -3.18       26.276    68.56 XiaomiGateway
#>
Function Get-XiaomiTemperature
{
    [CmdletBinding()]
    [OutputType([XiaomiTemperatureSensor[]])]
    #region Parameters
    PARAM(
        # Sensor(s):
        [Parameter(
            Position = 0,
            Mandatory = $TRUE,
            ValueFromPipeline = $TRUE
        )]
        [XiaomiSensor[]]
        $Sensor
    )
    #endregion
    BEGIN
    {
        # Init some variables:
        [XiaomiTemperatureSensor[]]$thermometers = @();
    }
    PROCESS
    {
        # Make sure we look only into temperature sensors instead of all the devices passed:
        $Sensor = $Sensor | Where-Object { $_.Model -EQ 'sensor_ht'};
        # Loop through all the thermometers:
        ForEach($_sensor in $Sensor) {
            # Try getting the temperature data:
            Try {
                # Set the endpoints:
                $endpoint = [XiaomiSession]::CreateEndpoint($_sensor.Gateway.IP, $_sensor.Gateway.Port);
                $_sensor.Gateway.Connection.Send($endpoint, @{cmd = 'read'; sid = $_sensor.SID});
                $data = $_sensor.Gateway.Connection.Receive();
                $thermometers += [XiaomiTemperatureSensor]::New($_sensor.Gateway, $data.sid, $data.model,
                    $data.short_id, $sensor.Token, $data.data);
            # Couldn't get information from the temperature sensor; moving to the next one:
            } Catch {
                Write-Warning -Message ("Cannot get temperature data from '$($_sensor.SID)' sensor, connected to "`
                    + "'$($_sensor.Gateway.SID)' gateway");
                Continue;
            }
        }
    }
    END
    {
        # In case ther is no data:
        If ($thermometers.Length -EQ 0) {
            Write-Error `
                -Category ProtocolError `
                -Message "No temperature data was found" `
                -RecommendedAction "Make sure you have temperature sensors connected to the gateway(s)";
            Return;
        # Otherwise, return the temperature data:
        } Else {
            Return ($thermometers | Select-Object SID, ShortID, TemperatureC, TemperatureF, Humidity, Gateway);
        }
    }
}