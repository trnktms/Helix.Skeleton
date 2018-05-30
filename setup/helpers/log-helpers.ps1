# log helpers
function Status($message) {
    Write-Host($message) -Foreground "green"
}

function Info($message) {
    $color = "magenta"
    Write-Host($message) -Foreground $color
}

function InfoDark($message) {
    $color = "darkmagenta"
    Write-Host($message) -Foreground $color
}

function Logo() {
    $color = "darkmagenta"
    Write-Host("   __ ________   _____  __  ______ ________   ______________  _  __")   -Foreground $color
    Write-Host("  / // / __/ /  /  _/ |/_/ / __/ //_/ __/ /  / __/_  __/ __ \/ |/ /")   -Foreground $color
    Write-Host(" / _  / _// /___/ /_>  <  _\ \/ ,< / _// /__/ _/  / / / /_/ /    /")    -Foreground $color 
    Write-Host("/_//_/___/____/___/_/|_| /___/_/|_/___/____/___/ /_/  \____/_/|_/")     -Foreground $color
    Write-Host("")
}