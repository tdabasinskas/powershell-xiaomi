# Disconnect-XiaomiSession

## SYNOPSIS
Closes the connection with Xiaomi Smart Home network

## SYNTAX

```
Disconnect-XiaomiSession [-Connection] <XiaomiSession>
```

## DESCRIPTION
The function marks the connection object as non-alive and closes the underlying socket (i.e.
stops the local
UDP servers).
It should be always called after finishing work with the active connection, to avoid leaving
the port opened.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Connection = Connect-XiaomiSession; Disconnect-XiaomiSession -Connection $Connection;
```

True

## PARAMETERS

### -Connection
Reference to an existing connection

```yaml
Type: XiaomiSession
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

## INPUTS

### [XiaomiSession]. Connection object

## OUTPUTS

### [Bool]. Result of the connection closing activity

## NOTES

## RELATED LINKS

