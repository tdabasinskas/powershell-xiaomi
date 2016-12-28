#region Namespaces/Modules
using namespace System.Text;
using namespace System.Net;
using namespace System.Net.Sockets;
using namespace System.Diagnostics;
#endregion

<#
.SYNOPSIS
    A class to connect and interact with Xiaomi Home devices on the network
.DESCRIPTION
    The class stores required network configuration (ports, multicast IP addresses etc.) that it uses to set up a
    local UDP server. The server is used to communicate (send commands and receive responses) with multiple Xiaomi
    Gateway devices, as well as the sensors attached to them.
#>
Class XiaomiSession
{
    #region Properties
    # UDP socket instance
    [UdpClient]$Socket;
    # Socket status (is is active?)
    [Bool]$IsAlive;
    # Local endpoint:
    [IPEndpoint]$LocalEndpoint;
    # Multicast group, which Xiaomi devices belong to
    [IPAddress]$MulticastGroup;
    # The multicast peer port, used for Xiaomi gateway discovery
    [Int]$MulticastPeerPort;
    #endregion

    #region Constructors
    <#
    .SYNOPSIS
        Class constructor, responsible for initating the default values
    .PARAMETER socket
        UDP socket instance
    .PARAMETER localPort
        The UDP port to be used to listen on the local computer
    .PARAMETER multicastGroup
        Multicast group, which Xiaomi devices belong to
    .PARAMETER multicastPeerPort
        The multicast peer port, used for Xiaomi gateway discovery
    #>
    XiaomiSession([UdpClient]$socket, [String]$localIP, [Int]$localPort, [IPAddress]$multicastGroup,
        [Int]$multicastPeerPort)
    {
        $This.Socket = $socket;
        $This.MulticastGroup = $multicastGroup;
        $This.MulticastPeerPort = $multicastPeerPort;
        $This.IsAlive = $TRUE;
        # Try parse the IP address or use ANY if it fails:
        Try {
            $localIPAddress = [IpAddress]::Parse($localIP);
        } Catch {
            $localIPAddress = [IPAddress]::Any;
        }
        # Create the endpoint:
        $This.LocalEndpoint = [XiaomiSession]::CreateEndpoint($localIPAddress, $localPort);
    }
    #endregion

    #region Methods
    <#
    .SYNOPSIS
        Receive information send to the local UDP server
    .OUTPUTS
        [System.Management.Automation.PSObject]. Data received on the server
    #>
    [PSObject] Receive()
    {
        # Read data from the socket:
        $bytes = $This.Socket.Receive([Ref]$This.LocalEndpoint);
        # Convert the received data to a JSON string:
        $data = [Encoding]::ASCII.GetString($bytes);
        # Parse the data as JSON object:
        $data = $data | ConvertFrom-Json;
        # Do we have nested data object:
        If ($data.PSobject.Properties.name -Match 'data') {
            # Convert it from JSON to object as well:
            $data.data = $data.data | ConvertFrom-Json;
        }
        Return ($data);
    }

    <#
    .SYNOPSIS
        Sends data to a remote endpoint (Xiaomi Gateway or a sensor)
    .PARAMETER endpoint
        Endpoint of the remote device, to which the data should be sent to
    .PARAMETER data
        Data, which needs to be send to the deive
    .OUTPUTS
        [Void]. The method does not return anything
    #>
    [Void] Send([IPEndPoint]$endpoint, $data)
    {
        # Convert the command to JSON format:
        $data = (($data | ConvertTo-Json) -Replace '[\r\n\t]','') -Replace '\s+','';
        # Convert the command to bytes:
        $bytes = [Encoding]::ASCII.GetBytes($data);
        # Send the command:
        $This.Socket.Send($bytes, $bytes.Length, $endpoint) | Out-Null;
    }
    #endregion

    #region Static Methods
    <#
    .SYNOPSIS
        Static function to check if the specified UDP port is already in use and, if so, who uses it
    .PARAMETER port
        Number of the UDP port which we want to check for being in use
    .OUTPUTS
        [System.Diagnostics.Process]. Object with the information about the process using the port
    #>
    static [Process] CheckIfPortIsInUse([Int]$port)
    {
        # Get NETSTAT output with all UDP ports and parse it:
        $netstat = (NETSTAT -aonp UDP);
        $endpoints  = $netstat[4..$netstat.length] | ConvertFrom-String;
        # Search for the specific port:
        $inUse = $endpoints | Where-Object {$_.P3 -LIKE "*:$($port)"};
        # If the port was found, it is in use:
        If (-NOT ($NULL -EQ $inUse)) {
            # Return the information about the process:
            Return (Get-Process -Id $inUse.P5);
        # The port is not in use:
        } Else {
            Return $NULL;
        }
    }

    <#
    .SYNOPSIS
        Creates and returns a local or remote endpoint object based on the IP and port provided
    .PARAMETER IP
        IP of the endpoint (can be [IPAddress]::Any, as well)
    .PARAMETER port
        UDP port for the endpoint
    .OUTPUTS
        [System.Net.IPEndpoint]. Newly created endpoint
    #>
    static [IPEndpoint] CreateEndpoint([IPAddress]$IP, [Int]$port)
    {
        Return New-Object -TypeName IPEndPoint -ArgumentList $IP, $port;
    }
    #endregion
}