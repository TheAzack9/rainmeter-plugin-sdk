This is a forked copy of the Rainmeter plugin repo and is just a simple configuration to make it easier to build plugins for c++. I have removed the C# dependencies and examples the came with the original project.
If you are new to creating plugins do i suggest starting out with the plugin repo that is officially created from the rainmeter team. The documentation might not be of much help, but i still recommend reading it: [documentation](https://github.com/rainmeter/rainmeter-plugin-sdk/wiki/C---plugin-API).

The things that is different with this project is a few things:
*   I have added some resource variables, so instead of having to change plugin version and copyright information in the rc file can you simply change it in version.h and it will be fetched from there. I find the rc file can be weird at times and prefer this myself.
*   The plugin name is the name of the project itself, so to rename the plugin do you only need to rename the project in visual studio. Note that i say project and not Solution!
*   I added a pre build step to cleanup the old build, this is just something i prefer myself since i can find myself renaming the plugin and it just saves me a small delete. ;)


See the original Rainmeter plugin repo for additional information:
[Repo](https://github.com/rainmeter/rainmeter-plugin-sdk)