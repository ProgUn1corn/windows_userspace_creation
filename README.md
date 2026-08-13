# windows_userspace_creation
Create Windows UserSpace folders similar to XDG user dirs

## userspace_creation.ps1

A PowerShell script that creates a unified `UserSpace` directory inside the user's profile and relocates Windows Known Folders (Desktop, Documents, Downloads, Music, Pictures, Videos) into this new structure.

The UserSpace contains Assets, Desktop, Documents, Downloads, Games, Music, Projects, Resources, Utils, Pictures, Videos, VSTPlugins.

It also migrates existing folder contents, updates registry paths, and refreshes Explorer so the changes take effect immediately.
