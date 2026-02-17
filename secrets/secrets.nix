let
  halleyUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2XO/jdop0eYTD63tm6Rb7IJ/rhi2P5nPsQYgHOexnB";
  mercuryUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtwxzyXwqiJWEr3s2lj70NTzFg4KNGNRsMtdRQmm/Ql";
  users = [ halleyUser mercuryUser ];

  halleySystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEygBeCt8uYEA7iD41Y6CDyT7EP0JyMNruA/x3IRYPnK";
  mercurySystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvn+SBdLErv31xq8raKu7vh6XJm+yL0cCc+HTI3litU";
  plutoSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO32MFZZH2LyLlvw+AYij0/Xy7PCnlctgr2NmT6SEzyh";
  personalSystems = [ halleySystem ];
  serverSystems = [ plutoSystem ];
  systems = personalSystems ++ serverSystems;
in {
  "gmail-username.age".publicKeys = users ++ personalSystems;
  "gmail-password.age".publicKeys = users ++ personalSystems;
}
