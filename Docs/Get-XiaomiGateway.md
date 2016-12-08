# Get-XiaomiGateway

## SYNOPSIS
Contacts the gateway(s) and gets their information

## SYNTAX

```
Get-XiaomiGateway [-Connection] <XiaomiConnection>
```

## DESCRIPTION
The function sends a broadcast message to detect all reachable Xiaomi Gateway devices on the network.
Together
with other information, such as SID, we also receive each gateway's IP address, which will be requried to send
other commands and interact with sensors later.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-XiaomiHome | Get-XiaomiGateway;
```

Connection       SID          IP        Port
----------       ---          --        ----
XiaomiConnection f0b429b43e53 10.1.3.10 9898

## PARAMETERS

### -Connection
Reference to an existing connection

```yaml
Type: XiaomiConnection
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### [XiaomiConnection]. Connection object

## OUTPUTS

### [XiaomiGateway[]]. Single or multiple gateway objects

## NOTES

## RELATED LINKS

