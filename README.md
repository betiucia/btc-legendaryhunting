 # Como instalar:

 1. **Primeiro** 

 Intale os itens em seu core: 


 # Vorp
INSERT IGNORE INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `groupid`, `metadata`, `desc`, `degradation`, `weight`) VALUES
('legendarymap', 'Mapa de Animais Lendários', 100, 1, 'item_standard', 1, 1, 0, 'Um mapa onde podem ser anotados localizações de animais lendários.', 0, 0.125),
('bearskin', 'Pele de Urso Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 7.0),
('beaverskin', 'Pele de Castor Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 0.8),
('buffaloskin', 'Pele de Bisão Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 10.0),
('alligatorskin', 'Pele de Alligator Lendário', 100, 1, 'item_standard', 1, 1, 0, 'Uma pele de animal lendário.', 0, 6.0),
('mooseskin', 'Pele de Alce Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 9.0),
('boarskin', 'Pele de Javali Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 2.5),
('foxskin', 'Pele de Raposa Lendária', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 0.4),
('phanterskin', 'Pele de Pantera Lendária', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 1.8),
('wolfskin', 'Pele de Lobo Lendária', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 1.25),
('cougarskin', 'Pele de Puma Lendária', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 1.8),
('buckskin', 'Pele de Veado Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 1.25),
('elkskin', 'Pele de Wapiti Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 4.5),
('coyoteskin', 'Pele de Coiote Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 0.7),
('ramskin', 'Pele de Carneiro Selvagem Lendário', 1, 1, 'item_standard', 0, 1, 0, 'Uma pele de animal lendário.', 0, 2.0);


 ### -------------------------------------------------------------------------------------- ##
 
 # RSG

 ---

 ```lua
    legendarymap  = { name = 'legendarymap', label = 'Mapa de Animais Lendários', weight = 125, type = 'item', image = 'legendarymap.png', unique = false, useable = true, shouldClose = true, description = 'Um mapa onde podem ser anotados localizações de animais lendários.' }, -- (Mapa em papel grosso/pergaminho ou com capa leve)
    bearskin      = { name = 'bearskin', label = 'Pele de Urso Lendário', weight = 7000, type = 'item', image = 'bearskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                              -- (Pele de urso grande, curtida)
    beaverskin    = { name = 'beaverskin', label = 'Pele de Castor Lendário', weight = 800, type = 'item', image = 'beaverskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                         -- (Pele de castor grande, curtida)
    buffaloskin   = { name = 'buffaloskin', label = 'Pele de Bisão Lendário', weight = 10000, type = 'item', image = 'buffaloskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                      -- (Pele de bisão grande, curtida)
    alligatorskin = { name = 'alligatorskin', label = 'Pele de Alligator Lendário', weight = 6000, type = 'item', image = 'alligatorskin.png', unique = false, useable = true, shouldClose = true, description = 'Uma pele de animal lendário.' },                               -- (Pele de jacaré grande, curtida)
    mooseskin     = { name = 'mooseskin', label = 'Pele de Alce Lendário', weight = 9000, type = 'item', image = 'mooseskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                            -- (Pele de alce grande, curtida)
    boarskin      = { name = 'boarskin', label = 'Pele de Javali Lendário', weight = 2500, type = 'item', image = 'boarskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                            -- (Pele de javali grande, curtida)
    foxskin       = { name = 'foxskin', label = 'Pele de Raposa Lendária', weight = 400, type = 'item', image = 'foxskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                               -- (Pele de raposa grande, curtida)
    phanterskin   = { name = 'phanterskin', label = 'Pele de Pantera Lendária', weight = 1800, type = 'item', image = 'phanterskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                     -- (Pele de puma/leopardo grande, curtida)
    wolfskin      = { name = 'wolfskin', label = 'Pele de Lobo Lendária', weight = 1250, type = 'item', image = 'wolfskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                              -- (Pele de lobo grande, curtida)
    cougarskin    = { name = 'cougarskin', label = 'Pele de Puma Lendária', weight = 1800, type = 'item', image = 'cougarskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                          -- (Pele de puma grande, curtida)
    buckskin      = { name = 'buckskin', label = 'Pele de Veado Lendário', weight = 1250, type = 'item', image = 'buckskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                             -- (Pele de veado (macho adulto) grande, curtida)
    elkskin       = { name = 'elkskin', label = 'Pele de Wapiti Lendário', weight = 4500, type = 'item', image = 'elkskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                              -- (Pele de wapiti grande, curtida)
    coyoteskin    = { name = 'coyoteskin', label = 'Pele de Coiote Lendário', weight = 700, type = 'item', image = 'coyoteskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                         -- (Pele de coiote grande, curtida)
    ramskin       = { name = 'ramskin', label = 'Pele de Carneiro Selvagem Lendário', weight = 2000, type = 'item', image = 'ramskin.png', unique = true, useable = false, shouldClose = true, description = 'Uma pele de animal lendário.' },                                   -- (Pele de carneiro selvagem grande, curtida)

   ```

### 2.
Em seu server.cfg instale de ensure nas dependências e após as dependencias no script:

ensure btc-core
ensure btc-playerskills **Se Houver, dependência opicional**
ensure btc-legendaryhunting

### 3.
Configure seu script em config.lua e inicie seu servidor.

Dúvidas, abra um ticket em nosso discord.