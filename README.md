# clash_wsl2_tools
Proxy config tools that make it convenient for you to connect or disconnect wsl2 with your windows Clash. The following is the steps to finish the config of the tools: 

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

If failed, you can modify your Windows firwall first according to the error information.

5. Start proxy:

```bash
proxy_start
```

6. Stop proxy:

```bash
proxy_stop
```