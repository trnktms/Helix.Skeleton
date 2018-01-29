
         __ ________   _____  __  ______ ________   ______________  _  __
        / // / __/ /  /  _/ |/_/ / __/ //_/ __/ /  / __/_  __/ __ \/ |/ /
       / _  / _// /___/ /_>  <  _\ \/ ,< / _// /__/ _/  / / / /_/ /    / 
      /_//_/___/____/___/_/|_| /___/_/|_/___/____/___/ /_/  \____/_/|_/

### Purpose of the project
Accelarate Helix based Sitecore project initial setup included with common needs.

### Initial Project setup
 1. Run the `init.ps1` PowerShell script from the `setup` folder, which sets up your solution based on the `default.config.json`
    - `"projectName"`
    - `"sitecoreVersion"` e.g. `8.2.170614`
    - `"glassMapperVersion"` e.g. `4.4.0.199`
    - `"dotnetVersion"` e.g. `net452`
    > If you want to use your own configuration then give this as a parameter like this `.\init.ps1 -config "C:\temp\myconfig.config.json"`
    
 2. Install Sitecore into the `sitecore` folder - Data, Database, Website
 3. Add the `https://sitecore.myget.org/F/sc-packages/api/v3/index.json` to the nuget package sources
 4. Run a build: call the `build\build.cmd`. It deploys all the web projects at once into the `sitecore\Website` folder.
 5. Run the `unicorn_source_setup.ps1` PowerShell script in the `build` folder, which sets the sourceFolder for Unicorn in `sitecore\Website`

### Unicorn sync
 1. Log in the sitecore as admin
 2. Open the unicorn page : {yourdomain/unicorn.aspx}
 3. Syncronise all the projects

> **Note:** Some idea and code implementation based Neil Shack's Helixbase project - https://github.com/muso31/Helixbase 