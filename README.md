# clash_wsl2_tools
> Due to updates to WSL2, this tutorial may not be applicable at the moment, and access to the document has been stopped due to suspected violations.

The clash_wsl2_tools are proxy config tools that make it convenient for you to connect or disconnect WSL2 with your Windows Clash. The following tutorial will show you how to use them: 

1. Download the repo to your WSL2:

```bash
git clone https://github.com/OpenGHz/clash_wsl2_tools.git
```

2. Enter the repo and modify permissions:

```bash
cd clash_wsl2_tools && chmod +x *.sh
```

3. Config the environment:

```bash
source system_proxy_config.sh 7890
```

The 7890 is the default port of Clash, change it to yours. After this step, one line cmds is added to your .zshrc or .bashrc.

4. Check your net:

```bash
proxy_check
```

If failed, you can modify your Windows firewall first according to the error information.

5. Start proxy:

```bash
proxy_start
```

After this cmd, you connect Clash with WSL2. Make sure you open the "Allow LAN" button in your Clash.

6. Stop proxy:

```bash
proxy_stop
```

After this cmd, you disconnect Clash with WSL2.
