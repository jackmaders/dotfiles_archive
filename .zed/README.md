# Zed C# and Godot setup

The C# settings select `csharp-ls`, which is installed by the NixOS
configuration. Zed's C# language support comes from the C# extension; install
it from Zed's Extensions panel if it is not already installed.

The `netcoredbg` adapter is provided by the community
[zed-netcoredbg extension](https://github.com/qwadrox/zed-netcoredbg). Install
that extension in Zed, then use the included debug configuration. It launches
the Godot Mono executable on the opened worktree. The `dotnet build` task
assumes the opened worktree contains a .NET project or solution.
