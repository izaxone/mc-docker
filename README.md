# Minecraft Docker Script

## Setup
1. Make sure you have Docker installed
2. Modify the `apk` command of `Dockerfile` to your needed Java version (default is 17)
3. Create a file called `.env` in your folder, and set the following options: 
- `MC_SERVER_JAR` - The JAR file for the Minecraft server (minecraft.jar, server.jar, bukkit.jar, spigot.jar, paper.jar, forge.jar, ... )
- `START_RAM` - How much RAM to start with -- See -Xms on https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
- `MAX_RAM`- What's the maximum amount of RAM the server should use? See -Xmx on https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
- `MAX_THREADS` - Maximum threads (Java 8 and below only, should be how many CPU cores you have) -- See https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html
- `MC_EULA` - Do you agree to the Minecraft EULA? Set to `true` or `false` (see https://account.mojang.com/documents/minecraft_eula)
4. Place your server jar in the `server/` folder
5. Add any special install commands (setup Spigot, Forge, etc.) into `install.sh`. Do not delete any existing lines. 
6. Run the server using Docker Compose `docker-compose up -d`

If you want to see your logs, use `docker-compose logs minecraft`