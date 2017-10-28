SET _publishProfile=%cd%\LOCAL.pubxml
SET _solution=%cd:~0,-5%src\Helix.Skeleton.Website.sln
C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe %_solution% /p:DeployOnBuild=true /p:PublishProfile=%_publishProfile%
