# Connect-XiaomiHome

## SYNOPSIS
Initializes and returns a connection with Xiaomi Smart Home network

## SYNTAX

```
Connect-XiaomiHome [[-MulticastGroup] <String>] [[-MulticastPeerPort] <Int32>] [[-LocalPort] <Int32>]
```

## DESCRIPTION
The function creates a local UDP server, which is going to be used to interact with the Xiaomi Gateway device,
as well as all the sensors.
The local server joins the same multicast group as the gateway device, as the
initial gateway discovery is being done via multicast.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-XiaomiHome
```

Socket            : System.Net.Sockets.UdpClient
IsAlive           : True
LocalPort         : 9882
MulticastGroup    : 224.0.0.50
MulticastPeerPort : 4321

## PARAMETERS

### -MulticastGroup
The multicast group, to which the newly created UDP server should join.
If not specified, 224.0.0.50 is used,
as per Xiaomi documentation

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: 224.0.0.50
Accept pipeline input: False
Accept wildcard characters: False
```

### -MulticastPeerPort
The number of multicast peer port, required for sending the initial message to the gateways on the network.
If not specified, 4321 is used, as per Xiaomi documentation

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: 4321
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalPort
The number of the UDP port, which is going to be used to listen on the local computer.
If not specified, 9882
is used, as per Xiaomi documentation

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 9882
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### [XiaomiConnection]. An object, containing information about the initialized connection

## NOTES

## RELATED LINKS

