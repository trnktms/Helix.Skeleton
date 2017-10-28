
# Helix.Skeleton

### Project setup
 1. Run the `setup.ps1` PowerShell script in the `setup` folder, which sets up your solution based on the given `-ProjectName`
 2. Install Sitecore into the `sitecore` folder - Data, Database, Website
 3. Run a build: call the `build\build.cmd`. It deploys all the web projects at once into the `sitecore\Website` folder.
 4. Run the `unicorn_source_setup.ps1` PowerShell script in the `build` folder, which sets the sourceFolder for Unicorn in `sitecore\Website`
 5. Add the `https://sitecore.myget.org/F/sc-packages/api/v3/index.json` to the nuget package sources

### Unicorn sync
 1. Log in the sitecore as admin
 2. Open the unicorn page : {yourdomain/unicorn.aspx}
 3. Syncronise all the projects

> **Note:** Some idea and code implementation based Neil Shack's Helixbase project - https://github.com/muso31/Helixbase