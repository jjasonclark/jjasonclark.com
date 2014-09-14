---
layout: post
date: 2009-10-22 18:16:47
comments: true
description: Using TFS to build and deploy a web project
categories: asp.net msbuild programming
tags: asp.net msbuild programming
summary: how I used msbuild to get a web server running
title: Deploying a website with MSBuild and TFS 2008
permalink: /deploy_a_website_with_msbuild_and_tfs_2008
---

# Deploying a website with MSBuild and TFS 2008

This past week I have been working on getting the product that I work on into TFS and building on a regular schedule. This is a basic web application built on the Microsoft stack. We have a web site, a database, and some DLLs for business logic.

Before this change the product was built using a home grown build system built by another team in the company.  It has been a long time since this build process has been updated. Basically it was setup to build and deploy to 1 server and nothing has changed since. This isn't really a problem for the group. All of the changes happen at the solution level or project level which doesn't require any changes to the automated build process.

Now that we have shipped the latest version we have an opportunity to switch to TFS. The team is already using TFS to track bugs and work items so they are anticipating the switch for the build. Linking to source code changes and getting better code coverage results seem to be the most important parts.

In order for this to work I had to translate all of our current batch files into MSBuild tasks. At the same time we are moving from IIS6 to IIS7, so some of the commands need to be updated.  I started by creating a basic TFS build definition. This is because all of the real work is done in the project file.

{% highlight xml %}
<PropertyGroup>
    <SDLTrackWebSitePath>D:\SDLTrackWeb</SDLTrackWebSitePath>
    <SDLTrackDatabasePath>D:\SDLTrackDBs</SDLTrackDatabasePath>
    <SDLTrackUploadPath>D:\SDLTrackFiles</SDLTrackUploadPath>
    <SDLTrackConsolePath>D:\SDLTrackConsole</SDLTrackConsolePath>
    <SDLTrackAgileSDLVersionID>1007</SDLTrackAgileSDLVersionID>
    <SDLTrackClassicSDLVersionID>1008</SDLTrackClassicSDLVersionID>
    <SDLTrackApplicationPool>DailyBuildAppPool</SDLTrackApplicationPool>
    <SDLTrackBaseWebSite>Default Web Site</SDLTrackBaseWebSite>
</PropertyGroup>

<Target Name="AfterEndToEndIteration">
    <CallTarget Targets="CopyWebSiteToIIS" />
    <CallTarget Targets="RegisterWebSiteInIIS" />
    <CallTarget Targets="UpdateWebConfig" />
    <CallTarget Targets="TurnOnWindowsAuthenticationOnly" />
    <CallTarget Targets="DeploySDLTrackConsole" />
</Target>

<Target Name="CopyWebSiteToIIS">
    <Message Text="Copying files from $(OutDir)_PublishedWebsites\Web to $(SDLTrackWebSitePath)\$(BuildNumber)" />
    <ItemGroup>
        <WebFilesToCopy Include="$(OutDir)_PublishedWebsites\Web\**\*.*" />
    </ItemGroup>

    <Copy Condition=" '$(BuildBreak)'!='true' "
        SourceFiles="@(WebFilesToCopy)"
        DestinationFiles="@(WebFilesToCopy ->'$(SDLTrackWebSitePath)\$(BuildNumber)\%(RecursiveDir)%(Filename)%(Extension)')" />

    <Copy Condition=" '$(BuildBreak)'=='true' "
        SourceFiles="@(WebFilesToCopy)"
        DestinationFiles="@(WebFilesToCopy ->'$(SDLTrackWebSitePath)\$(BuildNumber)\%(RecursiveDir)%(Filename)%(Extension)')"
        ContinueOnError="true" />
</Target>

<Target Name="RegisterWebSiteInIIS">
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd add app /site.name:"$(SDLTrackBaseWebSite)" /path:/$(BuildNumber) /physicalPath:$(SDLTrackWebSitePath)\$(BuildNumber) /applicationPool:"$(SDLTrackApplicationPool)"" />
</Target>

<Target Name="UpdateWebConfig">
    <Copy SourceFiles="$(SolutionRoot)\$(TeamProject)\Misc\UnitTest\Setup\Web\ModifyWebConfig\WebTemplate.config"
        DestinationFiles="$(SDLTrackWebSitePath)\$(BuildNumber)\web.config"
        OverwriteReadOnlyFiles="true" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='connectionString'].value:"server=(local);database=$(BuildNumber);integrated security=true;"" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='filePath'].value:"$(SDLTrackUploadPath)\$(BuildNumber)"" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='pluginPath'].value:"$(SDLTrackWebSitePath)\$(BuildNumber)\Bin"" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='currentSDLVersionID'].value:"$(SDLTrackClassicSDLVersionID)"" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='currentAgileSDLVersionID'].value:"$(SDLTrackAgileSDLVersionID)"" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:appSettings /[key='baseWebAddress'].value:"$(ComputerName)/$(BuildNumber)"" />
</Target>

<Target Name="TurnOnWindowsAuthenticationOnly">
    <!-- Set access level to be windows only-->
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:system.webServer/security/authentication/windowsAuthentication /enabled:true /commit:apphost"/>
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:system.web/authentication /mode:Windows" />
    <Exec Command="%SystemRoot%\System32\inetsrv\appcmd set config "$(SDLTrackBaseWebSite)/$(BuildNumber)" /section:system.webServer/security/authentication/anonymousAuthentication /enabled:false /commit:apphost"/>
</Target>

<Target Name="DeploySDLTrackConsole">
    <Copy SourceFiles="$(OutDir)\SWITrackConsole.exe" DestinationFolder="$(SDLTrackConsolePath)\$(BuildNumber)" />
    <Copy SourceFiles="$(SolutionRoot)\$(TeamProject)\Misc\UnitTest\Setup\Console\ModifyAppConfig\SWITrackConsoleTemplate.config"
        DestinationFiles="$(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config"
        OverwriteReadOnlyFiles="true" />
    <Exec Command="echo ^<add key="connectionString" value="Persist Security Info=False;Integrated Security=SSPI;database=$(BuildNumber);server=localhost" /^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
    <Exec Command="echo ^<add key="filePath" value="$(SDLTrackUploadPath)\$(BuildNumber)" /^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
    <Exec Command="echo ^<add key="baseWebAddress" value="$(ComputerName):1%date:~4,2%%date:~7,2%" /^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
    <Exec Command="echo ^<add key="pluginPath" value="$(SDLTrackWebSitePath)\$(BuildNumber)\Bin" /^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
    <Exec Command="echo ^</appSettings^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
    <Exec Command="echo ^</configuration^> >> $(SDLTrackConsolePath)\$(BuildNumber)\SWITrackConsole.config" />
</Target>
{% endhighlight %}