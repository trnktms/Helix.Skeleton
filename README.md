# Helix.Skeleton

### Purpose of the project
Accelarate Helix based Sitecore project initial setup included with common needs.

### Initial Project setup
 1. Run the `init.ps1` PowerShell script from the `setup` folder, which sets up your solution based on the **newest Sitecore update** `default.9.0.171219.config.json` by default. Here is all the settings what you can change:
```
{
    "projectName": "MyProject",
    "targetFramework": "v4.6.2",
    "nugetTargetFramework": "net462",
    "aspNet": {
        "lib": "net45",
        "mvcVersion": "5.2.3",
        "webPagesVersion": "3.2.3",
        "razorVersion": "3.2.3"
    },
    "sitecore": {
        "version": "9.0.171219",
        "lib": "NET462"
    },
    "glassMapper": {
        "version": "4.5.0.4",
        "lib": "net45",
        "sitecoreVersion": "111",
        "mvcVersion": "Mvc52"
    },
    "castle": {
        "version": "3.3.3",
        "lib": "net45"
    },
    "rainbow": {
        "version": "2.0.0",
        "lib": "net452"
    },
    "rainbowCodeGeneration": {
        "version": "0.3.0",
        "lib": "net452"
    },
    "microsoftDependencyInjection": {
        "version": "1.0.0",
        "lib": "netstandard1.1"
    },
    "microsoftDependencyInjectionAbstraction": {
        "version": "1.0.0",
        "lib": "netstandard1.0"
    },
    "unicorn": {
        "version": "4.0.3",
        "lib": "net452"
    },
    "configy": {
        "version": "1.0.0",
        "lib": "net45"
    },
    "kamsarWebconsole": {
        "version": "2.0.0",
        "lib": "net40"
    },
    "microCHAP": {
        "version": "1.2.2.2",
        "lib": "net45"
    }
}
```

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