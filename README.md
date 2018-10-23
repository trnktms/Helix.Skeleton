# Helix.Skeleton

### Purpose of the project
Accelarate Helix based Sitecore project initial setup and project addition included with common needs.

### How to use your own template, configuration with your project
Just use the following parameters when you call `init.ps1` or `add-project.ps1` or `add-module.ps1` optionally:
- `configPath`
- `templatePath`
- `targetPath`

I suggest to download this repository and put it into your own, so your folder structure would look like this for instance:
- `Helix.Skeleton`
    - `sk-base`
        - `sk-queue`
        - `sk-scripts`
    - `sk-configs`
    - `sk-templates`
    - `target`
- `src`
- `...`

Change the following files/folders if you want to use your own template or configuration:
- `sk-configs\default.9.0.180604.config.json`
- `sk-templates\add-module\default\feature\`
- `sk-templates\add-project\default\feature\`
- `sk-templates\add-project\default\foundation\`
- `sk-templates\init\default\`

Create your own variants of the scripts, e.g.:
- `init.ps1 -targetPath "C:\projects\MyProject\src"`
- `add-project.ps1 -targetPath "C:\projects\MyProject\src"`
- `add-module.ps1 -targetPath "C:\projects\MyProject\src"`

So other developers from the team can use the scripts above.

### Commands
#### init.ps1
 1. Run the `init.ps1` PowerShell script from the `sk-scripts` folder, which sets up your solution based on **Sitecore 9 update 2** `default.9.0.180604.config.json` by default. Here is all the settings what you can change:
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
        "version": "9.0.180604",
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
    },
    "[guid]" : {
        "type" : "guid",
        "format": "D"
    },
    "[[subProjectId]]" : {
        "type" : "guid",
        "format" : "D"
    }
}
```
 2. Install Sitecore into the `sitecore` folder - Data, Database, Website
 3. Add the `https://sitecore.myget.org/F/sc-packages/api/v3/index.json` to the nuget package sources
 4. Run a build: call the `build\build.cmd`. It deploys all the web projects at once into the `sitecore\Website` folder.
 5. Run the `unicorn_source_setup.ps1` PowerShell script in the `build` folder, which sets the sourceFolder for Unicorn in `sitecore\Website`

#### add-project.ps1
 1. Run the `add-project.ps1` command with 2 required parameters:
    - `subProjectName`: name of the new project (e.g. `Navigation`)
    - `templateName`: name of the subfolder from `.\sk-templates\default` (`feature` or `foundation`)
 2. This command uses the same `default.9.0.180604.config.json` config above
 3. Include the newly generated project to your Visual Studio solution manually

#### add-module.ps1
 1. Run the `add-module.ps1` command with 3 required parameters:
    - `moduleName`: name of the new module (e.g. `TextModule`)
    - `subProjectName`: name of the new project (e.g. `Navigation`)
    - `templateName`: name of the subfolder from `.\sk-templates\default` (`feature` or `foundation`)
 2. This command uses the same `default.9.0.180604.config.json` config above
 3. Include the newly generated files to your Visual Studio project manually

For more documentation about the generator, checkout the base project: https://github.com/trnktms/sk-base

**Important: your JSON configuration should be in sync with your template!**

### Unicorn sync
 1. Log in the sitecore as admin
 2. Open the unicorn page : {yourdomain/unicorn.aspx}
 3. Syncronise all the projects

> **Note:** Some idea and code implementation based Neil Shack's Helixbase project - https://github.com/muso31/Helixbase 