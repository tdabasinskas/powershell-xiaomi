# Get-XiaomiTemperature

## SYNOPSIS
Returns data from temperature sensors

## SYNTAX

```
Get-XiaomiTemperature [-Sensor] <XiaomiSensor[]>
```

## DESCRIPTION
The function queries the provided temperature sensors to get the temperature (both C and F) and humidity
information.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-XiaomiHome | Get-XiaomiGateway | Get-XiaomiSensor | Get-XiaomiTemperature | FT
```

SID            ShortID TemperatureC TemperatureF Humidity Gateway
---            ------- ------------ ------------ -------- -------
158d0001178e6b   55693        22.65        72.77    37.45 XiaomiGateway
158d00010f7446   21438        -3.18       26.276    68.56 XiaomiGateway

## PARAMETERS

### -Sensor
The list on sensors that we would like to get the temperature data from

```yaml
Type: XiaomiSensor[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### [XiaomiSensor[]]. The list of Xiaomi sensors

## OUTPUTS

### [XiaomiTemperatureSensor[]]. Temperature data from each thermometer sensor

## NOTES

## RELATED LINKS

