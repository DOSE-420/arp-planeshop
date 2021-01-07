ARPAeroshop = ARPAeroshop or {}

ARPAeroshop.Hangars = {
    ["lsia"] = {
      label = "Airplane Shop",
        coords = {
            take = {
                x = -1874.14, 
                y = -3135.52, 
                z = 13.94,
            },
            put = {
                x = -1876.49, 
                y = -3138.52, 
                z = 13.94,
                h = 321.38,
            }
        }
    },
    --[[["paletto"] = {
        label = "Paleto BoatHouse",
        coords = {
            take = {
                x = -277.46, 
                y = 6637.2, 
                z = 7.48,
            },
            put = {
                x = -289.2, 
                y = 6637.96, 
                z = 1.01,
                h = 45.5,
            }
        }
    },    
    ["millars"] = {
        label = "Millars BoatHouse",
        coords = {
            take = {
                x = 1299.24, 
                y = 4216.69, 
                z = 33.9, 
            },
            put = {
                x = 1297.82, 
                y = 4209.61, 
                z = 30.12, 
                h = 253.5,
            }
        }
    },--]]
}

ARPAeroshop.Depots = {
    [1] = {
        label = "Airplane Depot",
        coords = {
            take = {
                x = -1601.19, 
                y = -3160.11, 
                z = 13.96, 
            },
            put = {
                x = -1601.19, 
                y = -3160.11, 
                z = 13.96, 
                h = 322.69,
            }
        }
    },
}

ARPAeroshop.Locations = {
    ["berths"] = {
        [1] = {
            ["aeroModel"] = "havok",
            ["coords"] = {
                ["aero"] = {
                    ["x"] = -1648.42,
                    ["y"] = -3136.29,
                    ["z"] = 13.99,
                    ["h"] = 328.35
                },
                ["buy"] = {
                    ["x"] = -1647.39,
                    ["y"] = -3134.48,
                    ["z"] = 13.99,
                },
            },
            ["inUse"] = false
        },
        -- [2] = {
        --     ["aeroModel"] = "dinghy",
        --     ["coords"] = {
        --         ["aero"] = {
        --             ["x"] = -774.99, 
        --             ["y"] = -1385.0, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [3] = {
        --     ["aeroModel"] = "dinghy",
        --     ["coords"] = {
        --         ["aero"] = {
        --             ["x"] = -780.66, 
        --             ["y"] = -1391.73, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [4] = {
        --     ["aeroModel"] = "dinghy",
        --     ["coords"] = {
        --         ["aero"] = {
        --             ["x"] = -786.47, 
        --             ["y"] = -1398.6, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [5] = {
        --     ["aeroModel"] = "dinghy",
        --     ["coords"] = {
        --         ["aero"] = {
        --             ["x"] = -792.27, 
        --             ["y"] = -1405.48, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
    }
}

ARPAeroshop.ShopPlanes = {
    ["havok"] = {
        ["model"] = "havok",
        ["label"] = "Havok",
        ["price"] = 30000
    },
}

ARPAeroshop.SpawnVehicle = {
    x = -1560.04, 
    y = -3014.39, 
    z = 13.94, 
    h = 239.03,
}