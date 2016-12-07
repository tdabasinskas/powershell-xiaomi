![logo](https://cloud.githubusercontent.com/assets/7723360/20984979/2284bb0a-bccb-11e6-9f8d-939c2ed43125.png)

## Description
This is a [PowerShell](https://msdn.microsoft.com/powershell) module, which allows to interact with [**Xiaomi Mi Smart Home**](http://xiaomi-mi.com/mi-smart-home) devices programmatically. The module contains a group of functions, that you can easily integrate with other scripts and tools, to work with the information provivided by the Xiaomi Smart Home sensors. One of such cases, can be using this script to query the temperature data from the temperature sensor regually and then using some other script or a tool to draw temperature graphs.

Currently, the number of supported devices is limited, as well as only read-only actions are supported. Anyhow, there are plans to provide support for additional sensors in the near future.

## Prerequisites
1. For starters, you need to have a [Xiaomi Mi Smart Home Gateway](http://xiaomi-mi.com/smart-home/xiaomi-mi-gateway-2).
1. You probably want to have at least one sensor, e.g. [temperature/humidity one](http://xiaomi-mi.com/smart-home/xiaomi-mi-temperature-humidity-sensor/), as well.
1. To be able to access the gateway over the network, you must have developer mode unlocked by following these steps:
 1. Download the latest version of [MiHome application](https://play.google.com/store/apps/details?id=com.xiaomi.smarthome) to your Android device (yes, at the moment, developer mode can be enabled only via Android).
 1. Follow the in-app instructions to connect the application to your Xiaomi Mi Smart Home Gateway.
 1. Once the Gateway is added, open the Gateway settings and devigate to *About* section.
 1. At the bottom of *About* sections, there should be the version number listed. Click it multiple times until you see to additional options (both in Chinese) appearing above.
 1. Click the first new option (the one with the longer Chinese name).
 1. Take a note of the 16 symbol key you see on the second line. You might need this key for the write operations.
 1. Activate the first option and click the right Chinese button (probably meaning *OK*) at the bottom. The developer mode should be active now.
1. You also need [Windows Management Framework 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=50395) (or above) to use the module.

## Installation
The module is published in [PowerShell Gallery repository](https://www.powershellgallery.com/packages/Xiaomi/0.1), so the easiest way to install it is from there. Simply run the following command in you PowerShell prompt:
```powershell
Install-Module -Name Xiaomi;
```
To confirm the module is successfully installed and see all the available functions, use the following command


```powershell
Get-Command -Module Xiaomi;
```
## Examples
### Getting the key information about the gateway(s)
The following example can be used as the simplest test to see if all (any) gateway devices on the network are reachable.
```powershell
# Initate the connection:
$Connection = Connect-XiaomiHome;
# Get the gateway(s) information:
$Connection | Get-XiaomiGateway;
# Close the connection:
$Connection | Disconnect-XiaomiHome;
```
### Getting the list of sensors attached to the gateway(s)
This example shows how to get the list of all the sensors attached to the gateway(s). It might be a good idea to run it to make sure that all the sensors are discovered, before performing any actions on them.
```powershell
# Initate the connection:
$Connection = Connect-XiaomiHome;
# Get the gateway(s) and all the sensors attached the each of them:
$Connection | Get-XiaomiGateway | Get-XiaomiSensor;
# Close the connection:
$Connection | Disconnect-XiaomiHome;
```
### Keep querying temperature and humidity information every 10 seconds:
This is a more detailed example, which keeps querying data from the temperature sensors every few seconds. Also, this time we are passing the parameters to the functions directly, instead providing them via a pipeline as in the previous examples.
```powershell
# Initate the connection:
$Connection = Connect-XiaomiHome;
# Get the gateway(s):
$Gateway = Get-XiaomiGateway -Connection $Connection;
# Get all the sensors:
$Sensor = Get-XiaomiSensor -Gateway $Gateway;
# Keep querying and printing temperature/humidity every 10 seconds:
While ($TRUE) {
    Get-XiaomiTemperature -Sensor $Sensor | FT;
    Start-Sleep -Seconds 10;
}
# Close the connection:
$Connection | Disconnect-XiaomiHome;
```
## References

The following resources were invaluable in writing this PowerShell module:
- https://github.com/jon1012/mihome
- https://notes.jmsinfor.com/blog/post/admin/Xiaomi-Hub
- https://louiszl.gitbooks.io/lumi-gateway-local-api/content/
- http://bbs.xiaomi.cn/t-13198850
- https://github.com/rockmanqh/blynk-aquara

Thank you!
