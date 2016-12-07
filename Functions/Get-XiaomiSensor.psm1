#region Namespaces/Modules
using module ..\Classes\XiaomiConnection.psm1;
using module ..\Classes\XiaomiGateway.psm1;
using module ..\Classes\XiaomiSensor.psm1;
#endregion

<#
.SYNOPSIS
    Returns the sensors attached to the gateway(s)
.DESCRIPTION
    The function loops through the list of Xiaomi Gateway devices passed to it and gets the list of sensors
    attached to it. In addition, it also trys querying each sensor, to get some key information about it.
.PARAMETER Gateway
    Reference(s) to the Xiaomi Gataway instance(s)
.INPUTS
    [XiaomiGateway[]]. The list of Xiaomi Gateways
.OUTPUTS
    [XiaomiSensor[]]. The list of sensors attached to the gateway(s)
.EXAMPLE
    C:\PS> Connect-XiaomiHome | Get-XiaomiGateway | Get-XiaomiSensor | FT
    Gateway       SID            ShortID Model     RawData
    -------       ---            ------- -----     -------
    XiaomiGateway 158d0001178e6b   55693 sensor_ht @{temperature=2265; humidity=3745}
    XiaomiGateway 158d00010f7446   21438 sensor_ht @{temperature=-267; humidity=6700}
#>
Function Get-XiaomiSensor
{
    [CmdletBinding()]
    [OutputType([XiaomiSensor[]])]
    #region Parameters
    PARAM(
        # Gateway(s):
        [Parameter(
            Position = 0,
            Mandatory = $TRUE,
            ValueFromPipeline = $TRUE
        )]
        [XiaomiGateway[]]$Gateway
    )
    #endregion
    BEGIN
    {
        # Init some variables:
        [XiaomiSensor[]]$sensors = @();
    }
    PROCESS
    {
        # Loop through all the gateways:
        ForEach ($_gateway in $Gateway) {
            # Try getting the list of sensors:
            Try {
                # Set the endpoints:
                $endpoint = [XiaomiConnection]::CreateEndpoint($_gateway.IP, $_gateway.Port);
                $_gateway.Connection.Send($endpoint, @{cmd = 'get_id_list'});
                $data = $_gateway.Connection.Receive();
                $token = $data.token;
                # Loop through the sensors:
                ForEach ($sensor in $data.data) {
                    # Try query for the sensor information:
                    $_gateway.Connection.Send($endpoint, @{cmd = 'read'; sid = $sensor});
                    $data = $_gateway.Connection.Receive();
                    # Add the sensor to the list:
                    $sensors += [XiaomiSensor]::New($_gateway, $data.sid, $data.model, $data.short_id, `
                        $token, $data.data);
                }
            # Failed getting the sensors; moving to the next gateway:
            } Catch {
                Write-Warning -Message "Cannot get the list of sensors attached to '$($_gateway.SID)' gateway";
                Continue;
            }
        }
    }
    END
    {
        # In case no sensors were found:
        If ($sensors.Length -EQ 0) {
            Write-Error `
                -Category ProtocolError `
                -Message "No sensors attached to any of the gateways were found" `
                -RecommendedAction "Make sure the gateway(s) has sensors connected";
            Return;
        # Otherwise, return the sensors:
        } Else {
            Return [XiaomiSensor[]]$sensors;
        }
    }
}