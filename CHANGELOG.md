# Changelog

## v0.2 - 2016-12-28
- Some functions and classes were renamed:
  - Class `XiaomiConnection` renamed to [`XiaomiSession`](./Classes/XiaomiSession.psm1)
  - Function `Connect-XiaomiHome` renamed to [`Connect-XiaomiSession`](./Functions/Connect-XiaomiSession.psm1)
  - Function `Disconnect-XiaomiHome` renamed to [`Disconnect-XiaomiSession`]((./Functions/Disconnect-XiaomiSession.psm1))
- `Connect-XiaomiSession` now supports optional `-LocalIP` parameter (related to the [Issue #2](../../issues/2))

## v0.1 - 2016-12-07
- Initial version