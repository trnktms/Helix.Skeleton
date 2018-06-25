# settings
$sk_projectName = "[projectName]"
$sk_subProjectName = "[subProjectName]"
$sk_moduleName = "[moduleName]"

# sk paths
$scriptsRoot = Split-Path -Parent $PSScriptRoot
$root = Split-Path -Parent $scriptsRoot
$templatesDir = Join-Path -Path $root -ChildPath "sk-templates"
$queueDir = Join-Path -Path $root -ChildPath "sk-queue"
$templatesAddModuleDir = Join-Path -Path $templatesDir -ChildPath "add-module"
$templatesAddProjectDir = Join-Path -Path $templatesDir -ChildPath "add-project"
$templatesInitDir = Join-Path -Path $templatesDir -ChildPath "init"
$configsDir = Join-Path -Path $root -ChildPath "sk-configs"
$defaultTargetDir = Join-Path -Path $root -ChildPath "target"