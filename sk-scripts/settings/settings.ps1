# settings
$sk_projectName = "[projectName]"
$sk_subProjectName = "[subProjectName]"

# sk paths
$scriptsRoot = Split-Path -Parent $PSScriptRoot
$root = Split-Path -Parent $scriptsRoot
$templatesDir = Join-Path -Path $root -ChildPath "sk-templates"
$queueDir = Join-Path -Path $root -ChildPath "sk-queue"
$templatesAddDir = Join-Path -Path $templatesDir -ChildPath "add"
$templatesInitDir = Join-Path -Path $templatesDir -ChildPath "init"
$configsDir = Join-Path -Path $root -ChildPath "sk-configs"
$targetDir = Join-Path -Path $root -ChildPath "target"