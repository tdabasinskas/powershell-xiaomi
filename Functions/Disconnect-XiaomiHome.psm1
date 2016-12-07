#region Namespaces/Modules
using module ..\Classes\XiaomiConnection.psm1;
#endregion

<#
.SYNOPSIS
    Closes the connection with Xiaomi Smart Home network
.DESCRIPTION
    The function marks the connection object as non-alive and closes the underlying socket (i.e. stops the local
    UDP servers). It should be always called after finishing work with the active connection, to avoid leaving
    the port opened.
.PARAMETER connection
    Reference to an existing connection
.INPUTS
    [XiaomiConnection]. Connection object
.OUTPUTS
    [Bool]. Result of the connection closing activity
.EXAMPLE
    C:\PS> $Connection = Connect-XiaomiHome; Disconnect-XiaomiHome -Connection $Connection;
    True
#>
Function Disconnect-XiaomiHome
{
    [CmdletBinding()]
    [OutputType([Bool])]
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
        # Is the connection alive:
        If ($Connection.IsAlive) {
            # Try closing the socket:
            Try {
                $Connection.Socket.Close();
                $Connection.IsAlive = $FALSE;
                # Wait a bit:
                Start-Sleep -Seconds 3;
                Return $TRUE;
            # Couldn't close the socket:
            } Catch {
                Write-Error `
                    -Category ProtocolError `
                    -Message "Cannot close the Xiaomi home connection" `
                    -RecommendedAction "Make sure the connection is established";
                Return $FALSE;
            }
        # The connection is already closed:
        } Else {
            Write-Error `
                -Category ProtocolError `
                -Message "The connection is already disconnected" `
                -RecommendedAction "Do not try disconnecting the connection more than once";
            Return $FALSE;
        }
    }
}