#region Namespaces/Modules
using namespace System.Net;
using namespace System.Net.Sockets;

using module ..\Classes\XiaomiConnection.psm1;
#endregion

<#
.SYNOPSIS
    Initializes and returns a connection with Xiaomi Smart Home network
.DESCRIPTION
    The function creates a local UDP server, which is going to be used to interact with the Xiaomi Gateway device,
    as well as all the sensors. The local server joins the same multicast group as the gateway device, as the
    initial gateway discovery is being done via multicast.
.PARAMETER MulticastGroup
    The multicast group, to which the newly created UDP server should join. If not specified, 224.0.0.50 is used,
    as per Xiaomi documentation
.PARAMETER MulticastPeerPort
    The number of multicast peer port, required for sending the initial message to the gateways on the network.
    If not specified, 4321 is used, as per Xiaomi documentation
.PARAMETER LocalPort
    The number of the UDP port, which is going to be used to listen on the local computer. If not specified, 9882
    is used, as per Xiaomi documentation
.OUTPUTS
    [XiaomiConnection]. An object, containing information about the initialized connection
.EXAMPLE
    C:\PS> Connect-XiaomiHome
    Socket            : System.Net.Sockets.UdpClient
    IsAlive           : True
    LocalPort         : 9882
    LocalEndpoint     : 0.0.0.0:9882
    MulticastGroup    : 224.0.0.50
    MulticastPeerPort : 4321
#>
Function Connect-XiaomiHome
{
    [CmdletBinding()]
    [OutputType([XiaomiConnection])]
    #region Parameters
    PARAM(
        # Multicast group:
        [Parameter(
            Position = 0,
            Mandatory = $FALSE
        )]
        [String]$MulticastGroup = '224.0.0.50',
        # Multicast peer port:
        [Parameter(
            Position = 1,
            Mandatory = $FALSE
        )]
        [ValidateRange(0, 65534)]
        [Int]$MulticastPeerPort = 4321,
        # Local port:
        [Parameter(
            Position = 2,
            Mandatory = $FALSE
        )]
        [ValidateRange(0, 65534)]
        [Int]$LocalPort = 9882
    )
    #endregion
    PROCESS
    {
        # Make sure the local port is not in use:
        If (-NOT ($NULL -EQ ($process = [XiaomiConnection]::CheckIfPortIsInUse($LocalPort)))) {
            Write-Error `
                -Category ConnectionError `
                -Message ("Cannot establish connection, because UDP port "` +
                    "$($LocalPort) is already in use by '$($process.ProcessName)' ($($process.ID))") `
                -RecommendedAction "Try closing '$($process.ProcessName)' and reruning the cmdlet";
            Return;
        }
        # Try to parse the Multicast Group as a real IP address:
        Try {
            $MulticastGroupAddress = [IpAddress]::Parse($MulticastGroup);
        } Catch {
            Write-Error `
                -Category InvalidType `
                -Message "Cannot parse multicast group '$($MulticastGroup)' as an IP address" `
                -RecommendedAction "Make sure the provided mutlicast group IP is correct";
            Return;
        }
        # Try creating UDP server and joining it to the multicast group:
        Try {
            $socket = New-Object -TypeName UdpClient -ArgumentList $LocalPort;
            $socket.JoinMulticastGroup($MulticastGroupAddress);
             # Set timeouts to avoid it freezing for too long:
            $socket.Client.SendTimeout = 5000;
            $socket.Client.ReceiveTimeout = 5000;
        } Catch {
            Write-Error `
                -Category ProtocolError `
                -Message "Cannot create a local UDP server under $($LocalPort) port" `
                -RecommendedAction ("Make sure the port is not in use, the multicast group is correct and you "` +
                    "have sufficient permissions to perform the operation");
            Return;
        }
        # Return the connection object:
        Return [XiaomiConnection]::New($socket, $LocalPort, $MulticastGroupAddress, $MulticastPeerPort);
    }
}