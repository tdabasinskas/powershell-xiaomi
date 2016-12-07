#region Namespaces/Modules
using module .\XiaomiConnection.psm1;
#endregion

<#
.SYNOPSIS
    The class stores information about Xiaomi Gateway
.DESCRIPTION
    The class acts as a container to store the key information about a Xiaomi Gateway device, including its SID
    and IP address. Also, it keeps a reference to the connection, which was established to interact with the
    gateway.
#>
Class XiaomiGateway
{
    #region Properties
    # Reference to the network connection
    [XiaomiConnection]$Connection;
    # SID (ID) of the gateway
    [String]$SID;
    # The IP address, used by the gateway
    [IPAddress]$IP;
    # Port of the local server, as reported by the gateway itself
    [Int]$Port;
    #endregion

    #region Constructors
    <#
    .SYNOPSIS
        Class constructor, which captures the gateway information
    .PARAMETER connection
        Reference to the network connection
    .PARAMETER SID
        SID (ID) if the gateway
    .PARAMETER IP
        The IP address, used by the gateway
    .PARAMETER port
        Port of the local server, as reported by the gateway itself
    #>
    XiaomiGateway([XiaomiConnection]$connection, [String]$SID, [IPAddress]$IP, [Int]$port)
    {
        $This.Connection = $connection;
        $This.SID = $SID;
        $This.IP = $IP;
        $This.Port = $port;
    }
    #endregion
}