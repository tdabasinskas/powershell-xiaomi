#region Namespaces/Modules
using module ..\Classes\XiaomiConnection.psm1;
using module ..\Classes\XiaomiGateway.psm1;
#endregion

<#
.SYNOPSIS
    Contacts the gateway(s) and gets their information
.DESCRIPTION
    The function sends a broadcast message to detect all reachable Xiaomi Gateway devices on the network. Together
    with other information, such as SID, we also receive each gateway's IP address, which will be requried to send
    other commands and interact with sensors later.
.PARAMETER connection
    Reference to an existing connection
.INPUTS
    [XiaomiConnection]. Connection object
.OUTPUTS
    [XiaomiGateway[]]. Single or multiple gateway objects
.EXAMPLE
    C:\PS> Connect-XiaomiHome | Get-XiaomiGateway;
    Connection       SID          IP        Port
    ----------       ---          --        ----
    XiaomiConnection f0b429b43e53 10.1.3.10 9898
#>
Function Get-XiaomiGateway
{
    [CmdletBinding()]
    [OutputType([XiaomiGateway[]])]
    #region Parameters
    PARAM(
        # Exiting connection:
        [Parameter(
            Position = 0,
            Mandatory = $TRUE,
            ValueFromPipeline = $TRUE
        )]
        [XiaomiConnection]$Connection
    )
    #endregion
    PROCESS
    {
        # Initiate some variables:
        [XiaomiGateway[]]$gateways = @();
        # Set the endpoints:
        $endpoint = [XiaomiConnection]::CreateEndpoint($Connection.MulticastGroup, $Connection.MulticastPeerPort);
        # Try sending WHOIS command and getting the response:
        Try {
            $Connection.Send($endpoint, @{cmd = 'whois'});
            $data = $Connection.Receive();
            # Return the information about the gateway(s):
            ForEach ($gateway in $data) {
                $gateways += [XiaomiGateway]::New($Connection, $data.sid, [IPAddress]::Parse($data.ip), $data.port);
            }
            Return $gateways;
        # Failed sending the command or receiving the response:
        } Catch {
            Write-Error `
                -Category ProtocolError `
                -Message "Failed to get information about the gateway(s)" `
                -RecommendedAction "Make sure the gateway(s) are powered on, reachable and have developer mode `
                    enabled";
            Return;
        }
    }
}