local Manager = {}

Manager.Network    = sdk.get_managed_singleton("app.NetworkManager")
Manager.Player     = sdk.get_managed_singleton("app.PlayerManager")
Manager.Enemy      = sdk.get_managed_singleton("app.EnemyManager")
Manager.GUI        = sdk.get_managed_singleton("app.GUIManager")

return Manager