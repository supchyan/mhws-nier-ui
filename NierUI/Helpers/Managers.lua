local Managers = {}

Managers.Network    = sdk.get_managed_singleton("app.NetworkManager")
Managers.Player     = sdk.get_managed_singleton("app.PlayerManager")
Managers.Enemy      = sdk.get_managed_singleton("app.EnemyManager")
Managers.GUI        = sdk.get_managed_singleton("app.GUIManager")

return Managers