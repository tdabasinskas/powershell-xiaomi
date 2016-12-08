# Get-XiaomiSensor

## SYNOPSIS
Returns the sensors attached to the gateway(s)

## SYNTAX

```
Get-XiaomiSensor [-Gateway] <XiaomiGateway[]>
```

## DESCRIPTION
The function loops through the list of Xiaomi Gateway devices passed to it and gets the list of sensors
attached to it.
In addition, it also trys querying each sensor, to get some key information about it.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-XiaomiHome | Get-XiaomiGateway | Get-XiaomiSensor | FT
```

Gateway       SID            ShortID Model      Token           RawData
-------       ---            ------- -----      -------         -------
XiaomiGateway 158d0001178e6b   55693 sensor_ht  a1d700000lmn03  @{temperature=2265; humidity=3745}
XiaomiGateway 158d00010f7446   21438 sensor_ht  a1d700000lmn03  @{temperature=-267; humidity=6700}

## PARAMETERS

### -Gateway
Reference(s) to the Xiaomi Gataway instance(s)

```yaml
Type: XiaomiGateway[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### [XiaomiGateway[]]. The list of Xiaomi Gateways

## OUTPUTS

### [XiaomiSensor[]]. The list of sensors attached to the gateway(s)

## NOTES

## RELATED LINKS

